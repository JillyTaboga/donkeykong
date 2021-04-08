import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/models/floor_model.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/models/phase_model.dart';
import 'package:donkeykong/models/stair_model.dart';
import 'package:get/get.dart';

List<PhaseModel> phases = [
  PhaseModel(
    startObjects: () {
      return [
        FloorModel(3, 4, 6),
        FloorModel(1, 9, 7),
        FloorModel(10, 9, 7),
        FloorModel(6, 14, 5),
        FloorModel(1, 14, 3),
        FloorModel(13, 14, 2),
        FloorModel(9, 19, 10),
        FloorModel(1, 19, 6),
        FloorModel(4, 24, 4),
        FloorModel(10, 24, 3),
        FloorModel(4, 29, 9),
        StairModel(3, 4, 5),
        StairModel(13, 9, 5),
        StairModel(2, 14, 5),
        StairModel(5, 19, 5),
        StairModel(11, 19, 5),
        StairModel(7, 24, 5),
        PhysicObject(
          startCell: CellGrid(column: 0, row: 1),
          finalCell: CellGrid(column: 1, row: 28),
          contacts: [ContactType.Barrier],
          contactOffset: HitBoxOffset(
            right: (Get.find<GridController>().unitSize.width / 3),
          ),
          onContacts: [(type) => null],
        ),
        PhysicObject(
          startCell: CellGrid(column: 16, row: 1),
          finalCell: CellGrid(column: 17, row: 28),
          contacts: [ContactType.Barrier],
          contactOffset:
              HitBoxOffset(left: Get.find<GridController>().unitSize.width / 3),
          onContacts: [(type) => null],
        ),
      ];
    },
    playerStartPosition: CellGrid(column: 4, row: 26),
    rightBarrelSpawn: CellGrid(column: 6, row: 2),
    leftBarrelSpawn: CellGrid(column: 3, row: 2),
    barrelSpeed: 4,
    kongPosition: CellGrid(column: 5, row: 1),
    winSpot: CellGrid(column: 4, row: 2),
  ),
];
