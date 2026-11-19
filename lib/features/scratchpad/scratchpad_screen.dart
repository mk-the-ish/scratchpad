import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/database/app_database.dart';
import '../../core/parser/scratchpad_parser.dart';
import 'nightly_sweep_sheet.dart';
import 'quick_capture_bar.dart';

class ScratchpadScreen extends StatefulWidget {
  final AppDatabase database;

  const ScratchpadScreen({super.key, required this.database});

  @override
  State<ScratchpadScreen> createState() => _ScratchpadScreenState();
}

class _ScratchpadScreenState extends State<ScratchpadScreen> {
  void _addItem(ParsedResult result) async {
    final entry = HorizonEntriesCompanion(
      id: drift.Value(DateTime.now().microsecondsSinceEpoch.toString()),
      type: drift.Value(result.type == EntryType.expense ? 'expense' : 'task'),
      title: drift.Value(result.title),
      isTopLever: drift.Value(result.isTopLever),
      scheduledTime: drift.Value(result.scheduledTime),
      amount: drift.Value(result.amount ?? 0.0),
      currency: drift.Value(result.currency == CurrencyType.zig ? 'zig' : 'usd'),
      wallet: drift.Value(result.walletHint ?? 'USD Cash'),
      category: drift.Value(result.category?.name ?? 'general'),
      createdAt: drift.Value(DateTime.now()),
    );

    await widget.database.insertEntry(entry);
  }


  void _cycleWallet(HorizonEntry item) async {
    HapticFeedback.selectionClick();
    String nextWallet = 'USD Cash';
    if (item.wallet == 'USD Cash') {
      nextWallet = 'EcoCash USD';
    } else if (item.wallet == 'EcoCash USD') {
      nextWallet = 'ZiG Account';
    }
    await widget.database.updateWallet(item.id, nextWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Z',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Personal OS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.nightlight_round,
              color: Color(0xFFF59E0B),
              size: 20,
            ),
            tooltip: 'Nightly Sweep',
            onPressed: () => NightlySweepSheet.show(context, widget.database),
          ),
        ],
      ),
      body: StreamBuilder<List<HorizonEntry>>(
        stream: widget.database.watchTodayEntries(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          final topLevers = items.where((i) => i.type == 'task' && i.isTopLever).toList();
          final regularStream = items.where((i) => !i.isTopLever).toList();

          // Calculate daily variable burn totals directly from SQLite data
          final usdBurn = items
              .where((i) => i.type == 'expense' && i.currency == 'usd')
              .fold(0.0, (sum, i) => sum + i.amount);
          final zigBurn = items
              .where((i) => i.type == 'expense' && i.currency == 'zig')
              .fold(0.0, (sum, i) => sum + i.amount);

          return Column(
            children: [
              _buildDailyBurnBar(usdBurn, zigBurn),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  children: [
                    if (topLevers.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, size: 16, color: Color(0xFFEF4444)),
                          const SizedBox(width: 6),
                          Text(
                            'TOP LEVERS (${topLevers.length}/3)',
                            style: const TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...topLevers.map((item) => _buildDismissibleTile(item)),
                      const SizedBox(height: 18),
                    ],

                    Row(
                      children: [
                        const Icon(Icons.stream, size: 15, color: Color(0xFF737373)),
                        const SizedBox(width: 6),
                        const Text(
                          'DAILY SCRATCHPAD & SPEND',
                          style: TextStyle(
                            color: Color(0xFF737373),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.flash_on_outlined, size: 36, color: Colors.white.withOpacity(0.15)),
                              const SizedBox(height: 10),
                              Text(
                                'Horizon clear. SQLite database ready.',
                                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...regularStream.map((item) => _buildDismissibleTile(item)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: QuickCaptureBar(onSubmit: _addItem),
    );
  }

  Widget _buildDailyBurnBar(double usdBurn, double zigBurn) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 15, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Today\'s Burn',
                style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'USD \$${usdBurn.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 1, height: 12, color: Colors.white.withOpacity(0.15)),
              const SizedBox(width: 10),
              Text(
                'ZiG ${zigBurn.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleTile(HorizonEntry item) {
    return Dismissible(
      key: Key(item.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: Icon(
          item.isCompleted ? Icons.undo : Icons.check_circle,
          color: const Color(0xFF10B981),
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          HapticFeedback.selectionClick();
          await widget.database.toggleCompleted(item.id, item.isCompleted);
          return false;
        } else {
          HapticFeedback.mediumImpact();
          await widget.database.deleteEntry(item.id);
          return true;
        }
      },
      child: _buildItemCard(item),
    );
  }

  Widget _buildItemCard(HorizonEntry item) {
    final isExpense = item.type == 'expense';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isTopLever
              ? const Color(0xFFEF4444).withOpacity(0.35)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              widget.database.toggleCompleted(item.id, item.isCompleted);
            },
            child: Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: item.isCompleted
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : isExpense
                        ? const Color(0xFF10B981).withOpacity(0.12)
                        : Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isCompleted
                      ? const Color(0xFF10B981)
                      : isExpense
                          ? const Color(0xFF10B981).withOpacity(0.3)
                          : Colors.white.withOpacity(0.2),
                ),
              ),
              child: Icon(
                item.isCompleted
                    ? Icons.check
                    : isExpense
                        ? Icons.arrow_downward_rounded
                        : Icons.circle,
                size: 13,
                color: item.isCompleted
                    ? const Color(0xFF10B981)
                    : isExpense
                        ? const Color(0xFF10B981)
                        : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.isCompleted ? const Color(0xFF737373) : Colors.white,
                    fontSize: 14,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (item.scheduledTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Due ${item.scheduledTime}',
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isExpense) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.currency == 'zig'
                      ? 'ZiG ${item.amount.toStringAsFixed(2)}'
                      : '\$${item.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: () => _cycleWallet(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item.wallet} ⇄',
                      style: const TextStyle(
                        color: Color(0xFFA3A3A3),
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}