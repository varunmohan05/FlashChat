import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LoadingLocation{
  Geolocator geolocator = Geolocator();
  String cityName;
  Position currentLocation;
  List<Placemark> placemark;
  Future<String> getLocation() async {

    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    print(currentLocation);

    placemark = await Geolocator().placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
    print(placemark[0].locality);

    cityName=placemark[0].locality;

    return cityName;
  }
}