import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:capop_new/models/atividade.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final _databaseName = "capop_new.db";
  static final _databaseVersion = 2;

  Map registros = Map<String, dynamic>();


  static final sqlCreate = [
    "CREATE TABLE municipio(id_municipio INTEGER, nome TEXT, codigo TEXT, id_regional INTEGER, id_regiao INTEGER, principal INTEGER)",
    "CREATE TABLE programa(id_programa INTEGER, descricao TEXT)",
    "CREATE TABLE aux_atividade(id_aux_atividade INTEGER, id_programa INTEGER, descricao TEXT, codigo INTEGER, ordem INTEGER)",
    "CREATE TABLE modalidade(id_modalidade INTEGER, descricao TEXT)",
    "CREATE TABLE perda(id_perda INTEGER, descricao TEXT)",
    "CREATE TABLE servidor(id_servidor INTEGER, id_base INTEGER, nome TEXT)",
    "CREATE TABLE atividade(id_atividade INTEGER PRIMARY KEY, dt_cadastro TEXT, id_municipio INTEGER, id_servidor INTEGER, id_aux_atividade INTEGER, producao INTEGER, id_perda INTEGER, id_pagamento INTEGER, id_modalidade INTEGER, id_programa INTEGER, valor REAL, status INTEGER)",
  ];
  static final tabelas = {
    "municipio",
    "programa",
    "aux_atividade",
    "modalidade",
    "perda",
    "servidor",
    "atividade",
  };

  // torna esta classe singleton
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
  }

  Future _onUpgrade(Database db, int version, int newVersion) async {
    debugPrint('Recriando tabelas');
    await _persiste(db);
    for (var e in tabelas) {
      await db.execute("DROP TABLE IF EXISTS $e");
    }
    await _onCreate(db, newVersion);
    _recupera(db);
    debugPrint('Tabelas recriadas');
  }

  // Código SQL para criar o banco de dados e as tabelas
  Future _onCreate(Database db, int version) async {
    //
    Batch batch = db.batch();
    try {
      sqlCreate.forEach((e) {
        batch.execute(e);
      });
      await batch.commit();
      debugPrint('Tabelas criadas');
    } catch (e) {
      debugPrint('Erro criando tabela $e');
    }
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<Map<String, dynamic>> queryMaster(int id) async {
    Database? db = await instance.database;
    var resultset =
        await db!.query('atividade', where: 'id_atividade = ?', whereArgs: [id]);
    return resultset[0];
  }

  Future<int?> queryRowCount(String table) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row, String table, int id) async {
    Database? db = await instance.database;
    String idField = 'id_$table';
    return await db!.update(table, row, where: '$idField = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async {
    Database? db = await instance.database;
    String idField = 'id_$table';
    return await db!.delete(table, where: '$idField = ?', whereArgs: [id]);
  }

  Future<int> limpa(String table) async {
    Database? db = await instance.database;
    return await db!.delete(table);
  }

  Future<int> limpaAtividade(int tipo) async {
    Database? db = await instance.database;

      if (tipo == 1) {
        return await db!.delete('atividade');
      } else {
        return await db!.delete('atividade', where: 'status = ?', whereArgs: [1]);
      }
  }

  Future<void> _persiste(Database db) async {
    //fornecer valor padrão para o campo alterado
    final persTabela = ["municipio", "programa", "aux_atividade", "modalidade", "perda", "servidor", "atividade"];
    try {
      for (var element in persTabela) {
        var lista = [];
        await db.query(element).then((value) {
          for (var row in value) {
            //value.forEach((row) {
            lista.add(row);
          } //);
          registros[element] = lista;
        });
      }
    } catch (e) {
      debugPrint('Tabela inexistente');
    }
  }

  Future<List<LstMaster>> consultaAtividadesMaster() async {
    Database? db = await instance.database;
    var sql =
        'SELECT v.id_atividade, v.dt_cadastro as data, m.nome as municipio, p.descricao as programa, at.descricao as atividade, v.status ' +
            'FROM atividade v join municipio m on v.id_municipio=m.id_municipio ' +
                'JOIN programa p ON p.id_programa= v.id_programa JOIN aux_atividade at ON at.id_aux_atividade=v.id_aux_atividade';
    List<Map<String, dynamic>> resultSet = await db!.rawQuery(sql);

    List<LstMaster> list = new List.generate(resultSet.length, (index) {
      return LstMaster.fromJson(resultSet[index]);
    });

    return list;
  }

  _recupera(Database db) async {
    //print(registros);
    final persTabela = [
      "municipio",
      "programa",
      "aux_atividade",
      "modalidade",
      "perda",
      "servidor",
      "atividade",
    ];
    for (var element in persTabela) {
      var tab = registros[element];
      for (var reg in tab) {
        db.insert(element, reg);
      }
    }
  }

  Future<int> getProp(int mun) async {
    Database? db = await instance.database;
    var prop = 0;
    var resultSet =  await db!.query('municipio', where: 'id_municipio=?', whereArgs: [mun]);

    var dbItem = resultSet.first;
    // Access its id
    prop = int.parse(dbItem['id_prop'].toString());

    return prop;
  }

  Future<List<Map>>
  qryCombo(String tabela, filtro) async {
    Database? db = await instance.database;
    String sql;
    String ord;


    if (tabela == 'servidor') {
      sql = 'SELECT id_$tabela as id, nome FROM $tabela';
      ord = 'nome';
    } else if (tabela == 'programa' || tabela == 'modalidade'  || tabela == 'perda') {
      sql = "SELECT id_$tabela as id, (id_$tabela || '.' || descricao) as nome FROM $tabela";
      ord = 'id_$tabela';
    } else if (tabela == 'municipio') {
      sql = 'SELECT id_$tabela as id, nome as nome FROM $tabela';
      ord = 'nome';
    } else {
      sql = "SELECT id_$tabela as id, (codigo || '.' || descricao) as nome FROM $tabela";
      ord = 'codigo';
    }
    sql += filtro == '' ? ' ORDER BY $ord' : ' WHERE $filtro ORDER BY $ord';

    return await db!.rawQuery(sql);
  }

  Future<int> qryCountEnvio() async {
    Database? db = await instance.database;
    String sql = 'SELECT count(*) as qt FROM atividade WHERE status=0';
    var qt = 0;
    var resultSet = await db!.rawQuery(sql);

    var dbItem = resultSet.first;


    // Access its id
    qt = int.parse(dbItem['qt'].toString());


    return (qt);
  }

  Future<List<Map>> qryEnvio() async {
    Database? db = await instance.database;
    var resultSet =
        await db!.query('atividade', where: 'status=?', whereArgs: [0]);

    return resultSet;
  }



  Future<int> updateStatus(linha) async {
    Database? db = await instance.database;

    var result = await db!.update('atividade', {'status': linha['status']},
        where: 'id_atividade = ?', whereArgs: [linha['id']]);

    return result;
  }
}
