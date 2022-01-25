import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutApp extends StatefulWidget {

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
                gradient: LinearGradient(
                    colors: [
                      Colors.green[800],
                      Colors.green[700],
                      Colors.green[600],
                      Colors.green[500],
                      Colors.green[400],
                      Colors.green[300],
                    ]
                )
            ),
            height: height/4,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "About the App",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 25,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
