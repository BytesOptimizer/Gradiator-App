import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradiator_app/cidgets/BlurFilter.dart';
import 'package:gradiator_app/pages/auth/ForgotPassPage.dart';
import 'package:gradiator_app/pages/auth/LoginPage.dart';
import 'package:gradiator_app/pages/auth/RegisterPage.dart';

class AuthController extends StatefulWidget {
  @override
  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  int openRelevantAuthPage = 0;
  void toggleAmongAuthPages(int index) {
    setState(() {
      openRelevantAuthPage = index;
    });
  }

  Future<bool> _onWillPop() async {
    // subpage to login page
    if (openRelevantAuthPage != 0) {
      setState(() {
        openRelevantAuthPage = 0;
      });
      return false;
    }
    // otherwise pop to previous activity
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(milliseconds: 200);
    const colorizeColors = [
      Colors.white,
      Colors.grey,
      Colors.white,
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.w100,
      letterSpacing: 2,
    );
    List<String> snips = [
      "assets/background/back_7.jpg",
      "assets/background/back_6.jpg",
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          // color: _glt.customColor,
          child: Stack(
            children: [
              BlurFilter(
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    // aspectRatio: 1,
                    // enlargeCenterPage: false,
                    // autoPlayInterval: const Duration(seconds: 7),
                    autoPlayAnimationDuration: const Duration(seconds: 30),
                    autoPlayCurve: Curves.linear,
                    // disableCenter: true,
                    height: MediaQuery.of(context).size.height,
                  ),
                  itemCount: snips.length,
                  itemBuilder: (BuildContext context, int index, int dontknow) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(snips[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.85),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: conHeight,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DefaultTextStyle(
                            style: GoogleFonts.openSans(
                              textStyle: colorizeTextStyle,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  '   Insert text  ',
                                  // duration: duration,
                                  speed: duration,
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                                ColorizeAnimatedText(
                                  'Insert text',
                                  // duration: duration,
                                  // speed: duration,
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                              repeatForever: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 27),
                            Container(
                              // height: maxOptimizedHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.6),
                                    offset: Offset(0, -7),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: _leadToRelevantPage(),
                            ),
                          ],
                        ),
                        // Align(
                        //   alignment: Alignment.topCenter,
                        //   child: Container(
                        //     height: 70,
                        //     padding: EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       color: Colors.blueAccent,
                        //       borderRadius: BorderRadius.circular(50),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.blueAccent,
                        //           offset: Offset(0, -12),
                        //           blurRadius: 10,
                        //           spreadRadius: -6,
                        //         ),
                        //       ],
                        //     ),
                        //     // child: Image.asset(_glt.defaultImage),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get maxOptimizedHeight {
    double origHeight = MediaQuery.of(context).size.height;
    print(origHeight);
    if (origHeight < 400) {
      return 400;
    } else if (origHeight < 600) {
      return 600;
    } else if (origHeight < 700) {
      return 650;
    } else if (origHeight < 800) {
      return 700;
    } else if (origHeight < 850) {
      return 750;
    } else if (origHeight < 1000) {
      return 950;
    } else if (origHeight < 1200) {
      return 1000;
    } else if (origHeight < 1500) {
      return 1200;
    } else {
      return 1400;
    }
  }

  double get conHeight {
    double factor = MediaQuery.of(context).size.height > 700 ? 0.12 : 0;
    return maxOptimizedHeight *
        (openRelevantAuthPage == 0
            ? 0.37 + factor
            : openRelevantAuthPage == 1
                ? 0.50 + factor
                : 0.0 + factor);
  }

  Widget _leadToRelevantPage() {
    List<Widget> _authPages = [
      LoginPage(
        toggleAmongAuthPages: toggleAmongAuthPages,
      ),
      ForgotPasswordPage(
        toggleAmongAuthPages: toggleAmongAuthPages,
      ),
      RegisterPage(
        toggleAmongAuthPages: toggleAmongAuthPages,
      )
    ];
    return _authPages[openRelevantAuthPage];
  }
}
