class Atividade {

  late int id;
  late String dtCadastro;
  late int idPagamento = 0;
  late String valor;
  late String producao;
  late int idMunicipio;
  late int idServidor;
  late int idPrograma;
  late int idModalidade;
  late int idPerda = 999;
  late int idAtividade;



  void fromJson(dynamic json) {
    id = int.parse(json['id_atividade'].toString());
    dtCadastro = json['dt_cadastro'];
    idPagamento = int.parse(json['id_pagamento'].toString());
    valor = json['valor'].toString();
    producao = json['produco'].toString();
    idMunicipio = int.parse(json['id_municipio'].toString());
    idServidor = int.parse(json['id_servidor'].toString());
    idPrograma = int.parse(json['id_programa'].toString());
    idAtividade = int.parse(json['id_aux_atividade'].toString());
    idModalidade = int.parse(json['id_modalidade'].toString());
    idPerda = int.parse(json['id_perda'].toString());
  }

  Map toJson() => {
    'id_atividade': id,
    'dt_cadastro': dtCadastro,
    'id_servidor': idServidor,
    'producao': producao,
    'id_pagamento': idPagamento,
    'id_municipio': idMunicipio,
    'valor': valor,
    'id_aux_atividade': idAtividade,
    'id_programa': idPrograma,
    'id_modalidade': idModalidade,
    'id_perda': idPerda,
  };
}

class LstMaster {
  int id;
  String municipio;
  String data;
  String programa;
  String atividade;
  int status;

  LstMaster(
      this.id, this.municipio, this.data, this.programa, this.atividade, this.status);

  factory LstMaster.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    var dt = json['data'].toString();
    var dtcapt = dt.split('-').reversed.join('/');
    return LstMaster(
      int.parse(json['id_atividade'].toString()),
      json['municipio'].toString().trim(),
      dtcapt,
      json['programa'],
      json['atividade'],
      int.parse(json['status'].toString()),
    );
  }
}

class LstDetail {
  int id;
  String codend;
  String metodo;
  String ambiente;
  String amostra;

  LstDetail(this.id, this.codend, this.metodo, this.ambiente, this.amostra);

  factory LstDetail.fromJson(dynamic json) {
    //var prop = jsonDecode(json['dados_proposta']);
    return LstDetail(
        int.parse(json['id_captura_det'].toString()),
        json['codend'].toString(),
        json['metodo'].toString(),
        json['ambiente'].toString(),
        json['amostra'].toString()
    );
  }
}