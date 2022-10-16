import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradiator_app/cidgets/Cindicator.dart';
import 'package:gradiator_app/models/user.dart';
import 'package:gradiator_app/pages/auth/AuthController.dart';
import 'package:gradiator_app/pages/landing/MainController.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserUid uid = Provider.of<UserUid>(context);

    /// README: return either home or authenticate page depending on login state or splash
    return (uid != null)
        ? ((uid.uid.compareTo("-1") == 0) ? AuthController() : MainActivity())
        : Scaffold(
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
}
