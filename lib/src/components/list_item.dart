import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speeed_measuring/src/components/header_button.dart';
import 'package:speeed_measuring/src/models/quest.dart';
import 'package:speeed_measuring/src/ui/speed_ui.dart';

class ListItem extends StatefulWidget {
  const ListItem({Key? key, required this.initialTarget, required this.data})
      : super(key: key);

  final LatLng initialTarget;
  final Quest data;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0.0, 1.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.initialTarget,
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subText(
                  text: 'Distance',
                  value: '${widget.data.distance.toStringAsFixed(2)}km'),
              subText(text: 'Time', value: '${widget.data.time} hours'),
              subText(text: 'Pace', value: '${widget.data.pace} km/h'),
              subText(
                  text: 'Average speed',
                  value: '${widget.data.avgSpeed.toStringAsFixed(2)} km/h'),
            ],
          ),
          Column(
            children: [
              HeaderButton(
                value: 'Join',
                currentValue: 'Join',
                activeColor: Colors.orange,
                onPressed: (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpeedUi(
                        infoData: widget.data,
                      ),
                    ),
                  );
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8.0)),
              HeaderButton(
                value: 'Detail',
                currentValue: 'Detail',
                activeColor: Colors.blue,
              )
            ],
          )
        ],
      ),
    );
  }

  Text subText({required String text, required String value}) {
    return Text(
      '$text: $value',
      style: TextStyle(
        fontSize: 12.0,
        color: Colors.grey[500],
      ),
    );
  }
}
