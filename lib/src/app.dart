import 'package:flutter/material.dart';
import 'package:speeed_measuring/src/ui/quest_ui.dart';
import 'package:speeed_measuring/src/ui/speed_ui.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speeed Measuring',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const QuestUi(),
    );
  }
}
