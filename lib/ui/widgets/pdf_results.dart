import 'dart:io';

import 'package:ease_it/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFResults extends StatelessWidget {
  PDFResults(
      {Key? key,
      required this.outputFile,
      required this.resultsData,
      required this.textSearched})
      : super(key: key);
  final File outputFile;
  final String textSearched;
  final List<MatchedItem> resultsData;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: SfPdfViewer.file(outputFile,
                  controller: _pdfViewerController),
            ),
            const Spacer(),
            Container(
              height: screenHeight * 0.1,
              color: AppTheme.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        final results =
                            _pdfViewerController.searchText(textSearched);
                        results.previousInstance();
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppTheme.lightBlue,
                      )),
                  IconButton(
                      onPressed: () async {
                        final results =
                            _pdfViewerController.searchText(textSearched);
                        results.nextInstance();
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.lightBlue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
