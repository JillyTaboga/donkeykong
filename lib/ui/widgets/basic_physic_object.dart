import 'dart:math';

import 'package:donkeykong/controllers/object_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicPhysicObject extends StatefulWidget {
  final String objectId;
  final bool isPlayer;
  BasicPhysicObject({
    @required this.objectId,
    this.isPlayer = false,
  }) : super(key: ValueKey(objectId));

  @override
  _BasicPhysicObjectState createState() => _BasicPhysicObjectState();
}

class _BasicPhysicObjectState extends State<BasicPhysicObject> {
  final colors = [
    Colors.red,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
    Colors.green,
  ];
  Color color;

  @override
  void initState() {
    color = colors[Random().nextInt(colors.length)];
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ObjectController>(tag: widget.objectId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPlayer) {
      return createPlayer();
    } else if (Get.find<ObjectController>(tag: widget.objectId)
        .object
        .decoration) {
      return createDecoration();
    } else {
      return createObject();
    }
  }

  Widget createObject() {
    return GetBuilder<ObjectController>(
      tag: widget.objectId,
      builder: (controller) {
        return Positioned(
          top: controller?.position?.dy,
          left: controller?.position?.dx,
          child: Container(
            width: controller?.object?.width,
            height: controller?.object?.height,
            child: Column(
              children: List<String>.generate(
                      controller.heightCels, (index) => index.toString())
                  .map((e) => Expanded(
                        child: Row(
                          children: List<String>.generate(controller.widhtCels,
                                  (index) => index.toString())
                              .map(
                                (e) => Expanded(
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: controller.right
                                        ? Matrix4.rotationY(0)
                                        : Matrix4.rotationY(pi),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: controller.object.asset == null
                                            ? Colors.black
                                            : null,
                                        image: controller.object.asset == null
                                            ? null
                                            : DecorationImage(
                                                image: Image.asset(
                                                  controller.object.asset,
                                                ).image,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget createDecoration() {
    return GetBuilder<ObjectController>(
      tag: widget.objectId,
      builder: (controller) {
        return Positioned(
          top: controller?.position?.dy,
          left: controller?.position?.dx,
          child: Container(
              width: controller?.object?.width,
              height: controller?.object?.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset(controller.object.asset).image,
                  fit: BoxFit.fill,
                ),
              )),
        );
      },
    );
  }

  Widget createPlayer() {
    return GetBuilder<ObjectController>(
      tag: widget.objectId,
      builder: (controller) {
        var asset;
        switch (controller.playerStatus) {
          case PlayerStatus.Idle:
            asset = 'assets/mario.png';
            break;
          case PlayerStatus.Jumping:
            asset = 'assets/mariojumping.png';
            break;
          case PlayerStatus.Moving:
            asset = 'assets/mariowalking.gif';
            break;
          default:
        }
        return Positioned(
          top: controller?.position?.dy,
          left: controller?.position?.dx,
          child: Transform(
            alignment: Alignment.center,
            transform:
                controller.right ? Matrix4.rotationY(0) : Matrix4.rotationY(pi),
            child: Container(
                width: controller?.object?.width,
                height: controller?.object?.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(asset).image,
                    fit: BoxFit.fill,
                  ),
                )),
          ),
        );
      },
    );
  }
}
