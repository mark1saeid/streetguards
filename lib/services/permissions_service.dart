 import 'package:geolocator/geolocator.dart';

Future<bool> checkAndRequestLocationPermission() async {
   bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
   if(!isLocationServiceEnabled){
      Geolocator.requestPermission();
      return false;
   }
   return true;
}
