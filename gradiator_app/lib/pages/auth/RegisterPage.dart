import 'dart:io';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:gradiator_app/controls/database/authService.dart';
import 'package:gradiator_app/controls/helpers/validators.dart';
import 'package:gradiator_app/models/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleAmongAuthPages;
  RegisterPage({required this.toggleAmongAuthPages});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();

  late String sPicture;
  File? imageFile;
  String sEmail = "";
  String sReEmail = "";
  String sPassword = "";
  String sRePassword = "";
  String sName = "";
  String sPhone = "";
  String dob = "";
  String dobToUpload = "";
  String gender = "";

  String _organizationTypeKey = "";
  TextEditingController _organizationTypeCon = TextEditingController(text: "");

  Country cSelectedCountry =
      CountryPickerUtils.getCountryByName("United Kingdom");

  String error = "";

  final _formKey = GlobalKey<FormState>();

  List<bool> showPasswords = [false, false];
  void togglePasswordVisibility(int i) {
    setState(() => showPasswords[i] = !showPasswords[i]);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dobToUpload = picked.toIso8601String();
        dob = picked.day.toString() +
            "/" +
            picked.month.toString() +
            "/" +
            picked.year.toString();
      });
    }
  }

  Widget _buildDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Text(
          "+${country.phoneCode}",
          style: TextStyle(
            // fontWeight: _glt.subtitleFontWeight,
            color: Colors.grey[800],
            // fontSize: _glt.subtitleFontSize,
          ),
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: Text(
            country.name,
            style: TextStyle(
              // fontWeight: _glt.subtitleFontWeight,
              color: Colors.grey[800],
              // fontSize: _glt.subtitleFontSize,
            ),
          ),
        ),
      ],
    );
  }

  void _openCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: const Text(
          'Select your phone code',
          style: TextStyle(
              // fontWeight: _glt.subtitleFontWeight,
              ),
        ),
        onValuePicked: (Country country) =>
            setState(() => cSelectedCountry = country),
        itemBuilder: _buildDialogItem,
      ),
    );
  }

  void _openOrganizationPickerDialog(Map organizationType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Your organization",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: organizationType
                  .map(
                    (key, value) => MapEntry(
                      key,
                      ListTile(
                        title: Text(
                          "${organizationType[key]}",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        trailing: OutlinedButton(
                          // style: _glt.generalOutlinedButtonStyle,
                          onPressed: () {
                            setState(() {
                              _organizationTypeKey = key;
                              _organizationTypeCon.text = organizationType[key];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Select",
                          ),
                        ),
                        // onTap: () {
                        //   setState(() {
                        //     _organizationTypeKey = key;
                        //     _organizationTypeCon.text = organizationType[key];
                        //   });
                        //   Navigator.pop(context);
                        // },
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  late ProgressDialog pr;
  void prInitAndStyle(BuildContext context, String message) {
    pr = ProgressDialog(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // final appInfo = Provider.of<AppInfo>(context);
    Color textFieldBorderColor = Colors.transparent;
    Color formTextColor = Colors.black.withOpacity(0.8);
    prInitAndStyle(context, "Creating account...");

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),

            ///
            /// !! FIELDS !!
            ///
            /// NAME AND PHONE
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                // color: _glt.cardPrimaryBorderColor),
              ),
              child: TextFormField(
                // cursorColor: _glt.themeColor,
                decoration: InputDecoration(
                  hintText: "Full name",
                  prefixIcon: const Icon(Icons.face),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                validator: (val) {
                  return validateField(val!);
                },
                onChanged: (val) {
                  setState(() {
                    sName = val;
                  });
                },
              ),
            ),
            const Divider(),

            /// PHONE SELECTOR
            const Padding(padding: EdgeInsets.all(2)),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                // color: _glt.cardPrimaryBorderColor),
              ),
              child: ListTile(
                  onTap: _openCountryPickerDialog,
                  title: _buildDialogItem(cSelectedCountry)),
            ),
            const Padding(padding: EdgeInsets.all(2)),

            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                // cursorColor: _glt.themeColor,
                decoration: InputDecoration(
                  hintText: "Phone e.g. 03123456789",
                  prefixIcon: const Icon(MdiIcons.phoneOutline),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                validator: (val) {
                  return validatePhoneNumber(val!);
                },
                onChanged: (val) {
                  setState(() {
                    sPhone = val;
                  });
                },
              ),
            ),
            const Divider(),

            /// ORGANIZATION SELECTOR
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  // _openOrganizationPickerDialog(appInfo.organizationType);
                },
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  // cursorColor: _glt.themeColor,
                  decoration: InputDecoration(
                    enabled: false,
                    hintText: "Select organization type",
                    prefixIcon: const Icon(MdiIcons.officeBuilding),
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor)),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor)),
                  ),
                  controller: _organizationTypeCon,
                ),
              ),
            ),
            const Divider(),

            /// EMAIL
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Email address",
                  prefixIcon: const Icon(MdiIcons.emailOutline),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                validator: (val) {
                  return validateEmail(val!.trim());
                },
                onChanged: (val) {
                  setState(() {
                    sEmail = val.trim();
                  });
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(2)),

            /// PASSWORD
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(MdiIcons.lockOutline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          togglePasswordVisibility(0);
                        },
                        icon: (showPasswords[0]
                            ? const Icon(
                                MdiIcons.eyeOutline,
                              )
                            : const Icon(
                                MdiIcons.eyeOffOutline,
                              )),
                      ),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFieldBorderColor)),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFieldBorderColor)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFieldBorderColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFieldBorderColor)),
                    ),
                    validator: (val) {
                      return validatePassword(val!);
                    },
                    obscureText: !showPasswords[0],
                    onChanged: (val) {
                      setState(() {
                        sPassword = val;
                      });
                    },
                  ),

                  // hint
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "* Password must contain at least 8 characters with at least 1 numeric, uppercase, lowercase, and special character",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(2)),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: TextFormField(
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  hintText: "Enter password again",
                  prefixIcon: const Icon(MdiIcons.lockCheck),
                  suffixIcon: IconButton(
                    onPressed: () {
                      togglePasswordVisibility(1);
                    },
                    icon: (showPasswords[1]
                        ? const Icon(
                            MdiIcons.eyeOutline,
                          )
                        : const Icon(
                            MdiIcons.eyeOffOutline,
                          )),
                  ),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textFieldBorderColor)),
                ),
                validator: (val) {
                  return validatePasswords(val!, sPassword);
                },
                obscureText: !showPasswords[1],
                onChanged: (val) {
                  setState(() {
                    sRePassword = val;
                  });
                },
              ),
            ),
            const Divider(),

            /// DOB AND GENDER
            // Container(
            //   padding: EdgeInsets.only(left: 5),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //     color: Colors.white,
            //     border: Border.all(color: _glt.cardPrimaryBorderColor),
            //   ),
            //   child: ListTile(
            //     onTap: () => _selectDate(context),
            //     title: Row(
            //       children: <Widget>[
            //         Icon(
            //           MdiIcons.cake,
            //           color: Colors.grey[600],
            //         ),
            //         Padding(
            //           padding: EdgeInsets.only(right: 10),
            //         ),
            //         Text(
            //           dob ?? "Pick a birth date",
            //           style: TextStyle(
            //             color: Colors.grey[600],
            //           ),
            //         ),
            //       ],
            //     ),
            //     // leading: Icon(MdiIcons.cake),
            //     trailing: Icon(Icons.arrow_drop_down),
            //   ),
            // ),

            // Padding(padding: EdgeInsets.all(5)),

            /// ERROR
            Center(
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  // fontSize: 3 * _glt.errorFontSize / 4,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),

            /// SIGN UP BUTTON
            Container(
              width: double.infinity,
              // decoration: _glt.buttonDecor,
              child: FlatButton(
                child: Text(
                  "Get started for free".toUpperCase(),
                  // style: _glt.buttonDecorTextStyle,
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() != null) {
                    // pr?.show();
                    UserModel user = UserModel(
                      email: sEmail,
                      password: sPassword,
                      name: sName,
                      phone: cSelectedCountry.phoneCode + sPhone.substring(1),
                      gender: gender,
                    );
                    // print(user.toMap());
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        user, sPassword, imageFile);
                    if (result is UserUid) {
                      // await pr?.hide();
                    } else {
                      // pr?.hide();
                      setState(() {
                        error = result;
                      });
                    }
                  }
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),

            /// NEW USER BUTTON
            Container(
              width: double.infinity,
              child: OutlinedButton(
                child: Text(
                  "Already have an account? Sign in".toUpperCase(),
                ),
                onPressed: () {
                  widget.toggleAmongAuthPages(0);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(60)),
          ],
        ),
      ),
    );
  }
}
