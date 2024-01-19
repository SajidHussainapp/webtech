import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webtech/Location/location.dart';
import 'package:webtech/pages/book_off.dart';
import 'package:webtech/utils.dart';

class BookOn extends StatefulWidget {
  @override
  State<BookOn> createState() => _BookOnState();
}

class _BookOnState extends State<BookOn> {
// ignore: prefer_typing_uninitialized_variables
  late final timeSheetID;
 Location1 l = Location1();
  Utils u = Utils();
  @override
  void initState() {
    super.initState();
    l.getGeoLocationPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
             Image.asset("images/webtech.JPG"),
            const Text(
              "App Test",
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "Book On",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 9,
            ),
            const Text(
              "Slide Right to Book On",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: SlideAction(
                onSubmit: () async {
                 String timeNow = await u.getCurrentTimeInJson();
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  String lati = position.latitude.toString();
                  String longi = position.longitude.toString();
                 String address= await u.getAddressFromLatLong(position);
                  timeSheetID = await bookOn(timeNow,lati, longi,address);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  BookOff( getid: timeSheetID,)),
                  );
                },
              ),
            ),
          ],
        )
      ],
    ));
  }

  Future<dynamic> bookOn(String time,String lati, String long,String address) async {
    Map<String, String> apiData = {
      "deviceUserName": "wahmed@gmail.com",
      "webUserName": "npm",
      "deviceUserfullName": "Waqas Ahmed",
      "timeIn": time,
      "timeOut": "",
      "bookOnLat": lati,
      "bookOnLong": long,
      "bookOnLocationName": address,
      "bookOffLat": "",
      "bookOffLong": "",
      "bookOffLocationName": "",
      "hoursWorked": "0"
    };

    return sendDataToAPI(apiData);
  }

  Future<dynamic> sendDataToAPI(Map<String, String> data) async {
    final Uri apiUrl = Uri.parse(
        "https://frontier.earnflex.com/bookOn_and_enter_timesheet_data");

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Parse the response to extract the timeSheetID
        final dynamic responseData = json.decode(response.body);
        final dynamic timeSheetID = responseData['timeSheetID'];
        // Print or use the timeSheetID as needed
        print('Response from API: $timeSheetID');
        return timeSheetID;
      } 
    } catch (e) {
      print('Error sending data to API: $e');
      return null;
    }
  }
}
