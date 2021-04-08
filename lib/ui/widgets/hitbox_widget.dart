import 'package:donkeykong/controllers/object_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HitBox extends StatelessWidget {
  const HitBox({
    Key key,
    @required this.objectId,
  }) : super(key: key);
  final String objectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ObjectController>(
      tag: objectId,
      builder: (controller) => Positioned(
        top: controller.rect.top,
        left: controller.rect.left,
        child: Container(
          height: controller.rect.height,
          width: controller.rect.width,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
