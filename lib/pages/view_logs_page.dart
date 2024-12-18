import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:intl/intl.dart';

import '../services/log_service.dart';
import 'view_logs_controller.dart';

class ViewLogsPage extends StatefulWidget {
  final String exercise;

  const ViewLogsPage({super.key, required this.exercise});

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

                return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      var log = logs[index];

                      return Container(
                        decoration: BoxDecoration(color: index % 2 == 0 ? Colors.transparent : Colors.grey[300]),
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Row(
                            children: [
                              Expanded(child: Text('${log.weight} kg')),
                              Expanded(child: Text(log.reps.toString())),
                              Expanded(child: Text(DateFormat('dd/MM/yyyy').format(log.date))),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}