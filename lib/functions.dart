import 'dart:convert';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getFlashDriveStructure() async {
  String url = '$baseURL/get_flash_drive_structure';
  final response = await http.get(Uri.parse(url));
  List<Map<String, dynamic>> responseData =
      (json.decode(response.body) as List).cast<Map<String, dynamic>>();
  return responseData;
}

Future<Map<String, dynamic>> uploadFileFromDrive(String filePath) async {
  String url = '$baseURL/upload_file_from_drive';
  final response = await http.post(Uri.parse(url),
      body: json.encode({"file_path": filePath}));
  final decoded = json.decode(response.body) as Map<String, dynamic>;
  return decoded;
}
