import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:gradiator_app/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid = ""});

  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  /// README: all references
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference _pushTokensCollection =
      FirebaseFirestore.instance.collection("PushTokens");
  ///////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  /// README: create user data
  Future createUserData(UserModel user, String dpUrl) async {
    return await _usersCollection.doc(uid).set({
      'email': user.email,
      'name': user.name,
      'uid': uid,
      'phone': "${user.phone}",
      'address': user.address,
      'profilePic': dpUrl,
    });
  }

  Future<String> uploadUserDisplayPicture(File imageFile) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Users/' + uid + "/dp/dp.jpg");
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => print('File Uploaded'));
    String url = await storageReference.getDownloadURL().then((fileUrl) {
      return fileUrl;
    });
    return url;
  }

  /// README: update user data
  Future updateUserData(
      {String? phone,
      String? address,
      String? dateOfBirth,
      String? gender}) async {
    return await _usersCollection.doc(uid).set({
      'phone': "+$phone",
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  Future switchOffStartingScreens() async {
    return await _usersCollection
        .doc(uid)
        .set({'showStartingScreensMob': false}, SetOptions(merge: true));
  }

  Future updatePinnedProject({String? pinnedProid}) async {
    try {
      await _usersCollection.doc(uid).set({
        'pinnedProid': pinnedProid,
      }, SetOptions(merge: true));

      return true;
    } on PlatformException catch (error) {
      print(error.toString());
      return error.message;
    }
  }

  Future disableFreshIntroUserData() async {
    return await _usersCollection.doc(uid).set({
      'showFreshIntroMob': false,
    }, SetOptions(merge: true));
  }

  Future updateUserDisplayPicture(File imageFile) async {
    if (imageFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Users/' + uid + "/dp/dp.jpg");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => print('File Uploaded'));
      String dpUrl = await storageReference.getDownloadURL().then((fileUrl) {
        return fileUrl;
      });

      return await _usersCollection.doc(uid).set({
        'profilePic': dpUrl,
      }, SetOptions(merge: true));
    }
  }

  /// README: update the user device tokens
  Future updateUserTokens(UserModel userModel) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();

    /// TODO: TO BE REMOVED IN FUTURE
    // await _updateFSUserTokens(token, userModel);
    // await _updateRtdbUserTokens(token, userModel);
  }

  Future _updateFSUserTokens(String? token, UserModel userModel) async {
    List<String?> tokens = [];
    tokens.add(token);

    return await _pushTokensCollection.doc(userModel.uid).set({
      'name': userModel.name,
      'token': FieldValue.arrayUnion(tokens),
    }, SetOptions(merge: true));
  }

  // Future _updateRtdbUserTokens(String? token, UserModel userModel) async {
  //   Map? tokenSnapShot = await FirebaseDatabase.instance
  //       .reference()
  //       .child("PushTokens")
  //       .child(userModel.uid!)
  //       .orderByKey()
  //       .onValue
  //       .first
  //       .then((value) => value.snapshot.value);

  //   List tokens = (tokenSnapShot ?? const {})['token'] ?? [];
  //   if (!tokens.contains(token)) {
  //     List newTokens = [];
  //     newTokens.addAll(tokens);
  //     newTokens.add(token);

  //     return await FirebaseDatabase.instance
  //         .reference()
  //         .child('PushTokens/${userModel.uid}')
  //         .set({
  //       'token': newTokens,
  //       'name': userModel.name,
  //     });
  //   }
  // }

  /// README: delete the user device tokens
  Future removeUserTokens(UserModel userModel) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();

    /// TODO: TO BE REMOVED IN FUTURE
    // await _removeUserFSTokens(token, userModel);
    // await _removeRtdbUserTokens(token, userModel);
  }

  Future _removeUserFSTokens(String? token, UserModel userModel) async {
    List<String?> tokens = [];
    tokens.add(token);

    await _pushTokensCollection.doc(userModel.uid).set({
      // 'name': userModel.name,
      'token': FieldValue.arrayRemove(tokens),
    }, SetOptions(merge: true));
  }

  // Future _removeRtdbUserTokens(String? token, UserModel userModel) async {
  //   List newTokens = [];
  //   Map? tokenSnapShot = await FirebaseDatabase.instance
  //       .reference()
  //       .child("PushTokens")
  //       .child(userModel.uid!)
  //       .orderByKey()
  //       .onValue
  //       .first
  //       .then((value) => value.snapshot.value);

  //   List tokens = (tokenSnapShot ?? const {})['token'] ?? [];
  //   // print(tokens);

  //   newTokens.addAll(tokens);
  //   newTokens.remove(token);
  //   // print(token);
  //   // print(newTokens);

  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child('PushTokens/${userModel.uid}')
  //       .update({
  //     'token': newTokens,
  //     // 'name': userModel.name,
  //   });
  // }

  Future<String> getUserProfilePic({String? uid}) async {
    /// native error handling: https://github.com/FirebaseExtended/flutterfire/issues/792
    String dpUrl = "";
    uid = uid ?? "";
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Users/' + uid + "/dp/dp.jpg");
      dpUrl = await storageReference.getDownloadURL().then((fileUrl) {
        return fileUrl;
      }).catchError((err) {
        print("STORAGE ERROR CATCHED");
        return "";
      });
    } on PlatformException catch (error) {
      print(error.toString());
    } on Exception catch (e) {
      print("Oops! The file was not found");
    }

    // print("TEST DP URL FROM FIREBASE: " + dpUrl);
    return dpUrl;
  }

  /// README: user info collection reference
  Future<UserModel> getUserInfo() async {
    var snap = await _usersCollection.doc(uid).get();
    Map data = (snap.data() ?? {}) as Map<dynamic, dynamic>;
    return UserModel.fromMap(data);
  }

  /// README: Get stream of user info doc
  Stream<UserModel> streamUserInfo() {
    return _usersCollection
        .doc(uid)
        .snapshots()
        .map((snap) => UserModel.fromMap(snap.data() as Map? ?? {}));
  }
}
