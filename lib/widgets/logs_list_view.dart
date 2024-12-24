import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/extensions.dart';

class LogsListView extends StatelessWidget {
  final List<Log> logs;

  const LogsListView({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        var log = logs[index];

        return Container(
          decoration: BoxDecoration(color: index % 2 == 0 ? Colors.transparent : Colors.grey[300]),
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(child: Text('${log.weight} kg')),
                Expanded(child: Text(log.reps.toString())),
                Expanded(child: Text(log.date.formatReadableShort())),
                Expanded(child: Text(log.notes)),
              ],
            ),
          ),
        );
      },
    );
  }
}
