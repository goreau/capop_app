import 'package:flutter/material.dart';
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
    final db = DbHelper.instance;
    Get.back(closeOverlays: true);
    int res = await db.delete(id, tab);
    Get.toNamed('/consulta');
  }
}
