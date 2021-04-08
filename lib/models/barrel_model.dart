import 'dart:math';

import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BarrelModel extends PhysicObject {
  bool right;

  ///A int that determines the barrel speed in horizontal, lower is slow, has to be more than 0
  double velocity;
  CellGrid rightSpawn;
  CellGrid leftSpawn;

  BarrelModel.right({
    @required this.rightSpawn,
    @required this.velocity,
  }) : super(
          startCell: rightSpawn,
          finalCell:
              CellGrid(column: rightSpawn.column + 1, row: rightSpawn.row + 1),
          initialVelocityRight: Get.find<GridController>().unitSize.width /
              (Random().nextInt((velocity / 2).floor()) + velocity),
          applyGravity: true,
          asset: 'assets/barrel.gif',
          contacts: [
            ContactType.Enemy,
          ],
          onContacts: [
            (type) {
              if (type == ContactType.Barrier) {
                return Speeds.reverse();
              } else {
                return null;
              }
            },
          ],
          position: rightSpawn.position,
        );

  BarrelModel.left({
    @required this.leftSpawn,
    @required this.velocity,
  }) : super(
          startCell: leftSpawn,
          finalCell:
              CellGrid(column: leftSpawn.column + 1, row: leftSpawn.row + 1),
          initialVelocityLeft: Get.find<GridController>().unitSize.width /
              (Random().nextInt((velocity / 2).floor()) + velocity),
          applyGravity: true,
          asset: 'assets/barrel.gif',
          contacts: [
            ContactType.Enemy,
          ],
          onContacts: [
            (type) {
              if (type == ContactType.Barrier) {
                return Speeds.reverse();
              } else {
                return null;
              }
            },
          ],
          position: leftSpawn.position,
          isPlayer: false,
        );

  factory BarrelModel.random({
    @required CellGrid leftSpawn,
    @required CellGrid rightSpawn,
    @required double velocity,
  }) {
    bool right = Random().nextBool();
    return right
        ? BarrelModel.right(rightSpawn: rightSpawn, velocity: velocity)
        : BarrelModel.left(leftSpawn: leftSpawn, velocity: velocity);
  }
}
