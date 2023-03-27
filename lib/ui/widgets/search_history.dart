import 'package:ease_it/data/services/remote/firebase_services.dart';
import 'package:ease_it/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/search_model.dart';
import '../../utils/app_theme.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  late Future<List<Search>> searchData;
  @override
  void initState() {
    _getSearchHistoryData(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  Future<void> _getSearchHistoryData(String uid) async {
    try {
      searchData = FirebaseService().getSearchHistory(uid);
      return Future.value();
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        return Future.value(true);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: searchData,
                // initialData: [],
                builder: (context, asyncSnapshot) {
                  List<Search>? data = asyncSnapshot.data;
                  if (data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 5.w),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  data[index].title,
                                  style: AppTheme.h4,
                                ),
                                leading: const Icon(
                                  Icons.history_edu_outlined,
                                  color: AppTheme.blue,
                                ),
                                subtitle: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          final url =
                                              Uri.parse(data[index].googleUrl);
                                          if (await launchUrl(url)) {}
                                        },
                                        child: const Text('Google Search')),
                                    TextButton(
                                        onPressed: () async {
                                          final url =
                                              Uri.parse(data[index].youtubeUrl);
                                          if (await launchUrl(url)) {}
                                        },
                                        child: const Text('Youtube Search')),
                                  ],
                                ),
                                splashColor: Colors.black12.withAlpha(50),
                                onTap: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  side: const BorderSide(
                                    color: AppTheme.blue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
