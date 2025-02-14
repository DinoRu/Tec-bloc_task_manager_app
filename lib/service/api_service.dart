import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tec_bloc/core/constants/app_urls.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';

class ApiService {

  final DbHelper dbHelper  = DbHelper();

  Future<List<String>> getWorkType() async {
    final db = await dbHelper.database;
    final data = await dbHelper.getWorkType();
    if (data.isNotEmpty) {
      return data.map<String>((item) => item['title'].toString()).toList();
    }
    final response = await http.get(Uri.parse(AppUrls.getWorkType));
    if (response.statusCode == 200) {
      Utf8Decoder decoder = const Utf8Decoder();
      String decoderBody = decoder.convert(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decoderBody);
      List<Map<String, dynamic>> workTypeList = jsonResponse.map((item) => {
        "uid": item['uid'],
        'title': item['title'],
      }).toList();

      for (var workType in workTypeList) {
        await db.insert("work_type", workType, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return workTypeList.map<String>((item) => item['title'].toString()).toList();
    } else {
      throw Exception('Failed to load work type');
    }
  }

  Future<List<double>> getVoltage() async {
    final db = await dbHelper.database;
    final data = await dbHelper.getVoltage();
    if (data.isNotEmpty) {
      return data.map<double>((item) => item['volt'].toDouble()).toList();
    }
    final response = await http.get(Uri.parse(AppUrls.getVoltage));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> voltageList = jsonResponse.map((item) => {
        "uid": item['uid'],
        'volt': item['volt'],
      }).toList();
      for (var voltage in voltageList) {
        await db.insert("voltage", voltage, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return voltageList.map<double>((item) => item['volt'].toDouble()).toList();
    } else {
      throw Exception("Failed to load voltage");
    }
  }
}