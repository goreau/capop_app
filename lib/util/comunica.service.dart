import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'db_helper.dart';

class ComunicaService {
  final dbHelper = DbHelper.instance;

  List<String> entidades = [
    "municipio",
    "programa",
    "aux_atividade",
    "modalidade",
    "perda",
    "servidor"
  ];

  Future<List<dynamic>> postVisitas(
      BuildContext context, String dados) async {
    String _url = '';

    //print(dados);
    _url = 'http://10.8.150.23:4000/mobExporta'; //'''http://vigentapi.saude.sp.gov.br/mobExporta';
    var values = {'data': dados};
    final response = await http.post(Uri.parse(_url), body: values);
    var data = [];
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res['status'] == 'ok'){
        data = res['result'];
      }
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return data;
  }

  Future<int> postOtherVisitas(
      BuildContext context, Map<dynamic, dynamic> row) async {
    final db = DbHelper.instance;
    String _url = '';

    _url = 'http://vigentapi.saude.sp.gov.br/mobExporta';
    var cont = 0;


    String _row = jsonEncode(row);

    var request = http.MultipartRequest('POST', Uri.parse(_url));
    request.fields['dados'] = _row;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var data = jsonDecode(responseString);
      db.updateStatus(data[0]).then((value) {
        cont += value;
        return Future.value(cont);
      });
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return 0;
  }

  Future<String> getSistema(BuildContext context) async {
    String _url = '';
    String resumo = 'Registros recebidos:\n';

    _url = 'http://vigentapi.saude.sp.gov.br/mobAuxiliares';

    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dados = data['dados'];

      await dbHelper.limpa("auxiliares");
      int ct = 0;
      for (var linha in dados) {
          Map<String, dynamic> row = new Map();

          row['id_auxiliares'] = linha['id'];
          row['tipo'] = linha['tipo'];
          row['codigo'] = linha['codigo'].toString().trim();
          row['descricao'] = linha['descricao'].toString().trim();

          await dbHelper.insert(row, "auxiliares");
          ct++;
      }
      resumo += ct > 0 ? 'Dados do sistema: $ct registros\n' : '';

    }
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Dados recebidos.'),
        backgroundColor: Colors.green[900],
      ),
    );
    return resumo;
  }

  Future<String> getCadastro(BuildContext context, int gve) async {
    String _url = '';
    String resumo = 'Registros recebidos:\n';

    _url = 'http://10.8.150.23:4005/mobCadastro/${gve}';


    final response = await http.get(Uri.parse(_url));



    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final dados = data['dados'];
      var obj = null;

      for (var linha in entidades) {
        for (var idx in dados) {
          if (idx.keys.elementAt(0) == linha) {
            obj = idx.values.elementAt(0);
            continue;
          }
        }
        if (obj == null) {
          continue;
        }
        await dbHelper.limpa(linha);
        Map<String, dynamic> row = new Map();
        int ct = 0;
        if (linha == 'programa') {
          ct = 0;
          for (var campo in obj) {
            row['id_programa'] = campo['id'];
            row['descricao'] = campo['descricao'].toString().trim();
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Programa: $ct registros\n' : '';
        } else if (linha == 'municipio') {
          ct = 0;
          for (var campo in obj) {
            row['id_municipio'] = campo['id'];
            row['nome'] = campo['nome'];
            row['codigo'] = campo['codigo'].toString().trim();
            row['id_regional'] = campo['id_regional'];
            row['id_regiao'] = campo['id_regiao'];
            row['principal'] = campo['principal'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Municipio: $ct registros\n' : '';
        } else if (linha == 'aux_atividade') {
          ct = 0;
          for (var campo in obj) {
            row['id_aux_atividade'] = campo['id'];
            row['descricao'] = campo['descricao'].toString().trim();
            row['codigo'] = campo['codigo'];
            row['ordem'] = campo['ordem'];
            row['id_programa'] = campo['id_programa'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Atividade: $ct registros\n' : '';
        } else if (linha == 'modalidade') {
          ct = 0;
          for (var campo in obj) {
            row['id_modalidade'] = campo['id'];
            row['descricao'] = campo['descricao'].toString().trim();
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Modalidade: $ct registros\n' : '';
        } else if (linha == 'perda') {
          ct = 0;
          for (var campo in obj) {
            row['id_perda'] = campo['id'];
            row['descricao'] = campo['descricao'].toString().trim();
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Motivo de Perda: $ct registros\n' : '';
        } else if (linha == 'servidor') {
          ct = 0;
          for (var campo in obj) {
            row['id_servidor'] = campo['id'];
            row['nome'] = campo['nome'].toString().trim();
            row['id_base'] = campo['id_base'];
            await dbHelper.insert(row, linha);
            ct++;
          }
          resumo += ct > 0 ? 'Servidor: $ct registros\n' : '';
        }
      }

      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Cadastro recebido.'),
          backgroundColor: Colors.green[900],
        ),
      );
    } else {
      throw Exception('Falha ao carregar cadastro');
    }
    return resumo;
  }
}