import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart' as http;
import 'package:webtech/utils.dart';

// ignore: must_be_immutable
class BookOff extends StatelessWidget {
  BookOff({super.key, required this.getid});
  int getid;
  Utils u = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Image.asset("images/webtech.JPG"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "App Test",
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              "Book Off",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 9,
            ),
            const Text(
              "Slide Right to Book off",
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
                   Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  String lati = position.latitude.toString();
                  String longi = position.longitude.toString();
                  String timeNow = await u.getCurrentTimeInJson();
                  String address = await u.getAddressFromLatLong(position);

                  await bookOff(timeNow,lati,longi,address);
                },
              ),
            ),
          ],
        )
      ],
    ));
  }

  Future<dynamic> bookOff(String time,String lati, String long,String address) async {
    Map<String, String> apiData = {
      "timeSheetID": getid.toString(),
      "timeIn": "",
      "timeOut": time,
      "bookOffLat": lati,
      "bookOffLong": long,
      "bookOffLocationName": address
    };

    return sendDataToAPI(apiData);
  }

  Future<dynamic> sendDataToAPI(Map<String, String> data) async {
    final Uri apiUrl =
        Uri.parse("https://frontier.earnflex.com/bookOff_from_timesheet");

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print("Success");
      }
    } catch (e) {
      print('Error sending data to API: $e');
      return null;
    }
  }
}
