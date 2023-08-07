import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    DBController dbController = Get.find();
    return GetBuilder<DBController>(
      init: dbController,
      builder: (_) => FutureBuilder(future: Future(() async {
        try {
          await Future.delayed(Duration(seconds: 2));
          await dbController.gettable(
              list: DB.userstable,
              usertable: DB.userstable,
              table: 'users',
              type: 'all');
          await mainController.getappverion();
          await mainController.getreminddate();
          await mainController.getalluserstable();
          await mainController.autosendnotifitasks();
          await mainController.autosendnotifiremind();
        } catch (e) {}
      }), builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenMZ.transperant(
                        duration: 2000,
                        child0: Image.asset(
                          'lib\\assets\\images\\takamollogo.png',
                        ),
                      ),
                      Text(
                        "تكامل",
                        style: TextStyle(fontSize: 75),
                      ),
                      SizedBox(width: 100, child: LinearProgressIndicator())
                    ],
                  ),
                )),
                const Column(
                  children: [
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "developed by : معاذ الحوراني",
                          textAlign: TextAlign.center,
                        )),
                        Text("770111")
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return LogIn();
        }
      }),
    );
  }
}
