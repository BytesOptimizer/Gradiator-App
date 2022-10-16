import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gradiator_app/controls/database/databaseService.dart';
import 'package:gradiator_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  // create user obj based on firebase user
  UserUid _userFromFirebaseUser(User? user) {
    bool isVerified = (user == null) ? false : user.emailVerified;
    return user != null
        ? UserUid(uid: user.uid, isVerified: isVerified)
        : UserUid(uid: "-1", isVerified: isVerified);
  }

  /// README: auth change user stream
  Stream<UserUid>? get userId {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  /// README: sign in with email and password
  Future signInEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      return error.message;
    } on PlatformException catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  /// README: password reset
  Future passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  /// README: send email verification link
  Future sendEmailVerificationLink(User firebaseUser) async {
//    print("Verification email sent to " + firebaseUser.email);
    await firebaseUser.sendEmailVerification();
  }

  /// README: register with email and password
  Future registerWithEmailAndPassword(
      UserModel _user, String _password, File? _imageFile) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _user.email!, password: _password);
      User? firebaseUser = result.user;

      /// verify email
      await firebaseUser?.sendEmailVerification();

      /// update db
      DatabaseService databaseService =
          DatabaseService(uid: firebaseUser != null ? firebaseUser.uid : "");

      /// TODO: What if image uploading fails? this fix wont work (solution needed!!)
      String _dpUrl = "";
      if (_imageFile != null) {
        _dpUrl = await databaseService.uploadUserDisplayPicture(_imageFile);
      }
      await databaseService.createUserData(_user, _dpUrl);
      return _userFromFirebaseUser(firebaseUser);
    } on PlatformException catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  /// README: sign out
  Future signOut() async {
    try {
      // DatabaseService databaseService = DatabaseService();
      // databaseService.removeUserTokens(UserModel(uid: this.currentUID()));
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /// README: sign out with push token removed
  Future signOutWithTokenRemoved(UserModel userModel) async {
    try {
      // String token = await FirebaseMessaging.instance.getToken();
      // await DatabaseService().removeUserTokens(userModel);
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /// README: get current uid
  String? currentUID() {
    try {
      String? _uid = _auth.currentUser?.uid;
      return _uid;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /// README: get current User
  User? currentUser() {
    try {
      User? _user = _auth.currentUser;
      return _user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
