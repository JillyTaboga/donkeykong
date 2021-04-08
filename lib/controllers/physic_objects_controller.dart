import 'package:donkeykong/controllers/game_state_controller.dart';
import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/models/barrel_model.dart';
import 'package:donkeykong/models/kong_model.dart';
import 'package:donkeykong/models/object_model.dart';
import 'package:donkeykong/models/phase_model.dart';
import 'package:donkeykong/repositories/phases.dart';
import 'package:donkeykong/ui/widgets/basic_physic_object.dart';
import 'package:get/get.dart';

class PhysicObjectsController extends GetxController {
  @override
  onInit() {
    currentPhase = phases.first;
    super.onInit();
  }

  onClose() {
    _timerWorker.dispose();
    super.onClose();
  }

  ///Fase do jogo caso queira criar mais fases
  PhaseModel currentPhase;

  ///Objetos que são atualizados e calculados todo frame
  RxList<BasicPhysicObject> objects = <BasicPhysicObject>[].obs;

  ///Timer para criar barris
  var _timer = 0.obs;

  ///Listener do timer
  Worker _timerWorker;

  ///Id do objeto do player para facilitar a utilização do controle do jogador
  String playerId;

  ///Define uma função com base no timer, no caso a criação dos barris a cada 30 frames
  setListener() {
    _timer = 0.obs;
    _timerWorker = ever(_timer, (_) {
      if (_timer.value == 1) {
        addObject(BarrelModel.random(
          leftSpawn: currentPhase.leftBarrelSpawn,
          rightSpawn: currentPhase.rightBarrelSpawn,
          velocity: currentPhase.barrelSpeed,
        ));
      }
      if (_timer.value > 30) {
        _timer -= 30;
      }
    });
  }

  ///função para adicionar um objeto em cena
  ///O controlador é criado aqui pq pode ser usado antes da criação do widget na tela
  addObject(PhysicObject object) {
    Get.lazyPut(() => ObjectController(object: object), tag: object.uuid);
    objects.add(
      BasicPhysicObject(
        objectId: object.uuid,
        isPlayer: object.isPlayer,
      ),
    );
  }

  ///Função para remover um objeto em cena
  ///Não precisa do dispose do controller aqui pq é feito quando a tela morre
  removeObject(PhysicObject object) {
    objects.removeWhere((element) => element.objectId == object.uuid);
  }

  ///Função que é chamada no update da Engine que realiza a atualização de todos os objetos em cena
  updateAllObject() {
    if (_timerWorker == null) setListener();
    _timer.value++;
    if (objects.isNotEmpty) {
      for (var object in [...objects]) {
        final controller = Get.find<ObjectController>(tag: object.objectId);
        if (!controller.inert || controller.object.applyGravity) {
          controller.updateObject();
          clearObjectsOutScreen(object);
        }
      }
    }
  }

  ///Função que remove os objetos conforme eles saem da tela de jogo
  clearObjectsOutScreen(BasicPhysicObject object) {
    var objectsToRemove = <String>[];
    final controller = Get.find<ObjectController>(tag: object.objectId);
    if (!controller.rect.overlaps(Get.find<GridController>().screenRect)) {
      objectsToRemove.add(object.objectId);
    } else {
      checkContact(controller);
    }
    if (objectsToRemove.isNotEmpty) {
      objects.removeWhere((element) =>
          objectsToRemove.any((element2) => element2 == element.objectId));
    }
  }

  ///Função que verifica os contatos de hitboxes dos objetos em cena
  checkContact(ObjectController object) {
    var contacts = <ContactType>[];
    for (final target in objects) {
      final targetController = Get.find<ObjectController>(tag: target.objectId);
      if (object.rect.overlaps(targetController.rect)) {
        if (target.objectId != object.object.uuid) {
          contacts.addAll(targetController.object.contacts);
        }
      }
    }
    object.contact(contacts, object.position);
  }

  ///Cria os objetos inicias da fase
  createOjects() {
    if (objects.isEmpty) {
      for (final object in currentPhase.startObjects()) {
        addObject(object);
      }
      createPlayer();
      createKong();
      createWinSpot();
    }
  }

  ///Cria o jogador
  //Refatorar para um model
  createPlayer() {
    final player = PhysicObject(
        startCell: currentPhase.playerStartPosition,
        finalCell: CellGrid(
            column: currentPhase.playerStartPosition.column + 1,
            row: currentPhase.playerStartPosition.row + 2),
        isPlayer: true,
        applyGravity: true,
        contacts: [ContactType.Player],
        contactOffset: HitBoxOffset(
          top: -Get.find<GridController>().unitSize.height * 1,
          bottoms: -Get.find<GridController>().unitSize.height * 1,
        ),
        onContacts: [
          (type) {
            if (type == ContactType.Enemy) {
              Get.find<GameStateController>().defeat();
            }
            if (type == ContactType.Button) {
              Get.find<GameStateController>().win();
            }
            return null;
          }
        ]);
    playerId = player.uuid;
    addObject(player);
  }

  ///Cria a decoração do Kong
  createKong() {
    final kong = KongModel(
      startPosition: currentPhase.kongPosition,
    );
    addObject(kong);
  }

  ///Cria a princesa e define que se fizer contato com ela vence
  createWinSpot() {
    addObject(
      PhysicObject(
          startCell: currentPhase.winSpot,
          finalCell: CellGrid(
            column: currentPhase.winSpot.column + 1,
            row: currentPhase.winSpot.row + 2,
          ),
          asset: 'assets/princess.gif',
          decoration: true,
          onContacts: [(type) => null],
          contacts: [ContactType.Button]),
    );
  }

  ///Reseta os objetos
  reset() async {
    if (_timerWorker != null) {
      _timerWorker.dispose();
      _timerWorker = null;
    }
    await Future.delayed(Duration(milliseconds: 50));
    if (objects.isNotEmpty) objects.clear();
    await Future.delayed(Duration(milliseconds: 50));
    createOjects();
  }
}
