import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradiator_app/controls/database/authService.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Function toggleAmongAuthPages;
  ForgotPasswordPage({required this.toggleAmongAuthPages});
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String sEmail = "";
  String error = "";

  late ProgressDialog pr;
  void prInitAndStyle(BuildContext context, String message) {
    pr = ProgressDialog(context: context);
    // pr.style(
    //   message: message,
    //   borderRadius: 10.0,
    //   // backgroundColor: _glt.backgroundColor,
    //   backgroundColor: Colors.white,
    //   progressWidget: Cindicator(),
    //   elevation: 10.0,
    //   insetAnimCurve: Curves.easeInOut,
    //   progress: 0.0,
    //   maxProgress: 100.0,
    //   progressTextStyle: TextStyle(
    //     color: Colors.blue,
    //     fontSize: 10.0,
    //     fontWeight: FontWeight.w400,
    //   ),
    //   messageTextStyle: TextStyle(
    //     color: Colors.black,
    //     fontSize: 15.0,
    //     fontWeight: FontWeight.w500,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    Color textFieldBorderColor = Colors.transparent;
    // Color formTextColor = Colors.black.withOpacity(0.8);
    prInitAndStyle(context, "Sending reset email...");

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
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                // color: _glt.cardPrimaryBorderColor),
              ),
              child: TextFormField(
                // cursorColor: _glt.themeColor,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  hintText: "Email address",
                  prefixIcon: Icon(MdiIcons.emailOutline),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                // validator: (val) {
                //   return validateEmail(val.trim());
                // },
                onChanged: (val) {
                  setState(() {
                    sEmail = val.trim();
                  });
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(0)),

            /// ERROR
            Center(
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  // fontSize: 3 * _glt.errorFontSize / 4,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),

            /// RESET BUTTON
            Container(
              width: double.infinity,
              // decoration: _glt.buttonDecor,
              child: FlatButton(
                child: Text(
                  "Reset my password via email".toUpperCase(),
                  // style: _glt.buttonDecorTextStyle,
                ),
                onPressed: () async {
                  setState(() {
                    error = "";
                  });
                  if (_formKey.currentState?.validate() != null) {
                    if (_auth.passwordReset(sEmail) != null) {
                      showConfirmationDialog(context, sEmail);
                      widget.toggleAmongAuthPages(0);
                    } else {
                      setState(() {
                        error = "Error in sending reset email!";
                      });
                    }
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),

            /// SIGN IN BUTTON
            Container(
              width: double.infinity,
              child: OutlinedButton(
                // style: _glt.buttonDecorOutlined,
                child: Text(
                  "Go back to sign in?".toUpperCase(),
                  // style: _glt.buttonDecorOutlinedTextStyle,
                ),
                onPressed: () {
                  widget.toggleAmongAuthPages(0);
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(20)),
          ],
        ),
      ),
    );
  }

  showConfirmationDialog(BuildContext context, String sEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(8),
          // contentPadding: EdgeInsets.all(GlobalTheme().alertDialogPadding),
          // shape: GlobalTheme().alertDialogShape,
          title: Text(
            "Password reset",
            // style: GlobalTheme().alertDialogTitleStyle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                ListTile(
                  title: Text(
                    "A password reset email has been sent to $sEmail",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              // style: _glt.cancelOutlinedButtonStyle,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
