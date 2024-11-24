import 'package:get/get.dart';
import 'package:capop_new/models/atividade.dart';
import 'package:capop_new/util/db_helper.dart';

class ConsultaController extends GetxController {
  var loaded = false.obs;
  List<LstMaster> itens = [];

  ConsultaController() {
    inicio();
  }

  Future<void> inicio() async {
    await loadItens();
  }

  Future<void> loadItens() async {
    try {
      final db = DbHelper.instance;

      itens = await db.consultaAtividadesMaster();
      loaded.value = true;
    } catch (ex) {
      print('Erro criando lista' + ex.toString());
    }
  }

  excluiVisita(int id, String tab) async {
    loaded.value = false;

    final db = DbHelper.instance;
    int res = await db.delete(id, tab);

    if (res>0) {
      final int idx = itens.indexWhere((row) => row.id == id);
      itens.removeAt(idx);

      loaded.value = true;
    }

  }
}
