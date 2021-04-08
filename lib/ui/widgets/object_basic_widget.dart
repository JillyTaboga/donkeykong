import 'package:donkeykong/models/object_model.dart';
import 'package:flutter/material.dart';

class ObjectBasicWidget extends StatelessWidget {
  const ObjectBasicWidget({
    Key key,
    @required this.object,
  }) : super(key: key);

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: object.position.dy,
      left: object.position.dx,
      child: Container(
        width: object.width,
        height: object.height,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
  }
}
