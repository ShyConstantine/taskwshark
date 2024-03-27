import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwshark/cubit/app_cubits.dart';

class ApiForm extends StatelessWidget {
  final TextEditingController _urlController = TextEditingController();

  ApiForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'API URL',
            ),
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              String apiUrl = _urlController.text;
              if (isValidUrl(apiUrl)) {
                try {
                  BlocProvider.of<AppCubits>(context).getData(apiUrl);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to fetch data: $e'),
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
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Invalid URL'),
                      content: const Text('Please enter a valid URL.'),
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
            },
            child: const Text('Fetch Data'),
          ),
        ],
      ),
    );
  }

  bool isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r"^(http|https):\/\/[a-zA-Z0-9\-\.]+(\.[a-zA-Z]{2,})?(:[0-9]{1,5})?(\/\S*)?$",
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegExp.hasMatch(url);
  }
}
