import 'package:get/get.dart';
import 'package:capop_new/controllers/atividade.controller.dart';

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AtividadeController>(() => AtividadeController());
  }
}
