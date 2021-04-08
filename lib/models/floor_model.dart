import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:get/get.dart';

class FloorModel extends PhysicObject {
  int startColumn;
  int startRow;
  int widthInCells;
  FloorModel(
    this.startColumn,
    this.startRow,
    this.widthInCells,
  ) : super(
          startCell: CellGrid(column: startColumn, row: startRow),
          finalCell:
              CellGrid(column: startColumn + widthInCells, row: startRow + 1),
          contactOffset: HitBoxOffset(
            bottoms: -(Get.find<GridController>().unitSize.height / 2),
            top: (Get.find<GridController>().unitSize.height / 2.5),
            left: 0,
            right: 0,
          ),
          asset: 'assets/floor.png',
          contacts: [
            ContactType.Floor,
          ],
          isPlayer: false,
          onContacts: [(type) => null],
        );
}
