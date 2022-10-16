import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradiator_app/controls/database/authService.dart';
import 'package:gradiator_app/controls/database/databaseService.dart';
import 'package:gradiator_app/models/user.dart';
import 'package:gradiator_app/pages/landing/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserUid>.value(
          initialData: UserUid(uid: "-1", isVerified: false),
          value: AuthService().userId,
        ),
      ],

      /// README: NEW MAIN STRUCTURED CODE (Zain)
      child: LayoutBuilder(
        builder: (context, _) {
          final userUid = Provider.of<UserUid>(context);

          // general streaming
          if (userUid != null) {
            return MultiProvider(
              providers: [
                StreamProvider<UserModel>.value(
                  initialData: UserModel(uid: "-1"),
                  value: DatabaseService(uid: userUid.uid).streamUserInfo(),
                ),
              ],
              child: _materialApp(context),
            );
          }
          // special streaming which is forced to fail (caught by MainActivity.dart)
          else {
            return MultiProvider(
              providers: [
                StreamProvider<UserModel>.value(
                  initialData: UserModel(uid: "-1"),
                  value: DatabaseService(uid: "-1").streamUserInfo(),
                ),
              ],
              child: _materialApp(context),
            );
          }
        },
      ),
    );
  }

  _materialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        unselectedWidgetColor: Colors.black,
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          // brightness: Brightness.dark,
          color: Colors.green,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          // textTheme: TextTheme(
          //   title: GoogleFonts.openSans(
          //     textStyle: TextStyle(
          //       fontSize: _glt.appbarFontSize,
          //       color: _glt.backgroundColor,
          //     ),
          //   ),
          // ),
        ),
        canvasColor:Colors.white,
        primaryTextTheme: TextTheme(
          bodyText2: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
      ),
      home: Wrapper(),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 border: Border.all(width: 4, color: Colors.black)),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Transform.rotate(
//                 angle: 10,
//                 origin: Offset(-10, -22),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(width: 4, color: Colors.black)),
//                     ),
//                     SizedBox(
//                         height: 80,
//                         child: Column(
//                           children: [
//                             Transform.rotate(
//                                 angle: pi / 2,
//                                 child: Icon(Icons.arrow_back_ios_rounded)),
//                             Expanded(
//                               child: VerticalDivider(
//                                 width: 4,
//                                 color: Colors.black,
//                                 thickness: 4,
//                               ),
//                             ),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   SizedBox(
//                       height: 80,
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: VerticalDivider(
//                               width: 4,
//                               color: Colors.black,
//                               thickness: 4,
//                             ),
//                           ),
//                           Transform.rotate(
//                               angle: -pi / 2,
//                               child: Icon(Icons.arrow_back_ios_rounded)),
//                         ],
//                       )),
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(width: 4, color: Colors.black)),
//                   ),
//                 ],
//               ),
//               Transform.rotate(
//                 angle: -10,
//                 origin: Offset(10, -22),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(width: 4, color: Colors.black)),
//                     ),
//                     SizedBox(
//                       height: 80,
//                       child: Column(
//                         children: [
//                           Transform.rotate(
//                               angle: pi / 2,
//                               child: Icon(Icons.arrow_back_ios_rounded)),
//                           Expanded(
//                             child: VerticalDivider(
//                               width: 4,
//                               color: Colors.black,
//                               thickness: 4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
