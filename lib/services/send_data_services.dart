import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;
import '../models/data_model.dart';
import '../presentation/results/field_widget.dart';

List<Map<String, dynamic>> convertPathsToJson(
    List<List<Point>> shortestPaths, List<DataModel> dataModels) {
  List<Map<String, dynamic>> results = [];

  for (int i = 0; i < dataModels.length; i++) {
    final id = dataModels[i].id;
    final path = shortestPaths[i];

    final steps = path
        .map((point) => {'x': point.x.toString(), 'y': point.y.toString()})
        .toList();
    final pathString =
        path.map((point) => '(${point.x},${point.y})').join('->');
    dev.log(results.toString(), name: 'RESULTS');
    results.add({
      'id': id,
      'result': {
        'steps': steps,
        'path': pathString,
      }
    });
  }

  return results;
}

Future<bool> sendPathsToServer(
    List<Map<String, dynamic>> paths, String apiUrl) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(paths),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        dev.log('Data successfully sent to the server.');
        return true;
      } else {
        dev.log('Failed to send data to the server: ${responseData['error']}');
        return false;
      }
    } else {
      dev.log(
          'Failed to send data to the server. Status code: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    dev.log('Error sending data to the server: $error');
    return false;
  }
}
