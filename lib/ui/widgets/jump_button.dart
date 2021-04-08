import 'package:flutter/material.dart';

class JumpButton extends StatelessWidget {
  const JumpButton({
    Key key,
    this.onPress,
  }) : super(key: key);

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        minimumSize: Size(0, 0),
        padding: EdgeInsets.all(10),
        primary: Colors.yellow,
      ),
      onPressed: onPress,
      child: Icon(
        Icons.arrow_circle_up,
        color: Colors.blue,
        size: 50,
      ),
    );
  }
}
