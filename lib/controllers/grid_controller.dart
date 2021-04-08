import 'package:donkeykong/controllers/physic_objects_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

///Determina o tamanho da tela para criar um sistema de grid de modo que
///em diferentes tipos de tela sejam respeitados os mesmos tamanhos proporcionais,
///velocidades e posições
class GridController extends GetxController {
  ///Quantidade de colunas
  final int kColumns = 15;

  ///Quantidade de linhas
  final int kRows = 30;

  ///Largura da célua básica
  double _unitWidth = 1;

  ///Altura da célua básica
  double _unitHeigth = 1;

  ///Devolve uma lista de células, no modo debug utilizo para facilitar montar
  ///o layout das fases
  List<CellGrid> get cells {
    var cells = <CellGrid>[];
    for (var r = 1; r <= kRows; r++) {
      for (var c = 1; c <= kColumns; c++) {
        cells.add(CellGrid(column: c, row: r));
      }
    }
    return cells;
  }

  ///Define os finais da tela para fins de impedir o jogador de cair
  double get leftBound =>
      cells.firstWhere((element) => element.column == 1).position.dx;
  double get rightBound =>
      cells.firstWhere((element) => element.column == kColumns).position.dx;

  ///Determina o tamanho da tela para remover objetos que saiam da tela
  Rect get screenRect =>
      Rect.fromPoints(cells.first.position, cells.last.position);

  unitSizeSetter(Size maxSize) {
    if (_unitHeigth != (maxSize.height / kRows) ||
        _unitWidth != (maxSize.width / kColumns)) {
      _unitHeigth = maxSize.height / kRows;
      _unitWidth = maxSize.width / kColumns;
      update();
      Get.find<PhysicObjectsController>().reset();
    }
  }

  ///Expõe o tamanho de uma célula básica
  Size get unitSize => Size(_unitWidth, _unitHeigth);
}

///Classe modelo de uma célula básica do grid
class CellGrid {
  int column;
  int row;
  CellGrid({
    @required this.column,
    @required this.row,
  });
  String get name => column.toString() + ':' + row.toString();
  Offset get position {
    final controller = Get.find<GridController>();
    return Offset((column - 1) * controller._unitWidth,
        (row - 1) * controller._unitHeigth);
  }
}
