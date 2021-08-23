import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(200, 50),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

Future readJson(String rank, int pack, int puzzle) async {
  var file;
  if (rank == 'Easy') {
    file = 'assets/easy.json';
  } else if (rank == 'Medium') {
    file = 'assets/medium.json';
  } else if (rank == 'Hard') {
    file = 'assets/hard.json';
  } else {
    file = 'assets/evil.json';
  }
  final String response = await rootBundle.loadString(file);
  List data = await (json.decode(response) as List);

  return data[pack * 10 + puzzle];
}
