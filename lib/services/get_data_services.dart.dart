import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:taskwshark/models/data_model.dart';

class DataServices {
  String apiUrl = 'https://flutter.webspark.dev/flutter/api';
  Future<List<DataModel>> getInfo(String apiUrl) async {
    final http.Response response = await http.get(Uri.parse(apiUrl));
    try {
      if (response.statusCode == 200) {
        log(response.body, name: 'DataServices.getInfo()');
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> dataList = responseData['data'];
        log(dataList.toString(), name: 'DATA LIST');
        return dataList.map((e) => DataModel.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load data: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
