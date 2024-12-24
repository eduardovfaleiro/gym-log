import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';

import '../entities/exercise.dart';
import '../widgets/logs_list_view.dart';
import 'view_logs_controller.dart';

class ViewLogsPage extends StatefulWidget {
  final Exercise exercise;

  const ViewLogsPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar logs'),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Peso',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Reps',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Data',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Notas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: ViewLogsController().getSortedLogs(widget.exercise),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                List<Log> logs = snapshot.data!;

                if (logs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ainda não existem logs para exibir.'),
                  );
                }

                return LogsListView(logs: logs);
              },
            ),
          ),
        ],
      ),
    );
  }
}
