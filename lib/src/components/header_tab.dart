import 'package:flutter/material.dart';
import 'package:speeed_measuring/src/components/header_button.dart';

class HeaderTab extends StatefulWidget {
  const HeaderTab({Key? key}) : super(key: key);

  @override
  State<HeaderTab> createState() => _HeaderTabState();
}

class _HeaderTabState extends State<HeaderTab> {
  String _currentTab = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(32.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HeaderButton(
              value: 'Daily',
              currentValue: _currentTab,
              onPressed: _onTap,
            ),
            const Padding(padding: EdgeInsets.only(right: 4.0)),
            HeaderButton(
              value: 'Challenge',
              currentValue: _currentTab,
              onPressed: _onTap,
            ),
            const Padding(padding: EdgeInsets.only(right: 4.0)),
            HeaderButton(
              value: 'Club',
              currentValue: _currentTab,
              onPressed: _onTap,
            ),
            const Padding(padding: EdgeInsets.only(right: 4.0)),
          ],
        ),
      ),
    );
  }

  void _onTap(String value) {
    print('$value');
    setState(() {
      _currentTab = value;
    });
  }
}
