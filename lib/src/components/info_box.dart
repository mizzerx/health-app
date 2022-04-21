import 'package:flutter/material.dart';

class InfoBox extends StatefulWidget {
  const InfoBox({
    Key? key,
    required this.displayTitle,
    required this.displayValue,
    this.boxColor = Colors.blueAccent,
    this.borderRadius = 8.0,
    this.border,
  }) : super(key: key);

  final String displayTitle;
  final String displayValue;
  final Color boxColor;
  final double borderRadius;
  final BoxBorder? border;

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: widget.boxColor,
            border: widget.border,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Text(
                  widget.displayTitle,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                widget.displayValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
