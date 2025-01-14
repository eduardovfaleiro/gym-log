import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/widgets/loading_manager.dart';

import '../entities/exercise.dart';
import '../widgets/logs_list_view.dart';
import 'view_logs_controller.dart';

class ViewLogsPage extends StatefulWidget {
  final List<Log> logs;
  final Exercise exercise;
  final void Function() onUpdate;

  const ViewLogsPage({
    super.key,
    required this.exercise,
    required this.logs,
    required this.onUpdate,
  });

  @override
  State<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> with LoadingManager {
  bool _updated = false;
  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();
    _logs = widget.logs;
  }

  Future<void> _updateLogs() async {
    setLoading(true);

    _logs = await ViewLogsController().getSortedLogsByDate(widget.exercise);
    setState(() {});
    _updated = true;

    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: PopScope(
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
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('Peso')),
                    Expanded(flex: 3, child: Text('Reps')),
                    Expanded(flex: 3, child: Text('Data')),
                    SizedBox(width: 12),
                    Expanded(flex: 6, child: Text('Notas')),
                    Expanded(flex: 2, child: SizedBox.shrink()),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: Visibility(
                  visible: _logs.isNotEmpty,
                  replacement: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ainda não existem logs para exibir.'),
                  ),
                  child: LogsListView(
                    logs: _logs,
                    exercise: widget.exercise,
                    onDelete: _updateLogs,
                    onEdit: _updateLogs,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
