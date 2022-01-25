import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'exportsScreens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserSheetAPI{
  static const _credentials = r''' {
    "type": "service_account",
    "project_id": "gsheets-338105",
    "private_key_id": "f2918de684735a9d164d123a44a8f0cbb7807f5a",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCqEuqXwOXejZxR\nk7RYiLkRVK+mmxqzRP0xKnHuvMG5pb20qRdRyz4s6cmp4adt8MJF57YLhP3gi1pM\nimdRgVwI8zwM/ANneFzVXN2Kf5iHa8kb8TKa2PBc8BIzcSzJ0kYMeII/MXEJTWLG\nHK6WMVlminxgB9Xk0jufVBR51JIR7xlVsWEgEDYRQ7jy1JLUHxSuoaYla9Oc1G5b\nWEdbKVnFuyyPTSyFaINSOWpdZrIfDNdhQd3v9eTOhiuZIlIVlEru8w8gTxw7afFj\ncBElhDNYh0fBWQ48dBs48xzSXaF4CXPWs8MmlITJzp6Yzsu3nB2WNEeh+q2nEU5z\nI2cWF28pAgMBAAECggEAAXjX9FayKl5xqthYtJ+zWYjmkOkfQemSdA4O0f+OmOh4\nGKjNx5mcOMY0Lq1AkjDoJ2xkjEvKcd2lhCuYCfd0p/+YE5Ii4tk7Td0jkeQAKVVM\nrBjD5R7pyAIaf7bnrLKLQuELubHDT8LG9GZS5d+whUatgr/g2E+zJm8/+WxBlDI2\n+BrN9iyjSotx/Kt+elpkLHvjn/u1CRQgpI7/YNC/sDy4rZDSCGnJ80Qw6YSNTaLp\nwn46K+Bv1fC1O+KObRywxSIkPpZGkAcSC1wKc11uKy7ZSW8p8vhGu5FeR5ppetME\nh2QRUiSRItZaVDPY4jVnm4EHVVOp7FmIXxSjjkxyIwKBgQDs5geIbFqXO7j4I0ow\ncYTK/ig1+7DTk1RMY73gHkrZoj42kimhVX/HS/NLhIWOidJlqMv6t7mrzFzaQ0V8\nZRvre7Kp+LGm+78oYjkFgCQw8lCFYHBHuYy27Uy9Or4W+ESpoiACk55CJlo65Ulo\nfj7yj+JvPvuRXJxy9ham4J0DzwKBgQC3yYR79TgdlDINXs6Qd1vWlue/roV1qXTc\nPu9l1kl1QYOsnd9MumiwQVIP/ba1ON10QBQFm7222htVJonurS3/XBthW3AU4lwz\nDQwEDD4FN/fg/J2s46oswXKFa5jxpDsn3GMxosgyIAe+gQQg7OEcXJq8deZxi2wZ\nTC2lHJEDhwKBgQCBRvaNaDP3m8vQ/dEapphE/nWLIBLbIuc52KRhjaZjJbq1pQW6\n2SGl7LiUWXlY07VRbNADvgdAzYFOSq+8tqCJ3TMetmycJ32l2BQuAEO/wjxWzM35\nFjTIDq92BHx/pHQz7hlxzoTqrGtJAJ8SuvI3BHYZJ1G5fcSSp+CsqJ6G2QKBgDTB\nR6I9VYpIC8YCvNCDMn16e7Nt6SlJJx5Bgn588EEUOTPHbV2c9IgDeAbXEScb15WS\n/yxM9DwUh1v94AH+/AEc808S7C1SfJy61gQjb3oYArM2UBxcjXCjZrgdlp1mQwTC\nIkcRLt4Ui6SHbCP3WvbFLjWCsk9Ncg4g68lFVerpAoGBAINDBHP8FR7m6O09Hqgv\nJxq2jAKQ1XdwSvYMvGeBXj2X+ywJQA2B18IOT9NqXaJ5vjP9Ww+ZtBWYm71B0Uw6\nrczLyDqiWWB6lpDgRjmpDmWo64x6niyxmtrFVSIBaxUipsYw3FKVv+FBp4gVOx1X\nhOCnUYTgoa5bMAkFheOazbwX\n-----END PRIVATE KEY-----\n",
    "client_email": "gsheets@gsheets-338105.iam.gserviceaccount.com",
    "client_id": "114864211511313275972",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-338105.iam.gserviceaccount.com"
  }
  ''';
  static final _spreadSheetId = "1D2Q_FkJRCLUjhe55TeJVIeBkxym-B_C2vQFnWWpky2M";
  static final _gsheets = GSheets(_credentials);
  static Worksheet _userSheet;

  static Future init() async{
    final spreadsheet = await _gsheets.spreadsheet(_spreadSheetId);
    _userSheet = await _getWorkSheet(spreadsheet, title:'data');
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
        @required String title,
      }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e){
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static setValues(String string, int row, int col, BuildContext context){
    _userSheet.values.insertValue(string, column: row+1, row: col+1).then((value) {
      Navigator.pop(context);
    });
  }
}

class LoginScreen extends StatefulWidget {

  final String currentUserEmail;
  final String currentUserUid;
  static const String id = 'login_screen';

