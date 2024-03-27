import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwshark/cubit/app_cubit_states.dart';
import 'package:taskwshark/cubit/app_cubits.dart';

import '../../models/data_model.dart';
import '../../services/send_data_services.dart';
import 'field_widget.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('We have this fields'),
      ),
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          if (state is LoadedState) {
            final info = state.data;
            final shortestPaths = info.map(findShortestPath).toList();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < info.length; i++)
                    Column(
                      children: [
                        showFiedId(context, info[i]),
                        buildField(context, info[i], shortestPaths[i]),
                        const SizedBox(height: 16),
                      ],
                    ),
                  buildShortestPaths(shortestPaths),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      final pathsJson = convertPathsToJson(shortestPaths, info);
                      sendPathsToServer(pathsJson,
                              'https://flutter.webspark.dev/flutter/api') // TODO: Get URL from the user
                          .then((success) {
                        Navigator.of(context).pop();

                        if (success) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content: const Text(
                                  'Data successfully sent to the server.',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
                    child: const Text('Send results to server'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget showFiedId(BuildContext context, DataModel data) {
  return Column(
    children: [
      Text(
        'Field ID: ${data.id}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
