import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Utils {

    String getCurrentTimeInJson() {
    DateTime now = DateTime.now();
    return now.toString();
  }
  Future<String> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String address = '${place.subLocality}';
    return address;
  }
}