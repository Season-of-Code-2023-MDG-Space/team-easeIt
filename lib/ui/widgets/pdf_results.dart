import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFResults extends StatelessWidget {
  const PDFResults(
      {Key? key, required this.outputFile, required this.resultsData})
      : super(key: key);
  final File outputFile;
  final List<MatchedItem> resultsData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('PDF View Screen'),
        ],
      ),
    );
  }
}
