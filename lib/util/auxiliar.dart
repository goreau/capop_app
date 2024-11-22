import 'dart:convert';

import 'package:flutter/material.dart';

import 'db_helper.dart';

class Auxiliar {
  static Future<List<DropdownMenuItem<String>>> loadData(
      String tabela, String filtro) async {
    final db = DbHelper.instance;
    List<DropdownMenuItem<String>> list = [];
    List<Map> ret;
    list.add(DropdownMenuItem<String>(
      child: Text(
        '--Selecione--',
        style: new TextStyle(
          fontSize: 12.0,
        ),
      ),
      value: '0',
    ));
    ret = await db.qryCombo(tabela, filtro);

    ret.map((map) {
      return getDropDownWidget(map);
    }).forEach((element) {
      list.add(element);
    });
    return list;
  }

  static Future<int> getProp(int mun) async {
    final db = DbHelper.instance;

    var prop = await db.getProp(mun);

    return prop;
  }

  static Future<String> checkEnvio() async {
    final db = DbHelper.instance;

    var ret = await db.qryCountEnvio();

    String list = '';
    if (ret > 0){
      list = 'Atividades de Campo: ' + ret.toString() + ' registros\n\n';
    } else {
      list = 'Nenhum registro  sincronizar';
    }

    return list;
  }

  static Future<List<dynamic>> loadEnvio() async {
    final db = DbHelper.instance;

    var ret = await db.qryEnvio();
    var dados = [];
    var details = [];


    for (var row in ret){
      var map = {};
      row.forEach((key, value) {
        if (key == 'id_captura'){
          key = 'id_master';
        }
        map[key] = value;
      });
      details = await db.qryEnvioDet(row['id_captura']);
      map['detail'] = details;
      map['quadrante'] = map['quadrante'] == '' ? 0 : map['quadrante'];
      dados.add(map);
    }
    /*Future.forEach(ret, (row) async {
      var map = {};
      row.forEach((key, value) => map[key] = value);
      details = await db.qryEnvioDet(row['id_captura']);
      map['detail'] = details;
      dados.add(map);
    });*/
    var send = jsonEncode(dados);

    return dados;
  }

  static Future<int> changeStatus(reg) async {
    final db = DbHelper.instance;
    var cont = 0;

    //regs.forEach((element) {
     await db.updateStatus(reg).then((value) => cont += value);
    // });

    return cont;
  }

  static DropdownMenuItem<String> getDropDownWidget(Map<dynamic, dynamic> map) {
    return DropdownMenuItem<String>(
      child: Text(
        map['nome'],
        style: new TextStyle(
          fontSize: 12.0,
        ),
      ),
      value: map['id'].toString(),
    );
  }
}
