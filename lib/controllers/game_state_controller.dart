import 'package:donkeykong/controllers/physic_objects_controller.dart';
import 'package:get/get.dart';

enum GameStatus { Playing, Pause, Victory, Defeat }

class GameStateController extends GetxController {
  ///Define a dialog da tela inicial e se deve atualizar os objetos da cena
  GameStatus currentStatus = GameStatus.Pause;

  ///Tempo máximo para passar a fase
  Rx<int> time = 500.obs;

  ///reseta os objetos e o tempo
  _start() {
    Get.find<PhysicObjectsController>().reset();
    currentStatus = GameStatus.Playing;
    time.value = 500;
    time.refresh();
    update();
  }

  ///Reseta tudo e pausa o jogo
  reset() {
    _start();
    pause();
  }

  ///Pausa e despausa
  pause() {
    if (currentStatus == GameStatus.Pause) {
      currentStatus = GameStatus.Playing;
    } else {
      currentStatus = GameStatus.Pause;
    }
    update();
  }

  ///Exibe a vitória
  win() {
    currentStatus = GameStatus.Victory;
    update();
  }

  ///Exibe a derrota
  defeat() {
    currentStatus = GameStatus.Defeat;
    update();
  }

  ///Ativa a cada tick da MainScreen e decide se precisa atualizar os objetos ou mostrar uma derrota
  engineUpdate() {
    if (currentStatus == GameStatus.Playing) {
      Get.find<PhysicObjectsController>().updateAllObject();
      time--;
      if (time <= 0) {
        defeat();
      }
      if (!Get.find<PhysicObjectsController>()
          .objects
          .any((element) => element.isPlayer)) {
        defeat();
      }
    }
  }
}
