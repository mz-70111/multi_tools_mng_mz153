// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class BottomNBMZ extends StatelessWidget {
  MainController mainController = Get.find();
  DBController dbController = Get.find();
  ThemeController themeController = Get.find();
  static bool vis = true;
  static List pageslist = [
    {
      'label': 'الصفحة الرئيسية',
      'color': [
        Colors.transparent,
        Colors.indigoAccent,
        Colors.transparent,
      ],
      'icon': Icons.home,
      'rotate': 45.0 * pi / 180,
      'irotate': -45.0 * pi / 180,
      'rize': -25.0,
      'border': Colors.indigo
    },
    {
      'label': 'الأرشيف',
      'color': [
        Colors.transparent,
        Colors.transparent,
      ],
      'icon': Icons.report,
      'rotate': 0.0,
      'irotate': 0.0,
      'rize': 0.0,
      'border': Colors.transparent
    },
  ];
  BottomNBMZ({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: AppBar().preferredSize.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: ThemeMZ().appbarbk())),
          child: GetBuilder<MainController>(
            init: mainController,
            builder: (_) => Row(children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pageslist
                      .map((e) => Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              TweenMZ.rotate(
                                duration: 200,
                                end: e['rotate'],
                                child0: TweenMZ.translatey(
                                  duration: 300,
                                  end: e['rize'],
                                  child0: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.elliptical(25, 5)),
                                        color: Colors.transparent,
                                        border: Border.all(color: e['border'])),
                                    child: Container(
                                      child: TweenMZ.rotate(
                                        duration: 500,
                                        end: e['irotate'],
                                        child0: IconButton(
                                            onPressed: () {
                                              mainController
                                                  .navbar(pageslist.indexOf(e));
                                            },
                                            icon: Icon(
                                              e['icon'],
                                              color: Colors.white,
                                            )),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.elliptical(25, 5)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            colors: e['color'],
                                          )),
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          mainController.moretoolsshow(context);
                        },
                        icon: const Icon(
                          Icons.density_medium_rounded,
                          color: Colors.white,
                        )),
                  )
                ],
              )
            ]),
          )),
    ]);
  }
}

MainController mainController = Get.find();

class MoreTools extends StatelessWidget {
  MoreTools({super.key});
  ThemeController themeController = Get.find();
  static double dropend = 1000;
  static List moretoolslist = [
    {
      'label': 'تذكير',
      'action': () {
        mainController.homemaincontent(6);
      },
      'size': 150.0
    },
    {'label': 'ping', 'action': () {}, 'size': 150.0},
    {'label': 'مقسم', 'action': () {}, 'size': 150.0}
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        init: mainController,
        builder: (_) {
          return TweenMZ.translatey(
            begin: MediaQuery.of(context).size.height,
            end: dropend,
            duration: 200,
            child0: SizedBox(
              width: 180,
              child: Card(
                child: Column(
                  children: moretoolslist
                      .map((e) => SizedBox(
                          width: e['size'],
                          child: TweenMZ.translatex(
                            begin: -150.0,
                            duration: (moretoolslist.indexOf(e) + 1) * 200,
                            end: 0.0,
                            child0: GestureDetector(
                              onTap: e['action'],
                              child: MouseRegion(
                                onHover: (x) {
                                  mainController.changeonhoverdropMore(
                                      x: moretoolslist.indexOf(e));
                                },
                                child: Card(
                                  color: Colors.indigoAccent.withOpacity(0.7),
                                  child: GetBuilder<ThemeController>(
                                    init: themeController,
                                    builder: (_) => Text(
                                      " > ${e['label']}",
                                      style: ThemeMZ()
                                          .theme()
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )))
                      .toList(),
                ),
              ),
            ),
          );
        });
  }
}
