import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/util/routes.dart';
import 'colors-constants.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Capop',
      theme: buildThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: rotas,
    );
  }
}


ThemeData buildThemeData() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
    primaryColor: COR_BRANCO,
    appBarTheme: AppBarTheme(
      backgroundColor: COR_AZUL,
      titleTextStyle: TextStyle(
          color: COR_BRANCO,
          fontSize: 20
      ),
      iconTheme: IconThemeData(color: COR_BRANCO),
    ),
    primaryTextTheme: TextTheme(
        titleLarge: TextStyle(
          color: COR_BRANCO,
        )),
    primaryIconTheme: IconThemeData(color: COR_BRANCO),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    dropdownMenuTheme:  const DropdownMenuThemeData( inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())),
    textTheme: baseTheme.textTheme.copyWith(
      bodyLarge: TextStyle(
        color: COR_AZUL_MARINHO,
      ),
      bodyMedium: TextStyle(
        color: COR_AZUL_MARINHO,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.w100,
      ),
    ),
  );
}
