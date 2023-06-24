import 'package:flutter/material.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';

class ThemeMZ {
  static String mode = ThemeController().getmode() ?? 'light';
  IconData modeicon() => mode == 'light' ? Icons.sunny : Icons.dark_mode;
  List<Color> appbarbk() => mode == 'light'
      ? [Colors.indigoAccent, Colors.indigo, Colors.white]
      : [Colors.indigoAccent, Colors.indigo, Colors.black];
  ThemeData theme() => mode == 'light' ? lthememz : dthememz;
  static homemaincontentwidth(ctx) => Home.searchvis == true
      ? MediaQuery.of(ctx).size.width * 0.20
      : MediaQuery.of(ctx).size.width * 0.65;

  ThemeData lthememz = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(fontFamily: 'Marhey', fontSize: 25)),
    textTheme: const TextTheme(
      labelMedium: TextStyle(fontFamily: 'Marhey', fontSize: 15),
      labelLarge: TextStyle(fontFamily: 'Marhey', fontSize: 18),
      bodyMedium: TextStyle(fontFamily: 'Marhey', fontSize: 15),
    ),
    checkboxTheme: const CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(Colors.indigoAccent)),
    iconTheme: const IconThemeData(color: Colors.indigoAccent),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigoAccent,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.elliptical(10, 10),
        ),
      ),
    ),
  );
  ThemeData dthememz = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(fontFamily: 'Marhey', fontSize: 25)),
    textTheme: const TextTheme(
      labelMedium: TextStyle(fontFamily: 'Marhey', fontSize: 15),
      labelLarge: TextStyle(fontFamily: 'Marhey', fontSize: 18),
      bodyMedium: TextStyle(fontFamily: 'Marhey', fontSize: 15),
    ),
    checkboxTheme: const CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(Colors.white10)),
    iconTheme: const IconThemeData(color: Colors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.indigoAccent,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)))),
  );
}
