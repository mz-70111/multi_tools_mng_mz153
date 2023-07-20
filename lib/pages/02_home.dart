import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';

import 'package:users_tasks_mz_153/pages/03_reports.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/remind.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:intl/intl.dart' as df;

// ignore: must_be_immutable
class Home extends StatelessWidget {
  ThemeController themeController = Get.find();
  MainController mainController = Get.find();
  ThemeController dbController = Get.find();

  static String logininfo = '';
  static bool searchvis = false;
  static List<Map> searchlist = [];
  static bool selectall = true;
  static String? connectionerrorIN;
  static List pages = [
    {
      'visible': false,
      'label': 'الصفحة الرئيسية',
      'icon': Icons.home_filled,
      'page': Home()
    },
    {
      'visible': false,
      'label': 'التقارير',
      'icon': Icons.departure_board,
      'page': Reports()
    },
    {
      'visible': true,
      'label': 'المكاتب',
      'icon': Icons.work,
      'page': const Office(),
    },
    {
      'visible': true,
      'label': 'الحسابات',
      'icon': Icons.people,
      'page': const Employ()
    },
    {
      'visible': true,
      'label': 'المهام',
      'icon': Icons.task_alt_outlined,
      'page': Tasks()
    },
    {
      'visible': true,
      'label': 'الإجرائيات',
      'icon': Icons.work_history,
      'page': Whattodo()
    },
    {
      'visible': false,
      'label': 'التذكير',
      'icon': Icons.work_history,
      'page': Remind()
    }
  ];
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ThemeController>(
        init: themeController,
        builder: (_) => Stack(
          children: [
            Center(
              child: GetBuilder<MainController>(
                init: mainController,
                builder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                              visible: searchvis,
                              child: Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFieldMZ(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    searchbydate(ctx: context);
                                                  },
                                                  icon: const Icon(
                                                      Icons.date_range)),
                                              label: "بحث",
                                              onChanged: (x) {
                                                mainController.search(
                                                    word: x,
                                                    list: Home.searchlist,
                                                    range: [
                                                      'user_id',
                                                      'username',
                                                      'fullname',
                                                      'officename',
                                                      'taskname',
                                                      'todoname',
                                                      'remindname'
                                                    ]);
                                              }),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Checkbox(
                                                          value: selectall,
                                                          onChanged: (x) {
                                                            mainController
                                                                .checkboxSelectallHomeSearch(
                                                                    x);
                                                          }),
                                                      Text(
                                                        "تحديد الكل",
                                                        style: ThemeMZ()
                                                            .theme()
                                                            .textTheme
                                                            .labelMedium,
                                                      )
                                                    ],
                                                  ),
                                                  ...searchlist.map((e) {
                                                    String i = '';
                                                    i = isearchlist(e: e);

                                                    return Visibility(
                                                      visible: e['visible'],
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                              value: e['check'],
                                                              onChanged: (x) {
                                                                mainController
                                                                    .checkboxsearch(
                                                                        x,
                                                                        searchlist
                                                                            .indexOf(e));
                                                              }),
                                                          Expanded(
                                                            child: Text(
                                                              i,
                                                              softWrap: true,
                                                              style: ThemeMZ()
                                                                  .theme()
                                                                  .textTheme
                                                                  .labelMedium,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              )),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                )),
                            child: IconButton(
                                onPressed: () {
                                  mainController.searchvis();
                                },
                                icon:
                                    const Icon(Icons.settings_input_component)),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: pages
                                    .map((e) => Visibility(
                                          visible: e['visible'],
                                          child: GestureDetector(
                                            onTap: () =>
                                                mainController.homemaincontent(
                                                    pages.indexOf(e)),
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(e['icon']),
                                                    Visibility(
                                                        visible: !searchvis,
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(),
                                                            Text(e['label'],
                                                                style: ThemeMZ()
                                                                    .theme()
                                                                    .textTheme
                                                                    .labelMedium),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(left: 0, child: Notificationm()),
            Positioned(left: 0, child: PersonPanel()),
          ],
        ),
      ),
    );
  }
}

isearchlist({e}) {
  String i;
  e.keys.toList().first == 'user_id'
      ? i = "${e['fullname']}"
      : e.keys.toList().first == 'office_id'
          ? i = e['officename']
          : e.keys.toList().first == 'task_id'
              ? i =
                  "${e['taskname']} ${df.DateFormat("yyyy-MM-dd HH:mm").format(e['createdate'])}"
              : e.keys.toList().first == 'todo_id'
                  ? i = e['todoname']
                  : i = e['remindname'];

  return i;
}

searchbydate({ctx}) {
  MainController mainController = Get.find();
  showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("بحث بحسب التاريخ"),
                    const Text(
                      "مخصص للمهام",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        mainController.choosedate(
                            ctx: ctx, beginorend: 'begin');
                      },
                      icon: const Icon(Icons.date_range),
                      label: GetBuilder<MainController>(
                        init: mainController,
                        builder: (_) => Text(
                          "من ${df.DateFormat('yyyy-MM-dd').format(Tasks.sortbydatebegin)}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          mainController.choosedate(
                              ctx: ctx, beginorend: 'end');
                        },
                        icon: const Icon(Icons.date_range),
                        label: GetBuilder<MainController>(
                          init: mainController,
                          builder: (_) => Text(
                              "إلى ${df.DateFormat('yyyy-MM-dd').format(Tasks.sortbydateend)}",
                              style: const TextStyle(fontSize: 15)),
                        )),
                  ]),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  mainController.setdate();

                  Get.back();
                },
                icon: const Icon(Icons.done))
          ],
        );
      });
}
