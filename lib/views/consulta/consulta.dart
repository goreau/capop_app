import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/controllers/consulta.controller.dart';
import 'package:capop_new/models/atividade.dart';
import 'package:capop_new/util/routes.dart';
import 'package:capop_new/views/consulta/consulta-master.dart';
import '../../colors-constants.dart';

class Consulta extends StatelessWidget {
  final ConsultaController ctrl = Get.put(ConsultaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produçõoes registradas'),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.PRODUCAO, arguments: 0);
            },
            child: Icon(
              Icons.add,
              color: COR_BRANCO,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
          padding: EdgeInsets.all(20),
            child: Text('Atividades Registradas',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        Container(
          height: 2,
          child: Divider(
            color: Colors.blueGrey,
          ),
        ),
        Container(
          child: Obx(() {
            return ctrl.loaded.value
                ? ListaVisitas(ctrl.itens)
                : Text(
                    'Carregando...',
                    style: TextStyle(color: COR_SECUNDARIA),
                  );
            },
          ),
        ),
      ]),
    );
  }
}

class ListaVisitas extends StatelessWidget {
  final List<LstMaster> lista;
  ListaVisitas(this.lista);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        child: ListView.builder(
          itemCount: lista.length,
          itemBuilder: (ctx, i) => ConsultaMaster(lista[i]),
        ),
      ),
    );
  }
}
