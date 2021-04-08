import 'package:donkeykong/controllers/game_state_controller.dart';
import 'package:donkeykong/controllers/grid_controller.dart';
import 'package:donkeykong/controllers/physic_objects_controller.dart';
import 'package:get/get.dart';

///Controller que são alocados no inicio do App
class InitialBidings extends Bindings {
  @override
  void dependencies() {
    Get.put(GameStateController());
    Get.put(GridController());
    Get.put(PhysicObjectsController());
  }
}
