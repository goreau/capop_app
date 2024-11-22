import 'package:get/get.dart';
import 'package:capop_new/util/sample.bind.dart';
import 'package:capop_new/views/com_envio.dart';
import 'package:capop_new/views/com_importa.dart';
import 'package:capop_new/views/consulta/consulta.dart';
import 'package:capop_new/views/manutencao.dart';
import 'package:capop_new/views/atividade.dart';
import 'package:capop_new/views/principal.dart';
import 'package:capop_new/views/splash.dart';

class Routes {
  static const SPLASH = '/';
  static const HOME = '/home';
  static const COM_IMPORTA = '/com_importa';
  static const COM_EXPORTA = '/com_exporta';
  static const PRODUCAO = '/producao';
  static const CONSULTA = '/consulta';
  static const LIMPEZA = '/limpeza';
}

List<GetPage<dynamic>> rotas = [
  GetPage(name: Routes.SPLASH, page: () => SplashPage()),
  GetPage(name: Routes.HOME, page: () => Principal()),
  GetPage(name: Routes.COM_IMPORTA, page: () => ComImporta()),
  GetPage(name: Routes.COM_EXPORTA, page: () => ComExporta()),
  GetPage(
      name: Routes.PRODUCAO, page: () => Producao(), binding: SampleBind()),
   GetPage(name: Routes.CONSULTA, page: () => Consulta()),
  GetPage(
      name: Routes.LIMPEZA,
      page: () => ManutencaoView(),
      binding: SampleBind()),
];
