import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/ui/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/models/search_model.dart';
import '../../../domain/models/user_model.dart' as user;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> saveUserDetails(Map<String, dynamic> userDetails) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userDetails);
    } on FirebaseException catch (e) {
      return e.message!;
    }
    return 'Success';
  }

  Future<String> uploadPic(XFile file) async {
    String url = '';
    try {
      await _storage
          .ref()
          .child(file.name)
          .putFile(File(file.path))
          .then((_) async {
        url = await _storage.ref().child(file.name).getDownloadURL();
      });
    } on FirebaseException catch (e) {
      return e.message!;
    }
    return url;
  }

  Future<String> getPath(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();
    if (document.exists) {
      return 'home';
    } else {
      return 'sign-up';
    }
  }

  Future<user.User> getUserDetails(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();
    final Map<String, dynamic> data = document.data()!;
    return user.User.fromJson(data);
  }

  Future<List<Search>> getSearchHistory(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();
    final docData = document.data();
    final data = docData!['searches'] as List<dynamic>?;
    List<Search> listOfSearches = [];
    data?.forEach(
      (element) => listOfSearches.add(
        Search(
            title: element['title'],
            googleUrl: element['googleUrl'],
            youtubeUrl: element['youtubeUrl'],
            dateCreated: element['dateCreated']),
      ),
    );
    return listOfSearches;
  }

  Future<void> storeHistory(String uid, Search searchData) async {
    final searchMap = searchData.toJson();
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'searches': FieldValue.arrayUnion(
            [
              searchMap,
            ],
          ),
        },
      );
    } catch (e) {
      print(e);
    }
    // final document = await _firestore.collection('users').doc(uid).get();
    // final Map<String, dynamic> data = document.data()!;
    // return user.User.fromJson(data);
  }
}
// Future<user.User> getUserDetails(String uid) async {}
