import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradiator_app/cidgets/Cindicator.dart';
import 'package:gradiator_app/controls/database/authService.dart';
import 'package:gradiator_app/models/user.dart';
import 'package:gradiator_app/pages/home/HomeController.dart';
import 'package:gradiator_app/pages/landing/wrapper.dart';
import 'package:provider/provider.dart';

class MainActivity extends StatelessWidget {
  MainActivity({Key? key}) : super(key: key);
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final UserUid userId = Provider.of<UserUid>(context);
    final UserModel userModel = Provider.of<UserModel>(context);
    // final appInfo = Provider.of<AppInfo>(context);

    if (userId != null) {
      if (userId.isVerified) {
        if (userModel != null) {
          /// GO TO HOME
          return HomeController();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Cindicator(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } // if email is not verified
      else {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text("Verify your account")),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SvgPicture.asset(
              //   VectorArt.secureAccountVariant,
              //   fit: BoxFit.scaleDown,
              //   height: 300,
              // ),
              OutlinedButton(
                onPressed: () async {
                  await auth.signOutWithTokenRemoved(userModel);
                },
                child: const Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  User? firebaseUser = auth.currentUser();
                  await auth.sendEmailVerificationLink(firebaseUser!);
                },
                child: Text(
                  "Send verification email again",
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return const Wrapper();
    }
  }
}
