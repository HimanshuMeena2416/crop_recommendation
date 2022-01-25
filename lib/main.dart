import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/components/screens/education.dart';
import 'package:flutter/material.dart';

import 'components/screens/exportsScreens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await UserSheetAPI.init();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => Firstscreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        DatePicker.id: (context) => DatePicker(),
      },
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green,
      ),
    );
  }
}
