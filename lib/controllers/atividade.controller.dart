import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/util/auxiliar.dart';
import 'package:capop_new/util/db_helper.dart';
import 'package:capop_new/util/routes.dart';
import 'package:capop_new/util/storage.dart';
import 'package:capop_new/models/atividade.dart';

class AtividadeController extends GetxController {
  var editId = 0;

  ScrollController scrollController = ScrollController();

  int lstMunTipo = 1;

  var lstServidor = <DropdownMenuItem<String>>[].obs;
  var lstMun = <DropdownMenuItem<String>>[].obs;
  var lstPerda = <DropdownMenuItem<String>>[].obs;
  var lstPrograma = <DropdownMenuItem<String>>[].obs;
  var lstAtividade = <DropdownMenuItem<String>>[].obs;
  var lstModalidade = <DropdownMenuItem<String>>[].obs;
  var idServidor = '0'.obs;
  var idMun = '0'.obs;
  var idPerda = '999'.obs;
  var idPrograma = '0'.obs;
  var idAtividade = '0'.obs;
  var idModalidade = '0'.obs;

  var loadingServidor = false.obs;
  var loadingMun = false.obs;
  var loadingPerda = false.obs;
  var loadingPrograma = false.obs;
  var loadingAtividade = false.obs;
  var loadingModalidade = false.obs;
  var ordem = 1;

  var clearAll = false.obs;

  var dtCadastro = DateTime.now().toString().substring(0, 10).obs;

  var idPagamento = 1.obs;
  var producao = ''.obs;
  var valor = ''.obs;

  var dateController = TextEditingController().obs;

  final prodController = TextEditingController();
  final valorController = TextEditingController();
  var atividade = Atividade().obs;

  final dbHelper = DbHelper.instance;

  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  initMaster(int id) async {
    editId = id;
    lstMunTipo = 0;
    final db = DbHelper.instance;

    var json = await db.queryMaster(id);

    updateMun(json['id_municipio'].toString());
    updateServidor(json['id_servidor'].toString());
    updateModalidade(json['id_modalidade'].toString());
    updateAtiv(json['id_aux_atividade'].toString());
    updatePrograma(json['id_programa'].toString());
    updatePerda(json['id_perda'].toString());

    var dt = json['dt_cadastro'];


    getCurrentDate(dt);
   // dtCadastro.value = formattedDate;
  //  dateController.value.text =  dtCadastro.value;//json['dt_captura'];
    valorController.text = json['valor'].toString();
    prodController.text = json['producao'].toString();
  }

  void setPagamento(int value) {
    idPagamento.value = value;
  }

  loadPreferences() async {
    try {
      String serv = await Storage.recupera('servidor');
      updateServidor(serv);

    } catch (e) {
      print(e.toString());
    }
  }

