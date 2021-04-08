import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:donkeykong/models/object_model.dart';

enum PlayerStatus { Idle, Moving, Jumping }

///Controller que é criado para cada objeto em cena
class ObjectController extends GetxController {
  final PhysicObject object;

  ///Posição global do objeto na cena, inicia com a posição inicial setada do modelo
  Offset position;

  ///Objetos em contato com este objeto
  List<ContactType> currentContacts = [];

  ///Velocidades
  //Talvez fique melhor refatorando essa velocidade como eixos e valores +-
  double velocityUp = 0;
  double velocityDown = 0;
  double velocityLeft = 0;
  double velocityRight = 0;

  ObjectController({
    @required this.object,
  });

  @override
  onInit() {
    position = object.position ?? 0;
    velocityDown = object.initialVelocityDown ?? 0;
    velocityUp = object.initialVelocityUp ?? 0;
    velocityLeft = object.initialVelocityLeft ?? 0;
    velocityRight = object.initialVelocityRight ?? 0;
    super.onInit();
  }

  ///Largura em células de um objeto
  int get widhtCels => object.finalCell.column - object.startCell.column;
  int get heightCels => object.finalCell.row - object.startCell.row;

  ///Define se o asset tem que ser girado para a esquerda
  bool get right => velocityLeft == 0;

  ///Define o hitbox
  Rect get rect => Rect.fromLTWH(
        position.dx - (object.contactOffset?.left ?? 0),
        position.dy - (object.contactOffset?.top ?? 0),
        object.width + (object.contactOffset?.right ?? 0),
        object.height + (object.contactOffset?.bottoms ?? 0),
      );

  ///Define se o objeto está parado
  bool get inert =>
      velocityDown + velocityLeft + velocityRight + velocityUp == 0;

  ///Função que é invocada todo frame para atualizar a posição ou dados do objeto
  updateObject() {
    if (object.isPlayer) {}
    if (!inert || object.applyGravity) {
      position = Offset(position.dx + velocityRight - velocityLeft,
          position.dy + velocityDown - velocityUp + gravity);
      if (object.isPlayer &&
          (position.dx < Get.find<GridController>().leftBound)) {
        position =
            Offset(Get.find<GridController>().leftBound + 1, position.dy);
      }
      if (object.isPlayer &&
          (position.dx > Get.find<GridController>().rightBound)) {
        position =
            Offset(Get.find<GridController>().rightBound - 1, position.dy);
      }
      update();
    }
  }

  ///Calcula a gravidade envolvida
  double get gravity {
    if (!object.applyGravity) return 0;
    if (currentContacts.contains(ContactType.Floor)) return 0;
    if (object.isPlayer && currentContacts.contains(ContactType.Ladder))
      return 0;
    return Get.find<GridController>().unitSize.height / 2;
  }

  ///Define um status para a animação do jogador
  //Talvez refatorar para um Outro controller estendendo esse
  PlayerStatus get playerStatus {
    if ((velocityLeft > 0 || velocityRight > 0) &&
        currentContacts.any((element) =>
            [ContactType.Floor, ContactType.Ladder].contains(element))) {
      return PlayerStatus.Moving;
    }
    if (velocityUp > 0 || velocityDown > 0) {
      return PlayerStatus.Jumping;
    }
    return PlayerStatus.Idle;
  }

  ///Função para atualizar as velocidades
  updateVelocity(Speeds speed) {
    if (speed == null) return;
    if (speed.velocityLeft == 99 && speed.velocityRight == 99) {
      if (this.velocityLeft > 0) {
        this.velocityRight = this.velocityLeft;
        this.velocityLeft = 0;
      } else if (this.velocityRight > 0) {
        this.velocityLeft = this.velocityRight;
        this.velocityRight = 0;
      }
      return;
    }
    this.velocityDown = speed.velocityDown ?? this.velocityDown;
    this.velocityUp = speed.velocityUp ?? this.velocityUp;
    this.velocityLeft = speed.velocityLeft ?? this.velocityLeft;
    this.velocityRight = speed.velocityRight ?? this.velocityRight;
  }

  ///Função que é chamada quando ocorre um contato
  contact(List<ContactType> contacts, Offset contactPosition) {
    if (object.onContacts != null && object.onContacts.isNotEmpty) {
      currentContacts.clear();
      currentContacts.addAll(contacts);
      position = contactPosition;
      for (final action in object.onContacts) {
        for (final contact in currentContacts) {
          updateVelocity(action(contact));
        }
      }
      update();
    }
  }

  ///Função do botão do jogador
  action() async {
    if (currentContacts.contains(ContactType.Ladder)) {
      velocityUp = Get.find<GridController>().unitSize.height / 2;
      await Future.delayed(Duration(milliseconds: 100));
      velocityUp = 0;
    } else if (currentContacts.contains(ContactType.Floor)) {
      velocityUp = Get.find<GridController>().unitSize.height;
      await Future.delayed(Duration(milliseconds: 300));
      velocityUp = 0;
    }
  }

  ///Função de mexer o joystick
  move(Offset offset) async {
    var move = offset.dx;
    Speeds speed;
    if (move == 0) {
      speed = Speeds.move0();
    } else if (move > 0 && move <= 20) {
      speed = Speeds.right1();
    } else if (move > 20 && move <= 40) {
      speed = Speeds.right2();
    } else if (move > 40 && move <= 60) {
      speed = Speeds.right3();
    } else if (move < 0 && move >= -20) {
      speed = Speeds.left1();
    } else if (move < -20 && move >= -40) {
      speed = Speeds.left2();
    } else if (move < -40 && move >= -60) {
      speed = Speeds.left3();
    }
    updateVelocity(speed);
  }

  @override
  void onClose() {
    velocityDown = 0;
    velocityLeft = 0;
    velocityRight = 0;
    velocityUp = 0;
    super.onClose();
  }
}

class Speeds {
  double velocityUp;
  double velocityDown;
  double velocityLeft;
  double velocityRight;
  Speeds({
    this.velocityUp,
    this.velocityDown,
    this.velocityLeft,
    this.velocityRight,
  });

  Speeds.right1() {
    velocityLeft = 0;
    velocityRight = Get.find<GridController>().unitSize.width / 5;
  }
  Speeds.right2() {
    velocityLeft = 0;
    velocityRight = Get.find<GridController>().unitSize.width / 4;
  }
  Speeds.right3() {
    velocityLeft = 0;
    velocityRight = Get.find<GridController>().unitSize.width / 3;
  }
  Speeds.left1() {
    velocityRight = 0;
    velocityLeft = Get.find<GridController>().unitSize.width / 5;
  }
  Speeds.left2() {
    velocityRight = 0;
    velocityLeft = Get.find<GridController>().unitSize.width / 4;
  }
  Speeds.left3() {
    velocityRight = 0;
    velocityLeft = Get.find<GridController>().unitSize.width / 3;
  }
  Speeds.move0() {
    velocityLeft = 0;
    velocityRight = 0;
  }

  Speeds.reverse() {
    velocityLeft = 99;
    velocityRight = 99;
  }
}

class HitBoxOffset {
  final double top;
  final double bottoms;
  final double left;
  final double right;
  HitBoxOffset({
    this.top = 0,
    this.bottoms = 0,
    this.left = 0,
    this.right = 0,
  });

  const HitBoxOffset.zero(
      {this.bottoms = 0, this.left = 0, this.right = 0, this.top = 0});
}
