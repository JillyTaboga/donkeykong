import 'package:donkeykong/controllers/game_state_controller.dart';
import 'package:donkeykong/controllers/object_controller.dart';
import 'package:donkeykong/controllers/physic_objects_controller.dart';
import 'package:donkeykong/models/basic_unit_model.dart';
import 'package:donkeykong/ui/widgets/hitbox_widget.dart';
import 'package:donkeykong/ui/widgets/joystick_widget.dart';
import 'package:donkeykong/ui/widgets/jump_button.dart';
import 'package:donkeykong/ui/widgets/status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  ///Responsável por fazer o update da tela do jogo e a posição dos objetos a cada frame
  Ticker ticker;
  PhysicObjectsController controller;

  ///Se verdadeiro exibe os hitboxes dos objectos para facilitar a configuração
  bool showHitBoxes = false;

  @override
  void initState() {
    controller = Get.find<PhysicObjectsController>();

    ///A cada ticker ativa a engine do jogo
    ticker = Ticker((period) {
      Get.find<GameStateController>().engineUpdate();
    });
    ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    ticker.stop();
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameStateController statusController = Get.find<GameStateController>();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.red),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Obx(() => Text(
                statusController.time.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              )),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: GetBuilder<GameStateController>(
          builder: (stateController) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: 1 / 2,
                            child: Obx(() {
                              return Stack(
                                children: [
                                  const BasicGrid(),
                                  if (controller.objects.length > 1)
                                    ...controller.objects,
                                  if (showHitBoxes)
                                    ...controller.objects
                                        .map((element) =>
                                            HitBox(objectId: element.objectId))
                                        .toList(),
                                ],
                              );
                            })),
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  minimumSize: Size(0, 0),
                                  padding: EdgeInsets.all(10),
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  Get.find<GameStateController>().reset();
                                },
                                child: Icon(Icons.refresh),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  minimumSize: Size(0, 0),
                                  padding: EdgeInsets.all(10),
                                  primary: Colors.blue,
                                ),
                                onPressed: () {
                                  Get.find<GameStateController>().pause();
                                },
                                child: Icon(Icons.remove),
                              ),
                            ],
                          )),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
                StickWidget(
                  onMove: (offset) {
                    if (Get.find<PhysicObjectsController>()
                        .objects
                        .any((element) => element.isPlayer)) {
                      Get.find<ObjectController>(
                              tag: Get.find<PhysicObjectsController>().playerId)
                          .move(offset);
                    }
                  },
                ),
                Positioned(
                  right: 30,
                  bottom: 10,
                  child: JumpButton(
                    onPress: () {
                      if (Get.find<PhysicObjectsController>()
                          .objects
                          .any((element) => element.isPlayer)) {
                        Get.find<ObjectController>(
                                tag: Get.find<PhysicObjectsController>()
                                    .playerId)
                            .action();
                      }
                    },
                  ),
                ),
                if (stateController.currentStatus == GameStatus.Pause)
                  DialogStatus(
                    title: 'Pausado',
                    buttonText: 'Iniciar',
                    onPressButton: () {
                      stateController.pause();
                    },
                  ),
                if (stateController.currentStatus == GameStatus.Defeat)
                  DialogStatus(
                    title: 'Game Over',
                    buttonText: 'Reiniciar',
                    onPressButton: () {
                      stateController.reset();
                    },
                  ),
                if (stateController.currentStatus == GameStatus.Victory)
                  DialogStatus(
                    title: 'Vitória!',
                    buttonText: 'De novo',
                    onPressButton: () {
                      stateController.reset();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
