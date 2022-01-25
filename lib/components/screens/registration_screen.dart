import 'package:flash_chat/components/screens/firstscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;

  bool obscureText = true;

  final _registrationformKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              height: height/4,
              alignment: Alignment.center,
              child: Text(
                "Sign Up Portal",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _registrationformKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        validator: (value) {
                          final isValidEmail = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (value.isEmpty)
                            return "Email is needed 😬";
                          else if (!isValidEmail)
                            return "Please enter a valid email";
                          else
                            return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(fontSize: 15.0),
                            suffixIcon: Icon(Icons.email),
                            contentPadding:
                                EdgeInsets.only(top: 20.0, left: 20.0),
                            fillColor: Colors.white),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        obscureText: obscureText,
                        onSaved: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            hintStyle: TextStyle(fontSize: 15.0),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  if (obscureText)
                                    obscureText = false;
                                  else
                                    obscureText = true;
                                });
                              },
                              child: Icon(Icons.remove_red_eye),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            fillColor: Colors.white),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
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
                onPressed: () async {
                  print(email);

                  if (_registrationformKey.currentState.validate())
                    try {
                      final newUser =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      if (newUser != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Firstscreen()));
                      }
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Email is not exist!")));
                    }

                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  elevation: 10,
                  fixedSize: const Size(300, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up  ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.login,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Already have an account?"),
                    TextSpan(
                        text: " Log In",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                style: TextStyle(
                    fontSize: 16.0, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
