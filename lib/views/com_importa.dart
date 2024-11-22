import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/colors-constants.dart';
import 'package:capop_new/controllers/importa.controller.dart';
import 'package:capop_new/models/territorio.dart';

class ComImporta extends StatelessWidget {
  final ImportaController ctrl = Get.put(ImportaController());
  int id_gve = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMPORTAÇÃO'),
      ),
      body: Column(
        children: [
          Text('Local a importar:'),
          Form(
              child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Autocomplete<Territorio>(
                              optionsBuilder: (textEditingValue){
                                return ctrl.territorioList
                                    .where((Territorio gve) => gve.nome
                                    .toLowerCase()
                                    .startsWith(textEditingValue.text.toLowerCase()))
                                    .toList();
                              },
                            displayStringForOption: (Territorio gve) => gve.nome,
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted){
                                  return TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Selecione o GVE'
                                    ),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  );
                                },
                            onSelected: (Territorio sel){
                              id_gve = sel.id_territorio;
                            },
                          ),
                      ),
                      Row(
                        children: [
                          Padding(
                          padding: EdgeInsets.all(16),
                          child:
                          Obx(
                                () => Switch(
                              value: ctrl.clearAll.value,
                              onChanged: (value) {
                                ctrl.clearAll.value = value;
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ),
                          ),
                          Text('Manter os cadastros já existentes.')
                        ],
                      ),
                  ],
                  ),

          ),
          Container(
            height: 5,
            child: Divider(
              color: Colors.blue,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Obx(() {
                return !ctrl.loading.value == true
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              ctrl.loadCadastro(context, id_gve);
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
            ),
          ),
          Obx(() {
            return ctrl.loading.value == true
                ? Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [CircularProgressIndicator()]),
                  )
                : Text(ctrl.retorno.value);
          })
        ],
      ),
    );
  }
}
