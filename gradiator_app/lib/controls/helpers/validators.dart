// import 'package:firesnag_mobile/models/project/tagMap.dart';

String validateEmail(String val) {
  // Pattern pattern =
  //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if (val != null || val.isNotEmpty) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(val)) {
      return "Enter valid email";
    } else {
      return "null";
    }
  } else {
    return 'Enter a valid email';
  }
}

String validateEmailAgain(String val1, String val2) {
  if (val1.compareTo(val2) != 0) {
    return "Emails do not match";
  } else {
    return "";
  }
}

String validateField(String val) {
  if (val.isEmpty) {
    return "This field cannot be left empty";
  } else {
    return "";
  }
}

String validatePassword(String val) {
  // Pattern pattern =
  //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (!regExp.hasMatch(val)) {
    return "Password criteria does not match";
  } else {
    return "";
  }
}

String validatePasswords(String val1, String val2) {
  if (val1.compareTo(val2) != 0) {
    return "Passwords do not match";
  } else {
    return "";
  }
}

/// DOCS: https://www.quora.com/What-is-maximum-and-minimum-length-of-any-mobile-number-across-the-world
String validatePhoneNumber(String val) {
  /// e.g. 03333224567 (acceptable - strict!)
  // Pattern pattern = r'^(?:[0])[0-9]{4,15}$';
  RegExp regExp = RegExp(r'^(?:[0])[0-9]{4,15}$');
  if (!regExp.hasMatch(val)) {
    return "Please enter valid phone number";
  } else {
    return "";
  }
}

String validateNumberWithExt(String val) {
  /// e.g. +923333226127
  // Pattern pattern = r'^([+][1-9]{1}\d{2})\d{4,15}$';
  RegExp regExp = RegExp(r'^([+][1-9]{1}\d{2})\d{4,15}$');
  if (!regExp.hasMatch(val)) {
    return "Please enter valid phone number";
  } else {
    return "";
  }
}

// String validateTagExistInTagMapList(String val, List<dynamic> listOfMap) {
//   if (val.isNotEmpty) {
//     for (int i = 0; i < listOfMap.length; ++i) {
//       TagMap tagMap = TagMap.fromMap(listOfMap[i]);
//       if (tagMap.name.compareTo(val) == 0) {
//         return "$val is already added, please select another name";
//       }
//     }
//     return null;
//   } else {
//     return "This cannot be left empty";
//   }
// }
