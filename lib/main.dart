import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const AuroraFitApp());
}

class AuroraFitApp extends StatelessWidget {
  const AuroraFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Fit',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuroraFirstPage(),
    );
  }
}