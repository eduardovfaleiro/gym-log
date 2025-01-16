import 'package:flutter/material.dart';

import '../entities/log.dart';
import '../widgets/logs_list_view.dart';

class ViewImportedLogsPage extends StatefulWidget {
  final String title;
  final List<Log> logs;
  final void Function() onConfirm;

  const ViewImportedLogsPage({
    super.key,
    required this.title,
    required this.logs,
    required this.onConfirm,
  });

  @override
  State<ViewImportedLogsPage> createState() => _ViewImportedLogsPageState();
}

class _ViewImportedLogsPageState extends State<ViewImportedLogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onConfirm,
                child: const Text('Importar'),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('Peso')),
                  Expanded(flex: 3, child: Text('Reps')),
                  Expanded(flex: 3, child: Text('Data')),
                  SizedBox(width: 12),
                  Expanded(flex: 6, child: Text('Notas')),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: Visibility(
              visible: widget.logs.isNotEmpty,
              replacement: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Este arquivo não possui logs.'),
              ),
              child: LogsListView(logs: widget.logs),
            ),
          ),
        ],
      ),
    );
  }
}
