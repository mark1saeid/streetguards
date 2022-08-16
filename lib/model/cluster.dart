import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streetguards/model/incidents.dart';

class Place with ClusterItem {
  final Incident report;
  final LatLng latLng;

  Place({this.report, this.latLng});

  @override
  LatLng get location => latLng;
}