  const LoginScreen({Key key, this.currentUserEmail, this.currentUserUid}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(
    currentUserEmail: currentUserEmail,
    currentUserUid: currentUserUid,
  );
}

class _LoginScreenState extends State<LoginScreen> {

  final String currentUserEmail;
  final String currentUserUid;

  bool showSpinner = false;
  String newValue="";
  bool obsecureText = true;
  bool showLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  _LoginScreenState({this.currentUserEmail, this.currentUserUid});

  List<String> adminEmails = [
    "mukesh@iitrpr.ac.in",
    "himanshumeenaudr005@gmail.com"
  ];

  List feedbackItems;

  List<String> months = [
    'Month',
    'jan',
    'feb',
    'mar',
    'april',
    'may',
    'june',
    'july',
    'august',
    'sept',
    'oct',
    'nov',
    'dec',
  ];

  Widget box(String string, int row, int col){
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Do you want to change this? $row  ---  $col'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      onSaved: (value) {
                        newValue = value;
                      },
                      decoration: InputDecoration(
                        hintText: string,
                        hintStyle: TextStyle(fontSize: 15.0),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        fillColor: Colors.white,
                        filled: true,
                        helperText: string,
                      ),
                      onChanged: (value) {
                        newValue = value;
                      },
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close')),
                TextButton(
                  onPressed: () {
                    if(newValue!=""){
                      UserSheetAPI.setValues(newValue,row,col,context);
                      setState(() {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen(
                          currentUserUid: currentUserUid,
                          currentUserEmail: currentUserEmail,
                        )));
                      });
                    }
                  },
                  child: Text('Done'),
                )
              ],
            );
          });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey
          )
        ),
        child: Text(string),
        padding: EdgeInsets.all(5),
        height: 50,
      ),
    );
  }

  Uri uri = Uri.parse("https://script.google.com/macros/s/AKfycbx6SFiP1CDuilvak1QDFk-mQOFD91wCmx9pT2o_38c9F41c74fjU8Vyq9-XYHW0sQIf/exec");

  Future<List> getFeedbackList() async {
    return await http
        .get(uri)
        .then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      feedbackItems = jsonFeedback;
      return jsonFeedback;
    });
  }

  @override
  void initState() {
    super.initState();
    getFeedbackList().then((feedback) {
      print(feedback.toString());
      setState(() {
        feedbackItems = feedback;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children:[
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
              currentUserUid==""?"Log In Portal":"Admin Portal",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 25,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          if(currentUserUid!="")
            SizedBox(
              height: 10,
            ),
          if(currentUserUid!="")
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 20,right: 8,left: 8,top: 10),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Already logged in as "),
                    TextSpan(
                        text: currentUserEmail,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                style: TextStyle(
                    fontSize: 16.0, color: Theme.of(context).primaryColor),
              ),
            ),
          if(currentUserUid!=""&&feedbackItems!=null&&adminEmails.contains(currentUserEmail))
            Container(
              width: width,
              child: Row(
                children: [
                  Container(
                    width: width/4,
                    height: 650,
                    child: ListView.builder(
                      itemCount: months.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                width: 2,
                              )
                          ),
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(months[index]),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: width*3/4,
                    height: 650,
                    child: ListView.builder(
                      itemCount: feedbackItems.length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index2){
                        return Container(
                          child: Column(
                            children: [
                              box(feedbackItems[feedbackItems.length-1-index2][0],0, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][1],1, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][2],2, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][3],3, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][4],4, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][5],5, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][6],6, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][7],7, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][8],8, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][9],9, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][10],10, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][11],11, index2+1),
                              box(feedbackItems[feedbackItems.length-1-index2][12],12, index2+1),
                            ],
                          ),
                          width: width/3,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if(currentUserUid!="")
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
                  _auth.signOut().then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Firstscreen()));
                  }).catchError((e){

                  });
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
                      "Log out",
                      style: TextStyle(color: Colors.red),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),

          if(currentUserUid=="")
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            email = value;
                          },
                          validator: (value) {
                            final validEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                            if (!validEmail.hasMatch(value)) {
                              return "Please enter valid email";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(fontSize: 15.0),
                              suffixIcon: Icon(Icons.email),
                              contentPadding:
                                  EdgeInsets.only(top: 20.0, left: 20.0),
                              fillColor: Colors.white),
                          onChanged: (value){
                            email = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          obscureText: obsecureText,
                          onSaved: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter your Password',
                              hintStyle: TextStyle(fontSize: 15.0,),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (obsecureText)
                                      obsecureText = false;
                                    else
                                      obsecureText = true;
                                  });
                                },
                                child: Icon(Icons.vpn_key),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              fillColor: Colors.white),
                          onChanged: (value){
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        showLoading = true;
                      });
                      doLoging();
                      FocusScope.of(context).unfocus();
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
                        "Log In  ",
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
            ],
          ),
          if(currentUserUid=="")
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => RegistrationScreen(),
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "New here?"),
                      TextSpan(
                          text: " Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  style: TextStyle(
                      fontSize: 16.0, color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
          (showLoading)
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void doLoging() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password).then((value) {
            setState(() {
              showLoading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Firstscreen()));
      }).catchError((e){
        showDialog(context: context, builder: (context){
          return Dialog(
            child: Text("Something went wrong"),
          );
        });
      });
    } catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return Dialog(
          child: Text("Something went wrong"),
        );
      });
    }
  }
}
