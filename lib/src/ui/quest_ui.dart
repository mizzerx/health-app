import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speeed_measuring/src/components/header_tab.dart';
import 'package:speeed_measuring/src/components/list_item.dart';
import 'package:speeed_measuring/src/models/quest.dart';

List<Quest> dummyData = [
  Quest(
    name: 'Master Walker',
    distance: 3.0,
    time: 2,
    pace: 5,
    avgSpeed: 6,
  ),
  Quest(
    name: 'Master Walker 1',
    distance: 4.0,
    time: 3,
    pace: 6,
    avgSpeed: 7,
  ),
  Quest(
    name: 'Master Walker 2',
    distance: 5.0,
    time: 4,
    pace: 7,
    avgSpeed: 8,
  ),
  Quest(
    name: 'Master Walker 3',
    distance: 6.0,
    time: 5,
    pace: 8,
    avgSpeed: 8,
  ),
];

class QuestUi extends StatefulWidget {
  const QuestUi({Key? key}) : super(key: key);

  @override
  State<QuestUi> createState() => _QuestUiState();
}

class _QuestUiState extends State<QuestUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quest',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 24.0)),
            const HeaderTab(),
            const SizedBox(height: 8.0),
            ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListItem(
                    data: dummyData[index],
                    initialTarget: const LatLng(21.0297414, 105.7850959),
                  ),
                );
              },
              itemCount: dummyData.length,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
