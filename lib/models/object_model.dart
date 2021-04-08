import 'package:donkeykong/controllers/object_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:uuid/uuid.dart';

enum ContactType { Floor, Barrier, Ladder, Player, Button, Enemy }

class ObjectModel {
  ///Top left cell
  CellGrid startCell;

  ///Bottom right cell
  CellGrid finalCell;

  List<ContactType> contacts;

  String asset;
  ObjectModel({
    @required this.startCell,
    @required this.finalCell,
    @required this.contacts,
    this.asset,
  });

  Offset get position => startCell.position;

  Rect get rect => Rect.fromPoints(
        startCell.position,
        finalCell.position,
      );

  double get height {
    return finalCell.position.dy - startCell.position.dy;
  }

  double get width {
    return finalCell.position.dx - startCell.position.dx;
  }

  List<CellGrid> get occupiedCells {
    var cells = <CellGrid>[];
    cells.add(startCell);
    cells.add(finalCell);
    final width = finalCell.column - startCell.column;
    final heigth = finalCell.row = startCell.row;
    for (var r = 1; r <= heigth; r++) {
      for (var c = 1; c <= width; c++) {
        cells.add(CellGrid(column: c, row: r));
      }
    }
    return cells;
  }
}

typedef Speeds OnContact(ContactType type);

typedef ChangeVelocitys({
  double velocityUp,
  double velocityDown,
  double velocityLeft,
  double velocityRight,
});

class PhysicObject extends ObjectModel {
  PhysicObject({
    @required CellGrid startCell,
    @required CellGrid finalCell,
    @required List<ContactType> contacts,
    @required this.onContacts,
    String asset,
    this.initialVelocityDown,
    this.initialVelocityLeft,
    this.initialVelocityRight,
    this.initialVelocityUp,
    this.position,
    this.applyGravity = false,
    this.contactOffset,
    this.isPlayer = false,
    this.decoration = false,
  }) : super(
          finalCell: finalCell,
          startCell: startCell,
          contacts: contacts,
          asset: asset,
        ) {
    uuid = Uuid().v4();
    if (position == null) position = super.position;
  }

  String uuid;
  double initialVelocityUp;
  double initialVelocityDown;
  double initialVelocityLeft;
  double initialVelocityRight;
  Offset position;
  bool applyGravity;
  HitBoxOffset contactOffset;
  List<OnContact> onContacts;
  bool isPlayer;
  bool decoration;

  @override
  Rect get rect => Rect.fromLTWH(position.dx, position.dy, width, height);
}
