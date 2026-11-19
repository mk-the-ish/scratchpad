import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import 'widgets/add_expense_sheet.dart';
import 'widgets/spending_analytics_card.dart';

// Replace with your actual Drift data class if named differently
class ExpenseItem {
  final int id;
  final double amount;
  final String currency;
  final String category;
  final String note;
  final DateTime date;

  ExpenseItem({
    required this.id,
    required this.amount,
    required this.currency,
    required this.category,
    required this.note,
    required this.date,
  });
}

class ExpensesScreen extends StatefulWidget {
  final Stream<List<ExpenseItem>> Function(DateTime month, String currency) watchExpenses;
  final Future<void> Function({
    required double amount,
    required String currency,
    required String category,
    required String note,
    required DateTime date,
  }) onAddExpense;
  final Future<void> Function(int id) onDeleteExpense;

  const ExpensesScreen({
    super.key,
    required this.watchExpenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _selectedCurrency = 'USD';
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  static const _categoryColors = {
    'Food & Groceries': AppColors.transitTeal,
    'Transport & Fuel': AppColors.alertAmber,
    'Data & Airtime': Color(0xFF3B82F6),
    'Utilities & Bills': Color(0xFF8B5CF6),
    'Software & Gear': AppColors.activeMint,
    'Other': Color(0xFF94A3B8),
  };

  List<CategoryBreakdown> _computeBreakdown(List<ExpenseItem> items) {
    final map = <String, double>{};
    for (final item in items) {
      map[item.category] = (map[item.category] ?? 0) + item.amount;
    }
    final list = map.entries.map((e) {
      return CategoryBreakdown(
        category: e.key,
        amount: e.value,
        color: _categoryColors[e.key] ?? const Color(0xFF94A3B8),
      );
    }).toList();
    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddExpenseSheet(
        initialCurrency: _selectedCurrency,
        onSave: widget.onAddExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cloudWhite,
      appBar: AppBar(
        backgroundColor: AppColors.cloudWhite,
        elevation: 0,
        title: const Text(
          'Expenses',
          style: TextStyle(
            color: AppColors.obsidianDeep,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: AppColors.obsidianDeep),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              });
            },
          ),
          Center(
            child: Text(
              '${_monthName(_selectedMonth.month)} ${_selectedMonth.year}',
              style: const TextStyle(
                color: AppColors.obsidianDeep,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: AppColors.obsidianDeep),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ExpenseItem>>(
        stream: widget.watchExpenses(_selectedMonth, _selectedCurrency),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          final totalSpent = items.fold<double>(0, (sum, e) => sum + e.amount);
          final breakdown = _computeBreakdown(items);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              SpendingAnalyticsCard(
                selectedCurrency: _selectedCurrency,
                onCurrencyChanged: (val) => setState(() => _selectedCurrency = val),
                totalSpent: totalSpent,
                budgetLimit: _selectedCurrency == 'USD' ? 500 : 15000,
                breakdown: breakdown,
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.obsidianDeep,
                ),
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Text(
                    'Tap + to record your first expense',
                    style: TextStyle(color: AppColors.safeSlate),
                  ),
                )
              else
                ...items.map((tx) => _TransactionTile(
                      item: tx,
                      color: _categoryColors[tx.category] ?? AppColors.safeSlate,
                      onDelete: () => widget.onDeleteExpense(tx.id),
                    )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        backgroundColor: AppColors.transitTeal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[month - 1];
  }
}

class _TransactionTile extends StatelessWidget {
  final ExpenseItem item;
  final Color color;
  final VoidCallback onDelete;

  const _TransactionTile({
    required this.item,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_long_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.note.isNotEmpty ? item.note : item.category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.obsidianDeep,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.category} • ${item.date.day}/${item.date.month}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.safeSlate,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '-${item.currency == 'USD' ? '\$' : 'ZiG '}${item.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'JetBrains Mono',
                color: AppColors.obsidianDeep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}