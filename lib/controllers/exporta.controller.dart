import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/util/auxiliar.dart';
import 'package:capop_new/util/comunica.service.dart';

class ExportaController extends GetxController {
  var retorno = ''.obs;
  var resultado = ''.obs;
  var loading = false.obs;

  ComunicaService _com = new ComunicaService();

  Future<void> postVisitas(BuildContext context) async {
    loading.value = true;

    try {
      var dados;
      Auxiliar.loadEnvio().then((value) async {
        dados = value;
        retorno.value = '';
        var send = jsonEncode(dados);
        var ret = await _com.postVisitas(context, send);
        var cont = 0;
        for (var element in ret){
            cont += await Auxiliar.changeStatus(element);
        }
        resultado.value = cont.toString() + ' Registros enviados.';

      });
    } catch (ex) {
      retorno.value = 'Erro enviando registros:\r\n' + ex.toString();
    }
    loading.value = false;
  }

  verifEnvio(BuildContext context) async {
    loading.value = true;
    Auxiliar.checkEnvio().then((value) {
      this.retorno.value = value;
    });
    loading.value = false;
  }
}
