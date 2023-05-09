import 'package:flutter/cupertino.dart';

const primaryColor = Color(0xFF20692D);
const secondaryColor = Color(0xFF455A64);

const List<Map<String, dynamic>> data = [
  {
    "contents": [
      {"name": "Medicine Dispenser.docx", "size": "112.16 KB", "type": "file"}
    ],
    "name": "Lionelle Diaz",
    "num_files": 1,
    "type": "directory"
  },
  {"name": "Invoice_03112023.pdf", "size": "95.98 KB", "type": "file"},
  {"name": "Invoice_V2.docx", "size": "13.36 KB", "type": "file"},
  {"name": "Project Document.docx", "size": "41.95 KB", "type": "file"},
  {"name": "Project Document.pdf", "size": "123.70 KB", "type": "file"},
  {
    "contents": [
      {"name": "Invoice_03112023.pdf", "size": "95.98 KB", "type": "file"},
      {"name": "Invoice_V2.docx", "size": "13.36 KB", "type": "file"},
      {"name": "Project Document.docx", "size": "41.95 KB", "type": "file"},
      {"name": "Project Document.pdf", "size": "123.70 KB", "type": "file"}
    ],
    "name": "PROJEC 1",
    "num_files": 4,
    "type": "directory"
  },
  {
    "contents": [
      {"name": "Invoice_V2.docx", "size": "13.36 KB", "type": "file"},
      {"name": "Invoice_03112023.pdf", "size": "95.98 KB", "type": "file"},
      {
        "contents": [
          {"name": "Invoice_03112023.pdf", "size": "95.98 KB", "type": "file"},
          {"name": "Invoice_V2.docx", "size": "13.36 KB", "type": "file"},
          {"name": "Project Document.docx", "size": "41.95 KB", "type": "file"},
          {"name": "Project Document.pdf", "size": "123.70 KB", "type": "file"}
        ],
        "name": "PROJEC 1",
        "num_files": 4,
        "type": "directory"
      }
    ],
    "name": "Project 2",
    "num_files": 2,
    "type": "directory"
  }
];

const String baseURL = "http://127.0.0.1:5000";
const String wsURL = "ws://127.0.0.1:5000";
