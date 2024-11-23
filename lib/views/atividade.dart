import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/colors-constants.dart';
import 'package:capop_new/controllers/atividade.controller.dart';

class Producao extends StatelessWidget {
  final AtividadeController ctrl = Get.find();
  final int ano = DateTime.parse(new DateTime.now().toString()).year;

  final id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      ctrl.initMaster(id);
    } else {
      ctrl.loadPreferences();
    }
    ctrl.loadBase();

    return Scaffold(
      appBar: AppBar(
        title: Text('ATIVIDADE'),
      ),
      body: SingleChildScrollView(
        controller: ctrl.scrollController,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Obx(
                    () => (TextFormField(
                  style: new TextStyle(
                    fontSize: 12,
                  ),
                  readOnly: true,
                  controller: ctrl.dateController.value,
                  decoration:
                  InputDecoration(hintText: 'Data da Atividade'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'A data é obrigatória!!';
                    } else {
                      return null;
                    }
                  },
                  onSaved: null,
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(ctrl.dtCadastro.value),
                      firstDate: DateTime(ano - 2),
                      lastDate: DateTime(ano + 1),
                    );
                    if (date != null) {
                      await ctrl.getCurrentDate(date.toString().substring(0, 10));
                      date.toString().substring(0, 10);
                    }
                  },
                )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: Text(
                'Servidor:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                    () => ((ctrl.loadingServidor.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  hint: Text('Servidor'),
                  value: ctrl.idServidor.value,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ctrl.lstServidor,
                  onChanged: (value) {
                    ctrl.updateServidor(value);
                  },
                )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_sharp),
              title: Text(
                'Município:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                    () => ((ctrl.loadingMun.value)
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                            hint: Text(''),
                            value: ctrl.idMun.value,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: ctrl.lstMun,
                            onChanged: (value) {
                              ctrl.updateMun(value);
                            },
                          ),),
                          IconButton.outlined(
                            icon: const Icon(Icons.refresh),
                            color: Colors.green,
                            onPressed: () {
                              ctrl.refreshListMun();
                            },
                          ),
                        ],
                      )
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: Text(
                'Perda:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                    () => ((ctrl.loadingPerda.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  hint: Text(''),
                  value: ctrl.idPerda.value,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ctrl.lstPerda,
                  onChanged: (value) {
                    ctrl.updatePerda(value);
                  },
                )),
              ),
            ),
            ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(
                    'Programa:',
                    style: new TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  subtitle: Obx(
                        () => ((ctrl.loadingPrograma.value)
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      hint: Text('Programa'),
                      value: ctrl.idPrograma.value,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      isExpanded: true,
                      items: ctrl.lstPrograma,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        ctrl.updatePrograma(value);
                      },
                    )),
                  ),
                ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: Text(
                'Atividade:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                    () => ((ctrl.loadingAtividade.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  hint: Text(''),
                  value: ctrl.idAtividade.value,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ctrl.lstAtividade,
                  onChanged: (value) {
                    ctrl.updateAtiv(value);
                  },
                )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.rule),
              title: Text(
                'Modalidade:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Obx(
                    () => ((ctrl.loadingModalidade.value)
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  hint: Text(''),
                  value: ctrl.idModalidade.value,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ctrl.lstModalidade,
                  onChanged: (value) {
                    ctrl.updateModalidade(value);
                  },
                )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.holiday_village_outlined),
              title: TextFormField(
                style: new TextStyle(
                  fontSize: 12,
                ),
                controller: ctrl.prodController,
                decoration: InputDecoration(labelText: 'Produção'),
                validator: (value) {
                  ctrl.atividade.value.producao = value!;
                  return null;
                },
                onSaved: null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: Text(
                'Tipo   de Pagamento:',
                style: new TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Radio(
                              value: 1,
                              groupValue: ctrl.idPagamento.value,
                              onChanged: (int? val) {
                                ctrl.setPagamento(val!);
                              },
                            )),
                            Text('Diária'),
                          ]),
                      Row(children: [
                        Obx(() => Radio(
                          value: 2,
                          groupValue: ctrl.idPagamento.value,
                          onChanged: (int? val) {
                            ctrl.setPagamento(val!);
                          },
                        )),
                        Text('Gratificação'),
                      ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                      Obx(() => Radio(
                        value: 3,
                        groupValue: ctrl.idPagamento.value,
                        onChanged: (int? val) {
                          ctrl.setPagamento(val!);
                        },
                      )),
                      Text('Etapa'),
                    ]),
                      Row(children: [
                      Obx(() => Radio(
                        value: 0,
                        groupValue: ctrl.idPagamento.value,
                        onChanged: (int? val) {
                          ctrl.setPagamento(val!);
                        },
                      )),
                      Text('Nenhum'),
                    ]),
                    ],
                  ),
                ]
              ),
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on_outlined),
              title: TextFormField(
                  style: new TextStyle(
                    fontSize: 12,
                  ),
                  controller: ctrl.valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  validator: (value) {
                      ctrl.atividade.value.valor = value!;
                      return null;
                  },
                  onSaved: null,
                ),

            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      ctrl.doRegister(context);
                    },
                    child: Text('SALVAR',style: TextStyle(color: COR_BRANCO),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: COR_AZUL_MARINHO,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
