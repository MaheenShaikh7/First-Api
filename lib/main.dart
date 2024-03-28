import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SchoolApp());
}

class SchoolApp extends StatefulWidget {
  const SchoolApp({super.key});

  @override
  State<SchoolApp> createState() => _SchoolAppState();
}

class _SchoolAppState extends State<SchoolApp> {
  List<Schools> school = [];

  @override
  void initState() {
    super.initState();
    fetchSchool();
  }

  Future<void> fetchSchool() async {
    final response =
        await http.get(Uri.parse('http://192.168.31.86:8000/schools'));

    // print(response);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        school = json.map((e) => Schools.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Schools'),
          ),
          body: ListView.builder(
              itemCount: school.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(school[index].name),
                  subtitle: Text(school[index].id.toString()),
                );
              })),
    );
  }
}

class Schools {
  final int id;
  final String name;

  Schools({required this.id, required this.name});

  factory Schools.fromJson(Map<String, dynamic> json) {
    return Schools(id: json['id'], name: json['name']);
  }
}
