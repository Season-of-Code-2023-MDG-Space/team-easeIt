import 'dart:io';

import 'package:ease_it/ui/home/home_screen.dart';
import 'package:ease_it/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFResults extends StatefulWidget {
  const PDFResults({Key? key, required this.outputFile}) : super(key: key);
  final File outputFile;

  @override
  State<PDFResults> createState() => _PDFResultsState();
}

class _PDFResultsState extends State<PDFResults> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  String textToFind = '';
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _searchResult.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        return Future.value(true);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.all(15.w),
                child: TextFormField(
                  onChanged: (value) {
                    textToFind = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      labelText: 'Search Text',
                      labelStyle: AppTheme.h3.copyWith(
                          color: AppTheme.greyNew, fontWeight: FontWeight.w700),
                      hintStyle: AppTheme.h4.copyWith(
                          color: AppTheme.greyNew, fontWeight: FontWeight.w400),
                      hintText: 'Search your text here.',
                      suffix: IconButton(
                        icon: const Icon(
                          Icons.search_outlined,
                          color: AppTheme.blue,
                        ),
                        onPressed: () {
                          _searchResult =
                              _pdfViewerController.searchText(textToFind);
                          _searchResult.addListener(() {
                            if (_searchResult.hasResult) {
                              setState(() {});
                            }
                          });
                          if (!_searchResult.hasResult) {
                            Get.snackbar(
                              'No Results Found',
                              'The Selected PDF(s) does not contain required results.',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.symmetric(
                                  vertical: 80.h, horizontal: 20.w),
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                            );
                          }
                        },
                      )),
                  style: AppTheme.h3.copyWith(
                      color: AppTheme.greyNew, fontWeight: FontWeight.w300),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.w),
                child: SizedBox(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  child: SfPdfViewer.file(
                    widget.outputFile,
                    controller: _pdfViewerController,
                    currentSearchTextHighlightColor:
                        Colors.orange.withOpacity(0.7),
                    otherSearchTextHighlightColor:
                        Colors.yellow.withOpacity(0.3),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.083),
              Container(
                height: screenHeight * 0.1,
                color: AppTheme.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          _searchResult.previousInstance();
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppTheme.lightBlue,
                        )),
                    IconButton(
                        onPressed: () {
                          _searchResult.nextInstance();
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
      ),
    );
  }
}
