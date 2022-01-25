import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/components/screens/aboutApp.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/screens/exportsScreens.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Firstscreen extends StatelessWidget {

  final FirebaseAuth auth = FirebaseAuth.instance;
  String email="";
  String uid="";

  Future<void> inputData() async {
    final User user = await auth.currentUser;
    uid = user.uid;
    email = user.email;
    print(email);
    print(uid);
  }


  @override
  void initState() {
    inputData();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
  }

  @override
  Widget build(BuildContext context) {

    inputData();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Theme.of(context).accentColor,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                height: height/3,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Welcome to Kisan App",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: SizedBox(
                        width: double.infinity, // <-- match_parent
                        height: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => AboutApp()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.white,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "About App   ",
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.account_balance_wallet_sharp,
                                color: Colors.black,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: height/2,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginScreen(
                                currentUserEmail: email,
                                currentUserUid: uid,
                              )));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          elevation: 10
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Admin Portal  ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.black,
                              size: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DatePicker()));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          elevation: 10
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Portal  ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.account_circle,
                              color: Colors.black,
                              size: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ReusableCard(
              //   time: 2,
              //   image: 'images/user.png',
              //   text: 'USER',
              //   nextChild: HomePage(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