  doRegister(BuildContext context) async {
    String val = valorController.value.text;
    val.replaceAll(',', '.');
    this.atividade.value.valor = val == '' ? '0.0' : val;
    this.atividade.value.producao = prodController.value.text == '' ? '0' : prodController.value.text;

    var dt = dateController.value.text;
    if (dt == ''){
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('A data da atividade é obrigatória.'),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }
    var formattedDate = dt.split('/').reversed.join('-');

    this.atividade.value.dtCadastro = formattedDate;

    try {
      Storage.insere('servidor', this.atividade.value.idServidor.toString());
    } catch (ex) {}

    Map<String, dynamic> row = new Map();
    row['id_municipio'] = this.atividade.value.idMunicipio;
    row['dt_cadastro'] = this.atividade.value.dtCadastro;
    row['id_pagamento'] = this.atividade.value.idPagamento;
    row['valor'] = this.atividade.value.valor;
    row['producao'] = this.atividade.value.producao;
    row['id_servidor'] = this.atividade.value.idServidor;
    row['id_programa'] = this.atividade.value.idPrograma;
    row['id_aux_atividade'] = this.atividade.value.idAtividade;
    row['id_modalidade'] = this.atividade.value.idModalidade;
    row['id_perda'] = this.atividade.value.idPerda;
    row['status'] = 0;

    if (editId == 0) {
      await dbHelper.insert(row, 'atividade');

      doClear();
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Registro inserido.'),
          backgroundColor: Colors.green[900],
        ),
      );
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    } else {
      await dbHelper.update(row, 'atividade', editId);
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Registro atualizado.'),
          backgroundColor: Colors.green[900],
        ),
      );
      Get.toNamed(Routes.CONSULTA);
    }

  }

  doClear() {
    var dt = dateController.value.text;
    var formattedDate = dt.split('/').reversed.join('-');

    DateTime today = DateTime.parse(formattedDate);
    DateTime tomorrow = today.add(Duration(days: 1));
    String fdt = tomorrow.toString().substring(0,10);
    dt =  fdt.split('-').reversed.join('/');

    getCurrentDate(dt);

    this.atividade.value.dtCadastro = fdt;
  }

  getCurrentDate(String date) async {
    //var dateParse = DateTime.parse(date);
    var formattedDate = date.split('-').reversed.join('/');
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    this.dateController.value.text = formattedDate;
    this.dtCadastro.value = date;
  }

  loadBase(){
    this.loadMun();
    this.loadServ();
    this.loadPrograma();
    this.loadAtividade(0);
    this.loadModalidade();
    this.loadPerda();

  }

  loadMun() {
    this.loadingMun.value = true;
    String filt = lstMunTipo == 1 ? 'principal = 1' : '';
    Auxiliar.loadData('municipio', filt).then((value) {
      this.lstMun.value = value;
      this.loadingMun.value = false;
    });
  }

  refreshListMun(){
    lstMunTipo = lstMunTipo == 0 ? 1 : 0;
    atividade.value.idMunicipio = 0;
    idMun.value = '0';
    loadMun();
  }

  loadServ() {
    this.loadingServidor.value = true;
    Auxiliar.loadData('servidor', '').then((value) {
      this.lstServidor.value = value;
      this.loadingServidor.value = false;
    });
  }

  loadPrograma() {
    this.loadingPrograma.value = true;
    Auxiliar.loadData('programa', '' ).then((value) {
      this.lstPrograma.value = value;
      this.loadingPrograma.value = false;
    });
  }

  loadAtividade(int prog) {
    this.loadingAtividade.value = true;
    Auxiliar.loadData('aux_atividade', 'id_programa = 1' ).then((value) {
      this.lstAtividade.value = value;
      this.loadingAtividade.value = false;
    });
  }

  loadModalidade() {
    this.loadingModalidade.value = true;
    Auxiliar.loadData('modalidade', '').then((value) {
      this.lstModalidade.value = value;
      this.loadingModalidade.value = false;
    });
  }

  loadPerda() {
    this.loadingPerda.value = true;
    Auxiliar.loadData('perda', '').then((value) {
      this.lstPerda.value = value;
      this.loadingPerda.value = false;
    });
  }

   Future<void> updatePrograma(value) async {
    if (value == 'null') return;

    this.loadingAtividade.value = true;
    this.atividade.value.idPrograma = int.parse(value);
    this.idPrograma.value = value;
    Auxiliar.loadData('aux_atividade', ' id_programa= ' + value).then((value) {
      this.lstAtividade.value = value;
      this.loadingAtividade.value = false;
    });
  }

  updateMun(value) {
    this.atividade.value.idMunicipio =  int.parse(value);
    this.idMun.value = value;
  }

  updateAtiv(value) {
    this.atividade.value.idAtividade = int.parse(value);
    this.idAtividade.value = value;
  }

  updateModalidade(value) {
    this.atividade.value.idModalidade = int.parse(value);
    this.idModalidade.value = value;
  }

  updatePerda(value) async {
    this.atividade.value.idPerda = int.parse(value);
    this.idPerda.value = value;
    if (value != '999'){
      updateMun('999');
      await updatePrograma('999');
      updateAtiv('999');

      updateModalidade('999');
      updatePagamento(0);
      valorController.text = '0.0';
      prodController.text = '0';
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  updateServidor(value) {
    this.atividade.value.idServidor = int.parse(value);
    this.idServidor.value = value;
  }

  updatePagamento(value) {
    value = value == null ? 1 : value;
    this.atividade.value.idPagamento = value;
    this.idPagamento.value = value;
  }

  limpaAtividades(BuildContext context) async {
    final db = DbHelper.instance;
    var tipo = clearAll.value ? 1 : 2;
    var qt = 0;
    db.limpaAtividade(tipo).then((value) {
      qt = value;
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(qt.toString() + ' registros excluidos.'),
          backgroundColor: Colors.green[900],
        ),
      );
    });
  }
}
