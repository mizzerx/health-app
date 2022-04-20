import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'painter.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({
    Key? key,
    this.size = 200,
    this.minValue = 0,
    this.maxValue = 100,
    this.currentValue = 0,
    this.hightlightStart = 0,
    this.hightlightEnd = 0,
    this.backgroundColor = Colors.black,
    this.meterColor = Colors.grey,
    this.highlightColor = Colors.redAccent,
    this.kimColor = Colors.black,
    this.displayNumericStyle = const TextStyle(),
    this.displayTextUnit = '',
    this.displayTextUnitStyle = const TextStyle(),
  }) : super(key: key);

  final double size;
  final int minValue;
  final int maxValue;
  final int currentValue;
  final int hightlightStart;
  final int hightlightEnd;
  final Color backgroundColor;
  final Color meterColor;
  final Color highlightColor;
  final Color kimColor;
  final TextStyle displayNumericStyle;
  final String displayTextUnit;
  final TextStyle displayTextUnitStyle;

  @override
  _SpeedometerState createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  @override
  Widget build(BuildContext context) {
    double _size = widget.size;
    int _minValue = widget.minValue;
    int _maxValue = widget.maxValue;
    int _currentValue = widget.currentValue;
    int _highlightStart = widget.hightlightStart;
    int _highlightEnd = widget.hightlightEnd;

    double _kimAngle = 0;

    if (_minValue <= _currentValue && _currentValue <= _maxValue) {
      _kimAngle = _currentValue / _maxValue;
    } else if (_currentValue < _minValue) {
      _kimAngle = 0;
    } else if (_currentValue > _maxValue) {
      _kimAngle = 1;
    }

    double _highlightAngleStart = 0;

    if (_minValue <= _highlightStart && _highlightStart <= _maxValue) {
      _highlightAngleStart = _highlightStart / _maxValue;
    } else if (_highlightStart < _minValue) {
      _highlightAngleStart = 0;
    } else if (_highlightStart > _maxValue) {
      _highlightAngleStart = 1;
    }

    int _highlightAngleEnd =
        _highlightEnd > _highlightStart ? _highlightEnd - _highlightStart : 0;

    if (_highlightEnd < _minValue) {
      _highlightAngleEnd = _minValue;
    } else if (_highlightEnd > _maxValue) {
      _highlightAngleEnd = _maxValue;
    }

    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: _size,
            height: _size,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(_size * 0.075),
                  child: Stack(children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        width: _size,
                        height: _size,
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: widget.kimColor,
                          //     blurRadius: 8.0,
                          //     spreadRadius: 4.0,
                          //   )
                          // ],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size(_size, _size),
                      painter: ArcPainter(
                        startAngle: 1,
                        sweepAngle: 1,
                        color: widget.meterColor,
                      ),
                    ),
                    CustomPaint(
                      size: Size(_size, _size),
                      painter: ArcPainter(
                        startAngle: 1 + _highlightAngleStart,
                        sweepAngle: _highlightAngleEnd / _maxValue,
                        color: widget.highlightColor,
                      ),
                    ),
                  ]),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: math.pi * 0.25 + math.pi * _kimAngle,
                    child: ClipPath(
                      clipper: KimClipper(),
                      child: Container(
                        width: _size * 0.46,
                        height: _size * 0.46,
                        color: widget.kimColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.currentValue.toString(),
                          style: widget.displayNumericStyle,
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(
                        //     left: 5,
                        //   ),
                        // ),
                        Text(
                          widget.displayTextUnit,
                          style: widget.displayTextUnitStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
