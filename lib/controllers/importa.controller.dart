import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/models/territorio.dart';
import 'package:capop_new/util/comunica.service.dart';
import 'package:capop_new/util/territorios.dart';
import 'package:capop_new/util/storage.dart';

class ImportaController extends GetxController {
  var retorno = ''.obs;
  var loading = false.obs;
  var clearAll = false.obs;

  late List<Territorio> territorioList;

  ComunicaService _com = new ComunicaService();

  @override
  void onInit(){
    super.onInit();
    territorioList = territorio;
  }

  Future<void> loadCadastro(BuildContext context, int gve) async {
    loading.value = true;
    
    try {
        Storage.insere('id_territorio', gve);
        retorno.value = await _com.getCadastro(context, gve);
    } catch (Exception) {
      retorno.value = 'Erro criando lista:' + Exception.toString();
    }
    loading.value = false;
  }
}
