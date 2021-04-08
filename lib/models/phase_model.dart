import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:flutter/foundation.dart';

typedef List<PhysicObject> CreateStartObjects();

class PhaseModel {
  CreateStartObjects startObjects;
  CellGrid playerStartPosition;
  CellGrid rightBarrelSpawn;
  CellGrid leftBarrelSpawn;
  CellGrid kongPosition;
  CellGrid winSpot;
  double barrelSpeed;
  PhaseModel({
    @required this.startObjects,
    @required this.playerStartPosition,
    @required this.rightBarrelSpawn,
    @required this.leftBarrelSpawn,
    @required this.barrelSpeed,
    @required this.kongPosition,
    @required this.winSpot,
  });
}
