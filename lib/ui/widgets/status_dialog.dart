import 'package:flutter/material.dart';

class DialogStatus extends StatelessWidget {
  const DialogStatus({
    Key key,
    @required this.buttonText,
    @required this.onPressButton,
    @required this.title,
  }) : super(key: key);

  final String title;
  final String buttonText;
  final Function onPressButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onPressButton,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
