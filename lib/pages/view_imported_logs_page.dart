import 'package:flutter/material.dart';

import '../entities/log.dart';
import '../widgets/logs_list_view.dart';

class ViewImportedLogsPage extends StatefulWidget {
  final String title;
  final List<Log> logs;
  final void Function()? onConfirm;

  const ViewImportedLogsPage({
    super.key,
    required this.title,
    required this.logs,
    this.onConfirm,
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
            decoration: const BoxDecoration(color: Colors.black),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .7,
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
                      'Repetições',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Data',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
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