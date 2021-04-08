import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:flutter/foundation.dart';

class KongModel extends PhysicObject {
  CellGrid startPosition;
  KongModel({
    @required this.startPosition,
  }) : super(
            startCell: startPosition,
            finalCell: CellGrid(
                column: startPosition.column + 3, row: startPosition.row + 3),
            asset: 'assets/kong.gif',
            decoration: true,
            onContacts: [(type) => null],
            contacts: [ContactType.Enemy]);
}
