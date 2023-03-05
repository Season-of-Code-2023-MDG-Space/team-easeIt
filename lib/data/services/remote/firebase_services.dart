import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
}
// Future<user.User> getUserDetails(String uid) async {}
