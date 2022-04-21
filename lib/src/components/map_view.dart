import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speeed_measuring/src/components/info_box.dart';
import 'package:speeed_measuring/src/models/location_model.dart';
import 'package:speeed_measuring/src/models/quest.dart';
import 'package:speeed_measuring/src/utils/distance_utils.dart';

class MapView extends StatefulWidget {
  const MapView({
    Key? key,
    required this.infoData,
    this.markerImage,
    this.isStart = true,
  }) : super(key: key);

  final String? markerImage;
  final bool isStart;
  final Quest infoData;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  final List<LatLng> _polylineCoordinates = const <LatLng>[
    LatLng(21.0297414, 105.7850959),
    LatLng(21.029629960511876, 105.78507330268623),
    LatLng(21.029488509281205, 105.78601341694593),
    LatLng(21.030587569294628, 105.7862176001072),
    LatLng(21.03027493886855, 105.7881360501051),
    LatLng(21.03604081494344, 105.78963004052639),
    LatLng(21.03646984353302, 105.7900045439601),
    LatLng(21.03804293779069, 105.79038944095373),
    LatLng(21.03922047887684, 105.7905500382185),
    LatLng(21.039799075909468, 105.79053327441217),
    LatLng(21.03992236779359, 105.79080753028393),
    LatLng(21.037648648766925, 105.7937153801322),
    LatLng(21.03746026586493, 105.79390916973352),
    LatLng(21.03716079288749, 105.79409155994655),
    LatLng(21.037143268849274, 105.7943108305335),
    LatLng(21.0372746990857, 105.79450495541096),
    LatLng(21.037345733950914, 105.7945528998971),
    LatLng(21.03712511895037, 105.79475741833448),
    LatLng(21.036753045535534, 105.7948999106884),
    LatLng(21.03682971338836, 105.79558923840523),
    LatLng(21.03718958237439, 105.79566467553377),
  ];

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future<Position> _getCurrentLocation() async {
    final permission = await _geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await _geolocatorPlatform.getCurrentPosition();
      return position;
    }

    await _geolocatorPlatform.requestPermission();
    return _getCurrentLocation();
  }

  String _calcDistance() {
    double distance = 0.0;

    for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
      distance += calculateDistance(
        currentLocation: SelfLocation(
          latitude: _polylineCoordinates[i].latitude,
          longitude: _polylineCoordinates[i].longitude,
        ),
        targetLocation: SelfLocation(
          latitude: _polylineCoordinates[i + 1].latitude,
          longitude: _polylineCoordinates[i + 1].longitude,
        ),
      );
    }

    return '${distance.toStringAsFixed(2)} km';
  }

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    if (widget.markerImage != null) {
      BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        widget.markerImage!,
      ).then((value) {
        _markerIcon = value;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      InfoBox(
                        displayTitle: 'Distance',
                        displayValue:
                            '${widget.infoData.distance.toStringAsFixed(2)} km',
                        boxColor: Colors.blue,
                      ),
                      InfoBox(
                        displayTitle: 'Pace',
                        displayValue: widget.infoData.pace.toString(),
                        boxColor: Colors.blue,
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Colors.blue[900]!,
                            width: 1.0,
                          ),
                        ),
                      ),
                      InfoBox(
                        displayTitle: 'Time',
                        displayValue: '${widget.infoData.time} min',
                        boxColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffffffff),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: !widget.isStart
                      ? startedMap(snapshot)
                      : stopedMap(snapshot),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _getCurrentLocation(),
    );
  }

  GoogleMap startedMap(AsyncSnapshot<Position> snapshot) {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          snapshot.data!.latitude,
          snapshot.data!.longitude,
        ),
        zoom: 13.5,
      ),
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            snapshot.data!.latitude,
            snapshot.data!.longitude,
          ),
          icon: _markerIcon,
        ),
        Marker(
          markerId: const MarkerId('target_location'),
          position: const LatLng(21.03718958237439, 105.79566467553377),
          icon: _markerIcon,
        ),
      },
      onTap: (latLng) {
        print(latLng);
      },
      polylines: <Polyline>{
        Polyline(
          polylineId: const PolylineId('route'),
          visible: true,
          points: _polylineCoordinates,
          color: Colors.red,
          width: 3,
        ),
      },
    );
  }

  GoogleMap stopedMap(AsyncSnapshot<Position> snapshot) {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          snapshot.data!.latitude,
          snapshot.data!.longitude,
        ),
        zoom: 13.5,
      ),
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}
