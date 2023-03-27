import 'package:ease_it/ui/home/home_screen.dart';
import 'package:ease_it/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CameraResults extends StatefulWidget {
  const CameraResults({Key? key, required this.outputText}) : super(key: key);
  final String outputText;

  @override
  State<CameraResults> createState() => _CameraResultsState();
}

class _CameraResultsState extends State<CameraResults> {
  String textToFind = '';
  Map<String, HighlightedWord> words = {};
  @override
  void initState() {
    // _pdfViewerController = PdfViewerController();
    // _searchResult = PdfTextSearchResult();
    super.initState();
  }

  @override
  void dispose() {
    // _pdfViewerController.dispose();
    // _searchResult.dispose();
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
                    words.clear();
                    words.addAll({
                      textToFind: HighlightedWord(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      const Text("Search It On Search Engines"),
                                  content: const Text(
                                      'You can Search the text on Google & YouTube.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Later'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final url =
                                            textToFind.replaceAll(' ', '+');
                                        print(url);
                                        print(url);
                                        print(url);
                                        print(url);
                                        if (await canLaunchUrl(
                                            Uri.parse(url))) {}
                                      },
                                      child: Text("Ok"),
                                    ),
                                  ],
                                );
                              });
                        },
                        textStyle: const TextStyle(
                          backgroundColor: Colors.yellowAccent,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        // padding: padding,
                      ),
                    });
                    setState(() {});
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
                          // _searchResult =
                          //     _pdfViewerController.searchText(textToFind);
                          // _searchResult.addListener(() {
                          //   if (_searchResult.hasResult) {
                          //     setState(() {});
                          //   }
                          // });
                          // if (!_searchResult.hasResult) {
                          //   Get.snackbar(
                          //     'No Results Found',
                          //     'The Selected PDF(s) does not contain required results.',
                          //     snackPosition: SnackPosition.BOTTOM,
                          //     margin: EdgeInsets.symmetric(
                          //         vertical: 80.h, horizontal: 20.w),
                          //     padding: EdgeInsets.symmetric(vertical: 20.h),
                          //   );
                          // }
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
                  child: SingleChildScrollView(
                    child: TextHighlight(
                      text: widget.outputText,
                      words: words,
                      matchCase: false,
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.083,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.saved_search),
                  onPressed: () async {
                    try {
                      Uri url = Uri.parse(textToFind.replaceAll(' ', '+'));
                      url = Uri.parse(
                          'https://www.google.com/search?q=${url.toString()}');
                      Get.defaultDialog(
                        backgroundColor: AppTheme.lightBlue,
                        title: 'Select Search Engines',
                        middleText:
                            'You can search Text on Google and YouTube.',
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Later'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (await launchUrl(url)) {
                              } else {
                                Get.snackbar(
                                  'Could not search',
                                  'Something went wrong. Please check and try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 80.h, horizontal: 20.w),
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  duration: const Duration(seconds: 1),
                                );
                              }
                            },
                            child: const Text('Google'),
                          ),
                          TextButton(
                            onPressed: () async {
                              url = Uri.parse(textToFind.replaceAll(' ', '+'));
                              url = Uri.parse(
                                  'http://www.youtube.com/results?search_query=${url.toString()}');
                              if (await launchUrl(url)) {
                              } else {
                                Get.snackbar(
                                  'Could not search',
                                  'Something went wrong. Please check and try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 80.h, horizontal: 20.w),
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  duration: const Duration(seconds: 1),
                                );
                              }
                            },
                            child: const Text('Youtube'),
                          ),
                        ],
                      );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  label: const Text(
                    'Search on Search Engines',
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.1,
                color: AppTheme.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          // _searchResult.previousInstance();
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppTheme.lightBlue,
                        )),
                    IconButton(
                        onPressed: () {
                          // _searchResult.nextInstance();
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
