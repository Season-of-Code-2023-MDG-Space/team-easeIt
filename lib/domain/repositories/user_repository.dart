import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';

import '../../data/services/remote/firebase_services.dart';
import '../models/user_model.dart';

class UserRepository {
  final _firebaseService = FirebaseService();
  final authinstance = firebase_auth.FirebaseAuth.instance;

  Future<String> saveUserDetails(String name, String email, String? url) async {
    final user = User(
      uid: authinstance.currentUser!.uid,
      name: name,
      profileImage: url,
      email: email,
    ).toJson();
    final result = await _firebaseService.saveUserDetails(user);
    return result;
  }

  Future<String> uploadPic(XFile image) async {
    final result = await _firebaseService.uploadPic(image);
    return result;
  }

  // Future<User> getUserDetails() async {
  //   final result =
  //       await _firebaseService.getUserDetails(authinstance.currentUser!.uid);
  //   return result;
  // }

  // Future<String> getPath() async {
  //   final result =
  //       await _firebaseService.getPath(authinstance.currentUser!.uid);
  //   return result;
  // }
}
