import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class DatePicker extends StatefulWidget {
  static const String id = 'date';
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  int stateNum=0;
  int monthNum = DateTime.now().month-1;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.administrativeArea}";
        stateNum = states.indexWhere((element) => element.contains(_currentAddress));
      });
    } catch (e) {
      print(e);
    }
  }

  String _chosenMonth = '';
  String _defalutMonth = 'jan';
  String _chosenstate = '';
  String _defaultstate = 'Raj';

  var feedbackItems;

  Uri uri = Uri.parse("https://script.google.com/macros/s/AKfycbx6SFiP1CDuilvak1QDFk-mQOFD91wCmx9pT2o_38c9F41c74fjU8Vyq9-XYHW0sQIf/exec");
  Future<List> getFeedbackList() async {
    return await http
        .get(uri)
        .then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getFeedbackList().then((feedbackItems) {
      this.feedbackItems = feedbackItems;
      setState(() {
        cropName = feedbackItems[35 - stateNum][monthNum + 1].toString();
      });
    });
  }

  List<String> states = [
    'AP|Andhra Pradesh',
    'AR|Arunachal Pradesh',
    'AS|Assam',
    'BR|Bihar',
    'CT|Chhattisgarh',
    'GA|Goa',
    'GJ|Gujarat',
    'HR|Haryana',
    'HP|Himachal Pradesh',
    'JK|Jammu and Kashmir',
    'JH|Jharkhand',
    'KA|Karnataka',
    'KL|Kerala',
    'MP|Madhya Pradesh',
    'MH|Maharashtra',
    'MN|Manipur',
    'ML|Meghalaya',
    'MZ|Mizoram',
    'NL|Nagaland',
    'OR|Odisha',
    'PB|Punjab',
    'RJ|Rajasthan',
    'SK|Sikkim',
    'TN|Tamil Nadu',
    'TG|Telangana',
    'TR|Tripura',
    'UT|Uttarakhand',
    'UP|Uttar Pradesh',
    'WB|West Bengal',
    'AN|Andaman and Nicobar Islands',
    'CH|Chandigarh',
    'DN|Dadra and Nagar Haveli',
    'DD|Daman and Diu',
    'DL|Delhi',
    'LD|Lakshadweep',
    'PY|Puducherry',
  ];

  List<String> months = [
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

  String cropName = "";
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    print(feedbackItems.toString());
    print("aman");
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                "Select Month and State",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey,width: 2),
              ),
              child: DropdownButton<String>(
                style: TextStyle(color: Colors.black),
                isExpanded: true,
                items: <String>[
                  'AP|Andhra Pradesh',
                  'AR|Arunachal Pradesh',
                  'AS|Assam',
                  'BR|Bihar',
                  'CT|Chhattisgarh',
                  'GA|Goa',
                  'GJ|Gujarat',
                  'HR|Haryana',
                  'HP|Himachal Pradesh',
                  'JK|Jammu and Kashmir',
                  'JH|Jharkhand',
                  'KA|Karnataka',
                  'KL|Kerala',
                  'MP|Madhya Pradesh',
                  'MH|Maharashtra',
                  'MN|Manipur',
                  'ML|Meghalaya',
                  'MZ|Mizoram',
                  'NL|Nagaland',
                  'OR|Odisha',
                  'PB|Punjab',
                  'RJ|Rajasthan',
                  'SK|Sikkim',
                  'TN|Tamil Nadu',
                  'TG|Telangana',
                  'TR|Tripura',
                  'UT|Uttarakhand',
                  'UP|Uttar Pradesh',
                  'WB|West Bengal',
                  'AN|Andaman and Nicobar Islands',
                  'CH|Chandigarh',
                  'DN|Dadra and Nagar Haveli',
                  'DD|Daman and Diu',
                  'DL|Delhi',
                  'LD|Lakshadweep',
                  'PY|Puducherry',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                elevation: 8,
                hint: Text(
                  "Select state",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                value: stateNum!=null ? states[stateNum] : states[0],
                onChanged: (String value) {
                  stateNum = states.indexOf(value);
                  print(states.indexOf(value));
                  setState(() {
                    _chosenstate = _defaultstate;
                  });
                },
              ),
            ),
            Container(

              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey,width: 2),
              ),
              child: DropdownButton<String>(
                style: TextStyle(color: Colors.black),
                isExpanded: true,
                items: <String>[
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
                  'dec'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Select month",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                value: monthNum!=null ? months[monthNum] : months[0],
                onChanged: (String value) {
                  monthNum = months.indexOf(value);
                  print(months.indexOf(value).toString());
                  setState(() {
                    _chosenMonth = _defalutMonth;
                  });
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Current location',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            if (_currentPosition != null &&
                                _currentAddress != null)
                              Text(_currentAddress,
                                  style:
                                  Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if(feedbackItems!=null)
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
                  print(feedbackItems[35][monthNum]);

                  setState(() {
                    cropName = feedbackItems[35 - stateNum][monthNum + 1].toString();
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
                      "Recommended Crop  ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.trending_flat_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            if(cropName!="")
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cropName.split(",").length,
                itemBuilder: (context,index){
                  List crops = cropName.split(",");
                  return Text("${index+1}. ${crops[index]}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
