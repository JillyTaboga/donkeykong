import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:get/get.dart';

class StairModel extends PhysicObject {
  int startColumn;
  int startRow;
  int heightInCells;
  StairModel(
    this.startColumn,
    this.startRow,
    this.heightInCells,
  ) : super(
          startCell: CellGrid(column: startColumn, row: startRow),
          finalCell:
              CellGrid(column: startColumn + 1, row: startRow + heightInCells),
          contactOffset: HitBoxOffset(
              bottoms: 0,
              top: -Get.find<GridController>().unitSize.height / 2,
              left: 0,
              right: 0),
          asset: 'assets/ladder.png',
          contacts: [
            ContactType.Ladder,
          ],
          isPlayer: false,
          onContacts: [(type) => null],
        );
}
