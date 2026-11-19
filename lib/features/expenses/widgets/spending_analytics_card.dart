import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';

class CategoryBreakdown {
  final String category;
  final double amount;
  final Color color;

  CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.color,
  });
}

class SpendingAnalyticsCard extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final double totalSpent;
  final double budgetLimit;
  final List<CategoryBreakdown> breakdown;

  const SpendingAnalyticsCard({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.totalSpent,
    required this.budgetLimit,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budgetLimit > 0 ? (totalSpent / budgetLimit).clamp(0.0, 1.0) : 0.0;
    final isOverWarning = progress >= 0.85;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.obsidianDeep,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.obsidianDeep.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Label + Currency Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MONTHLY OUTFLOW',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
              _CurrencyToggle(
                selected: selectedCurrency,
                onChanged: onCurrencyChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Figure
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                selectedCurrency == 'USD' ? '\$' : 'ZiG ',
                style: const TextStyle(
                  color: AppColors.transitTeal,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                totalSpent.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Segmented Category Bar
          if (totalSpent > 0 && breakdown.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: breakdown.map((item) {
                    final flex = ((item.amount / totalSpent) * 1000).round().clamp(1, 1000);
                    return Expanded(
                      flex: flex,
                      child: Container(
                        margin: const EdgeInsets.only(right: 2),
                        color: item.color,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Category Legend Chips
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: breakdown.take(4).map((item) {
                final pct = ((item.amount / totalSpent) * 100).toStringAsFixed(0);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.category} ($pct%)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ] else ...[
            Text(
              'No expenses logged in $selectedCurrency this month.',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],

          // Optional Budget Indicator
          if (budgetLimit > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: Colors.white12, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOverWarning ? 'Approaching monthly cap' : 'Monthly budget target',
                  style: TextStyle(
                    color: isOverWarning ? AppColors.alertAmber : Colors.white60,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% of ${budgetLimit.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'JetBrains Mono',
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

class _CurrencyToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _CurrencyToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: ['USD', 'ZiG'].map((currency) {
          final isSelected = selected == currency;
          return GestureDetector(
            onTap: () => onChanged(currency),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.transitTeal : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currency,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}