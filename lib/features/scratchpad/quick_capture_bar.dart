import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/parser/scratchpad_parser.dart';

class QuickCaptureBar extends StatefulWidget {
  final ValueChanged<ParsedResult> onSubmit;

  const QuickCaptureBar({
    super.key,
    required this.onSubmit,
  });

  @override
  State<QuickCaptureBar> createState() => _QuickCaptureBarState();
}

class _QuickCaptureBarState extends State<QuickCaptureBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ParsedResult? _currentParsed;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      setState(() => _currentParsed = null);
    } else {
      setState(() {
        _currentParsed = ScratchpadParser.parse(text);
      });
    }
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty || _currentParsed == null) return;

    HapticFeedback.lightImpact();
    widget.onSubmit(_currentParsed!);

    _controller.clear();
    setState(() => _currentParsed = null);
    // Keep focus so consecutive items can be entered in rapid succession
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Dynamic Live Parsing Pill
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _currentParsed != null && _controller.text.trim().isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildParsingPill(_currentParsed!),
                    )
                  : const SizedBox.shrink(),
            ),

            // 2. Main Input Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? const Color(0xFFF59E0B).withOpacity(0.4)
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                      cursorColor: const Color(0xFFF59E0B),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSubmit(),
                      decoration: const InputDecoration(
                        hintText: "Try '\$1.50 combi' or '! bursar report'...",
                        hintStyle: TextStyle(
                          color: Color(0xFF737373),
                          fontSize: 13,
                          fontFamily: 'sans-serif',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Submit Action Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _handleSubmit,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Color(0xFF0A0A0A),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParsingPill(ParsedResult result) {
    if (result.type == EntryType.expense) {
      final isZig = result.currency == CurrencyType.zig;
      final currencyPrefix = isZig ? 'ZiG' : 'USD';
      final formattedAmount = result.amount != null
          ? '$currencyPrefix ${result.amount!.toStringAsFixed(2)}'
          : '$currencyPrefix --';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.payments_outlined,
              size: 14,
              color: Color(0xFF10B981),
            ),
            const SizedBox(width: 6),
            Text(
              formattedAmount,
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '•  ${_categoryLabel(result.category)} (${result.walletHint})',
              style: TextStyle(
                color: const Color(0xFF10B981).withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else {
      final isTopLever = result.isTopLever;
      final pillColor = isTopLever ? const Color(0xFFEF4444) : const Color(0xFF38BDF8);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: pillColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: pillColor.withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isTopLever ? Icons.local_fire_department : Icons.check_circle_outline,
              size: 14,
              color: pillColor,
            ),
            const SizedBox(width: 6),
            Text(
              isTopLever ? 'Top Lever Task' : 'Daily Task',
              style: TextStyle(
                color: pillColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (result.scheduledTime != null) ...[
              const SizedBox(width: 6),
              Text(
                '•  Due ${result.scheduledTime}',
                style: TextStyle(
                  color: pillColor.withOpacity(0.85),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
      );
    }
  }

  String _categoryLabel(ExpenseCategory? category) {
    switch (category) {
      case ExpenseCategory.transit:
        return 'Transit';
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.dataAirtime:
        return 'Data/Airtime';
      case ExpenseCategory.utilities:
        return 'Utilities';
      default:
        return 'General';
    }
  }
}