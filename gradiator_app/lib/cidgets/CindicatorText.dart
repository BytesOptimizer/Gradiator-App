import 'package:flutter/material.dart';
import 'package:gradiator_app/cidgets/Cindicator.dart';

class CindicatorText extends StatelessWidget {
  final String? text;
  CindicatorText({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Cindicator(color: Colors.green),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text("$text"),
            ]),
      ),
    );
  }
}
