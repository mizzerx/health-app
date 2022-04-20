import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speeed_measuring/src/components/speedometer.dart';

class SpeedUi extends StatefulWidget {
  const SpeedUi({Key? key}) : super(key: key);

  @override
  State<SpeedUi> createState() => _SpeedUiState();
}

class _SpeedUiState extends State<SpeedUi> {
  int _speed = 0;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void _startListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();

      _positionStreamSubscription = positionStream.handleError((err) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
        print(err);
      }).listen((position) {
        setState(() {
          _speed = (position.speed * 3.6).round();
        });
      });
      _positionStreamSubscription?.resume();
    }
  }

  @override
  void initState() {
    _handlePermission();
    _startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed UI'),
      ),
      body: Center(
        child: Speedometer(
          size: 180,
          minValue: 0,
          maxValue: 15,
          currentValue: 10,
          hightlightStart: 4,
          hightlightEnd: 11,
          backgroundColor: Colors.white,
          displayTextUnit: 'km/h',
          displayTextUnitStyle: const TextStyle(
            fontSize: 11,
          ),
          displayNumericStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          highlightColor: Colors.green,
          meterColor: Colors.grey[300]!,
        ),
      ),
    );
  }
}
