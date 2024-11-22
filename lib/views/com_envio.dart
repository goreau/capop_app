import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/colors-constants.dart';
import 'package:capop_new/controllers/exporta.controller.dart';

class ComExporta extends StatelessWidget {
  final ExportaController ctrl = Get.put(ExportaController());

  @override
  Widget build(BuildContext context) {
    ctrl.verifEnvio(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('EXPORTAÇÃO'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('Registros a exportar',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 5, 10),
            child: Obx(() {
              return Text(ctrl.retorno.value);
            }),
          ),
          Obx(() {
            return !ctrl.loading.value
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.postVisitas(context);
                        },
                        child: Text('SINCRONIZAR DADOS', style: TextStyle(color: COR_BRANCO),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: COR_AZUL_MARINHO,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  )
                : Text('Aguarde...');
          }),
          Container(
            height: 4,
            child: Divider(
              color: Colors.blue,
            ),
          ),
          Obx(() {
            return ctrl.loading.value
                ? Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [CircularProgressIndicator()]),
                  )
                : Text(ctrl.resultado.value);
          })
        ],
      ),
    );
  }
}
