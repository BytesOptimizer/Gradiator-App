import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradiator_app/controls/database/authService.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
// import 'package:cyclepath_mobile/controls/helpers/formVal.dart';

class LoginPage extends StatefulWidget {
  final Function toggleAmongAuthPages;
  LoginPage({required this.toggleAmongAuthPages});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  String sEmail = "";
  String sPassword = "";

  String error = "";

  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;
  void togglePasswordVisibility() {
    setState(() => showPassword = !showPassword);
  }

  late ProgressDialog pr;
  void prInitAndStyle(BuildContext context, String message) {
    pr = ProgressDialog(context: context);
    // pr.style(
    //   message: message,
    //   borderRadius: 10.0,
    //   // backgroundColor: _glt.backgroundColor,
    //   progressWidget: Cindicator(),
    //   elevation: 10.0,
    //   insetAnimCurve: Curves.easeInOut,
    //   progress: 0.0,
    //   maxProgress: 100.0,
    //   progressTextStyle: TextStyle(
    //     // color: _glt.customColor,
    //     fontSize: 10.0,
    //     fontWeight: FontWeight.w400,
    //   ),
    //   messageTextStyle: TextStyle(
    //     // color: _glt.darkTextColor,
    //     fontSize: 15.0,
    //     fontWeight: FontWeight.w500,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    Color textFieldBorderColor = Colors.transparent;
    Color formTextColor = Colors.black.withOpacity(0.8);
    prInitAndStyle(context, "Signing you in...");

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),

            ///
            /// !! FIELDS !!
            ///
            /// EMAIL
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Email address",
                  prefixIcon: Icon(MdiIcons.emailOutline),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                // validator: (val) {
                //   return validateField(val.trim());
                // },
                onChanged: (val) {
                  setState(() {
                    sEmail = val.trim();
                  });
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),

            /// PASSWORD
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: TextFormField(
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(MdiIcons.lockOutline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      togglePasswordVisibility();
                    },
                    icon: (showPassword
                        ? Icon(
                            MdiIcons.eyeOutline,
                          )
                        : Icon(
                            MdiIcons.eyeOffOutline,
                          )),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                obscureText: !showPassword,
                // validator: (val) {
                //   return validateField(val);
                // },
                onChanged: (val) {
                  setState(() {
                    sPassword = val;
                  });
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),

            /// FORGOT PASSWORD
            GestureDetector(
              onTap: () {
                widget.toggleAmongAuthPages(1);
              },
              child: Container(
                width: double.infinity,
                child: Text(
                  "Forgot password?",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: formTextColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),

            /// ERROR
            Center(
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),

            /// SIGN IN BUTTON
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text(
                  "Sign in".toUpperCase(),
                ),
                onPressed: () async {
                  setState(() {
                    error = "";
                  });
                  if (_formKey.currentState?.validate() != null) {
                    //    pr.show();
                    dynamic result =
                        await _auth.signInEmailPass(sEmail, sPassword);
                    if (result is UserCredential) {
                      //      pr.hide();
                    } else {
                      //      pr.hide();
                      setState(() {
                        error = result;
                      });
                    }
                  }

                  // print(sEmail);
                  // print(sPassword);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),

            /// NEW USER BUTTON
            Container(
              width: double.infinity,
              child: OutlinedButton(
                child: Text(
                  "Create your new account for free".toUpperCase(),
                ),
                onPressed: () {
                  widget.toggleAmongAuthPages(2);
                },
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
