import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/database/app_database.dart';

class NightlySweepSheet extends StatefulWidget {
  final AppDatabase database;
  final VoidCallback onSweepComplete;

  const NightlySweepSheet({
    super.key,
    required this.database,
    required this.onSweepComplete,
  });

  static Future<void> show(BuildContext context, AppDatabase database) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NightlySweepSheet(
        database: database,
        onSweepComplete: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<NightlySweepSheet> createState() => _NightlySweepSheetState();
}

class _NightlySweepSheetState extends State<NightlySweepSheet> {
  List<HorizonEntry> _uncompletedTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUncompleted();
  }

  Future<void> _loadUncompleted() async {
    final tasks = await widget.database.getIncompleteTodayTasks();
    if (mounted) {
      setState(() {
        _uncompletedTasks = tasks;
        _isLoading = false;
      });
    }
  }

  Future<void> _rollToTomorrow(String id) async {
    HapticFeedback.lightImpact();
    await widget.database.rollTaskToTomorrow(id);
    setState(() => _uncompletedTasks.removeWhere((t) => t.id == id));
    _checkEmpty();
  }

  Future<void> _dropTask(String id) async {
    HapticFeedback.mediumImpact();
    await widget.database.deleteEntry(id);
    setState(() => _uncompletedTasks.removeWhere((t) => t.id == id));
    _checkEmpty();
  }

  Future<void> _sweepAllToTomorrow() async {
    HapticFeedback.heavyImpact();
    for (final task in _uncompletedTasks) {
      await widget.database.rollTaskToTomorrow(task.id);
    }
    widget.onSweepComplete();
  }

  void _checkEmpty() {
    if (_uncompletedTasks.isEmpty) {
      widget.onSweepComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.nightlight_round, color: Color(0xFFF59E0B), size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Nightly Sweep",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              if (_uncompletedTasks.isNotEmpty)
                Text(
                  "${_uncompletedTasks.length} open",
                  style: const TextStyle(
                    color: Color(0xFF737373),
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Clear your mental horizon before sleeping. Triage what's left.",
            style: TextStyle(color: Color(0xFFA3A3A3), fontSize: 13),
          ),
          const SizedBox(height: 18),

          // Body list
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
              ),
            )
          else if (_uncompletedTasks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    "Horizon completely clear!",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Zero guilt. Rest up for tomorrow.",
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                ],
              ),
            )
          else ...[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _uncompletedTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = _uncompletedTasks[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                        // Quick Action: Roll to tomorrow
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFFF59E0B), size: 18),
                          tooltip: "Roll to Tomorrow",
                          onPressed: () => _rollToTomorrow(task.id),
                        ),
                        // Quick Action: Drop/Delete
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF737373), size: 18),
                          tooltip: "Drop",
                          onPressed: () => _dropTask(task.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Bulk Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF0A0A0A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.fast_forward_rounded, size: 18),
                label: const Text(
                  "Sweep All to Tomorrow",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: _sweepAllToTomorrow,
              ),
            ),
          ],
        ],
      ),
    );
  }
}