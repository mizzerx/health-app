import 'dart:math';

import 'package:speeed_measuring/src/models/location_model.dart';

double calculateDistance({
  required SelfLocation currentLocation,
  required SelfLocation targetLocation,
}) {
  final double lat1 = currentLocation.latitude;
  final double lon1 = currentLocation.longitude;
  final double lat2 = targetLocation.latitude;
  final double lon2 = targetLocation.longitude;

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  final double a =
      pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
  final double c = 2 * asin(sqrt(a));

  return c * 63.71;
}
