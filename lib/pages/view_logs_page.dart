import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';

import '../entities/exercise.dart';
import '../widgets/logs_list_view.dart';
import 'view_logs_controller.dart';

class ViewLogsPage extends StatefulWidget {
  final Exercise exercise;
  final void Function() onUpdate;

  const ViewLogsPage({
    super.key,
    required this.exercise,
    required this.onUpdate,
  });

  @override
  State<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  bool _updated = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _updated) {
          widget.onUpdate();
        }
      },
      child: Scaffold(
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
                    flex: 3,
                    child: Text(
                      'Peso',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Reps',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Notas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(flex: 2, child: SizedBox.shrink()),
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

                  return LogsListView(
                    logs: logs,
                    exercise: widget.exercise,
                    onDelete: () {
                      setState(() {});
                      _updated = true;
                    },
                    onEdit: () {
                      setState(() {});
                      _updated = true;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
