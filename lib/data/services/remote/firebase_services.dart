import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/models/user_model.dart' as user;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> saveUserDetails(Map<String, dynamic> userDetails) async {
    try {} on FirebaseException catch (e) {
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
}
// Future<user.User> getUserDetails(String uid) async {}
