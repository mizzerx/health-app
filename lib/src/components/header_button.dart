import 'package:flutter/material.dart';

class HeaderButton extends StatefulWidget {
  const HeaderButton({
    Key? key,
    required this.value,
    required this.currentValue,
    this.onPressed,
    this.activeColor = Colors.purple,
  }) : super(key: key);

  final String value;
  final String currentValue;
  final Function? onPressed;
  final Color activeColor;

  @override
  State<HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: mediaQuery.size.width / 4,
        decoration: BoxDecoration(
          color:
              widget.value == widget.currentValue ? widget.activeColor : null,
          borderRadius: BorderRadius.circular(32.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            widget.value,
            style: TextStyle(
              color: widget.value == widget.currentValue
                  ? Colors.white
                  : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    if (widget.onPressed != null) {
      widget.onPressed!(widget.value);
    }
  }
}
