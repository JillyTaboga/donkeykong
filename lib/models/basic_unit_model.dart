import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicUnit extends StatelessWidget {
  const BasicUnit({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GridController>(builder: (controller) {
      return Container(
        width: controller.unitSize.width,
        height: controller.unitSize.height,
        child: child,
      );
    });
  }
}

class BasicGridUnit extends StatelessWidget {
  const BasicGridUnit({
    Key key,
    @required this.cell,
  }) : super(key: key);

  final CellGrid cell;

  @override
  Widget build(BuildContext context) {
    return BasicUnit(
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
            width: 0.1,
          ),
          color: Colors.black12.withOpacity(0.05),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          cell.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 6,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}

class BasicGrid extends StatelessWidget {
  const BasicGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GridController>(builder: (gridController) {
      return LayoutBuilder(
        builder: (context, constraints) {
          gridController.unitSizeSetter(
            Size(
              constraints.maxWidth,
              constraints.maxHeight,
            ),
          );
          return Wrap(
            children: gridController.cells
                .map((e) => BasicGridUnit(
                      cell: e,
                    ))
                .toList(),
          );
        },
      );
    });
  }
}
