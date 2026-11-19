import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';

class AddExpenseSheet extends StatefulWidget {
  final String initialCurrency;
  final Future<void> Function({
    required double amount,
    required String currency,
    required String category,
    required String note,
    required DateTime date,
  }) onSave;

  const AddExpenseSheet({
    super.key,
    required this.initialCurrency,
    required this.onSave,
  });

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late String _currency;
  String _selectedCategory = 'Food & Groceries';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  static const _categories = [
    ('Food & Groceries', Icons.restaurant_rounded),
    ('Transport & Fuel', Icons.directions_car_rounded),
    ('Data & Airtime', Icons.wifi_rounded),
    ('Utilities & Bills', Icons.bolt_rounded),
    ('Software & Gear', Icons.laptop_mac_rounded),
    ('Other', Icons.category_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _currency = widget.initialCurrency;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _isSaving = true);
    await widget.onSave(
      amount: amount,
      currency: _currency,
      category: _selectedCategory,
      note: _noteController.text.trim(),
      date: _selectedDate,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Currency Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Log Expense',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.obsidianDeep,
                ),
              ),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'USD', label: Text('USD')),
                  ButtonSegment(value: 'ZiG', label: Text('ZiG')),
                ],
                selected: {_currency},
                onSelectionChanged: (val) => setState(() => _currency = val.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount Input
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: 'JetBrains Mono',
              color: AppColors.obsidianDeep,
            ),
            decoration: InputDecoration(
              prefixText: _currency == 'USD' ? '\$ ' : 'ZiG ',
              prefixStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.transitTeal,
              ),
              hintText: '0.00',
              filled: true,
              fillColor: AppColors.cloudWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Chips
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.safeSlate,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat.$1;
              return ChoiceChip(
                avatar: Icon(
                  cat.$2,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.safeSlate,
                ),
                label: Text(cat.$1),
                selected: isSelected,
                selectedColor: AppColors.transitTeal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.obsidianDeep,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
                onSelected: (_) => setState(() => _selectedCategory = cat.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Note & Date Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Note (e.g., Kombi, Lunch, Bundles)',
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.cloudWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: Text(
                  _selectedDate.day == DateTime.now().day &&
                          _selectedDate.month == DateTime.now().month
                      ? 'Today'
                      : '${_selectedDate.day}/${_selectedDate.month}',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.obsidianDeep,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _isSaving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.transitTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Save Transaction',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}