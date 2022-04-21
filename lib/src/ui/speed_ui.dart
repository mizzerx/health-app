import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speeed_measuring/src/components/info_box.dart';
import 'package:speeed_measuring/src/components/map_view.dart';
import 'package:speeed_measuring/src/components/speedometer.dart';
import 'package:speeed_measuring/src/models/quest.dart';

class SpeedUi extends StatefulWidget {
  const SpeedUi({Key? key, required this.infoData}) : super(key: key);

  final Quest infoData;

  @override
  State<SpeedUi> createState() => _SpeedUiState();
}

class _SpeedUiState extends State<SpeedUi> {
  int _speed = 0;
  List<HealthDataPoint> _dataPoints = [];
  bool _isStart = false;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final HealthFactory _healthFactory = HealthFactory();
  final List<HealthDataType> typesAndroid = [
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.MOVE_MINUTES,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE
  ];
  final List<HealthDataType> typesIOS = [
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.WORKOUT,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE
  ];
  List<HealthDataType> types = [];

  StreamSubscription<Position>? _positionStreamSubscription;
  bool positionStreamStarted = false;

  Future<bool> _handleActivitiesRecognitionPermission() async {
    final PermissionStatus permission =
        await Permission.activityRecognition.request();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.permanentlyDenied) {
      return false;
    }

    return true;
  }

  Future<List<HealthDataPoint>> _getHealthData() async {
    bool request = await _healthFactory.requestAuthorization(
      defaultTargetPlatform == TargetPlatform.android ? typesAndroid : typesIOS,
    );
    DateTime now = DateTime.now();
    List<HealthDataPoint> dataPoints = [];

    if (request) {
      dataPoints = await _healthFactory.getHealthDataFromTypes(
        now.subtract(
          const Duration(days: 1),
        ),
        now,
        defaultTargetPlatform == TargetPlatform.android
            ? typesAndroid
            : typesIOS,
      );
      dataPoints = HealthFactory.removeDuplicates(dataPoints);

      if (mounted) {
        setState(() {
          _dataPoints = dataPoints;
        });
      }
    }

    return dataPoints;
  }

  void _startListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();

      _positionStreamSubscription = positionStream.handleError((err) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        setState(() {
          if (position.speed > 0) {
            _speed = (position.speed * 3.6).round();
          }
        });
      });
      _positionStreamSubscription?.resume();
    }
  }

  HealthDataPoint? _getHeathDataPoint(HealthDataType type) {
    List<HealthDataPoint> data =
        _dataPoints.where((dataPoint) => dataPoint.type == type).toList();

    if (data.isNotEmpty) {
      return data.first;
    }

    return null;
  }

  void _requestPermissionsAsync() async {
    // await _handleLocationPermission();
    await _handleActivitiesRecognitionPermission();
  }

  Future<int> _getSteps() async {
    int? steps = await _healthFactory.getTotalStepsInInterval(
      DateTime.now().subtract(
        const Duration(days: 1),
      ),
      DateTime.now(),
    );

    if (steps != null) {
      return steps;
    }

    return 0;
  }

  @override
  void initState() {
    types = defaultTargetPlatform == TargetPlatform.android
        ? typesAndroid
        : typesIOS;
    _requestPermissionsAsync();
    super.initState();
  }

  @override
  dispose() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Quest',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MapView(
                isStart: _isStart,
                infoData: widget.infoData,
              ),
              const Padding(padding: EdgeInsets.only(top: 24.0)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Current speed',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _currentSpeed()
            ],
          ),
        ),
      ),
    );
  }

  Padding _currentSpeed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            _speedometerStack(),
            const Padding(padding: EdgeInsets.only(top: 32.0)),
            _toggleButton()
          ],
        ),
      ),
    );
  }

  Container _toggleButton() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100]!,
        borderRadius: BorderRadius.circular(120.0),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isStart = !_isStart;

            if (_isStart) {
              _startListening();
              _getHealthData();
            } else {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _speed = 0;
            }
          });
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: _isStart ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: Center(
            child: Text(
              _isStart ? 'Stop' : 'Start',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stack _speedometerStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Speedometer(
          size: 180,
          minValue: 0,
          maxValue: 15,
          currentValue: _speed,
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
        _healthInfo(),
      ],
    );
  }

  FutureBuilder<List<HealthDataPoint>> _healthInfo() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              InfoBox(
                boxColor: Colors.lightBlue,
                displayTitle: 'S',
                displayValue:
                    '${_getHeathDataPoint(types[0]) != null ? _getHeathDataPoint(types[0])!.value.toInt() / 1000 : 0}km',
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              InfoBox(
                boxColor: Colors.grey,
                displayTitle: 'Time',
                displayValue:
                    '${_getHeathDataPoint(types[1]) != null ? _getHeathDataPoint(types[1])!.value : 0}min',
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              FutureBuilder<int>(
                future: _isStart ? _getSteps() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return InfoBox(
                      boxColor: Colors.orange,
                      displayTitle: 'Step',
                      displayValue: snapshot.data.toString(),
                    );
                  }

                  return const InfoBox(
                    boxColor: Colors.orange,
                    displayTitle: 'Step',
                    displayValue: '0',
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              InfoBox(
                boxColor: Colors.purple,
                displayTitle: 'Heart',
                displayValue:
                    '${_getHeathDataPoint(types[3]) != null ? _getHeathDataPoint(types[3])!.value : 0}bpm',
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: _getHealthData(),
    );
  }
}
