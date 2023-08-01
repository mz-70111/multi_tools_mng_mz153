import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

// ignore: must_be_immutable
class Reports extends StatelessWidget {
  Reports({super.key});
  ThemeController themeController = Get.find();
  DBController dbController = Get.find();
  static TextEditingController officename = TextEditingController();
  static TextEditingController chatid = TextEditingController();

  static bool addvis = false;
  static bool addwaitvis = false, addoredit = true;
  static String timedayvalue = 'غير محدد';
  static String timemonthvalue = 'غير محدد';
  static String officelistvalue = 'مخصص';
  static List temp = [];
  static String timeyearvalue = 'غير محدد';
  static double addvisEnd = 0.0;
  static double addvisBegin = -200.0;
  static double addvisBeginx = 200.0;
  static IconData addicon = Icons.add;
  static double addiconBeginRotate = 0.0 * pi / 180;
  static double addiconEndRotate = 0.0 * pi / 180;
  static List? customUserstable;
  static ScrollController mzcontroller = ScrollController();
  static List<Map> mylista = [];
  static List<Map> todolista = [];
  static List<Map> tasklista = [];
  static String errormsg = '';
  static late int officeid;
  static List tempforgetdate = [];

  static List<Map> offices = [
    {
      'label': 'اسم المكتب',
      'controller': officename,
      'error': null,
      'icon': Icons.work,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.rtl
    },
    {
      'label': 'chat id',
      'controller': chatid,
      'error': null,
      'icon': Icons.api,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.ltr
    },
  ];

  static bool emplyvis = false;
  List dbusertableAction = [
    {'label': 'الاسم'},
    {'label': 'المهام'},
    {'label': 'الإجرائيات'},
  ];
  static bool selectall = false;
  static bool deletewait = false;
  List reportinfo = [];
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DBController>(
        init: dbController,
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              FutureBuilder(future: Future(() async {
                try {
                  return {
                    await dbController.gettable(
                      usertable: DB.userstable,
                      list: mylista,
                      tableid: 'user_id',
                      table: 'users',
                    ),
                    await dbController.gettable(
                      usertable: DB.userstable,
                      list: todolista,
                      tableid: 'todo_id',
                      table: 'todo',
                    ),
                    await dbController.gettable(
                      usertable: DB.userstable,
                      list: tasklista,
                      tableid: 'task_id',
                      table: 'tasks',
                    )
                  };
                } catch (e) {
                  null;
                }
              }), builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snap.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("لا يمكن الوصول للمخدم"),
                        TextButton(
                            onPressed: () {
                              dbController.update();
                            },
                            child: const Icon(Icons.refresh))
                      ],
                    ),
                  );
                } else {
                  reportinfo.clear();
                  var todo = 0, tasks = 0, tasksdone = 0;
                  for (var i in mylista) {
                    todo = tasks = tasksdone = 0;
                    reportinfo.add({
                      'user_id': i['user_id'],
                      'todo': todo,
                      'tasksdone': tasksdone,
                      'tasks': tasks
                    });
                    for (var j in todolista) {
                      if (j['createby_id'] == i['user_id']) {
                        todo++;
                      }
                    }
                    reportinfo[mylista.indexOf(i)]['todo'] = todo;
                    for (var l in tasklista) {
                      if (l['userstask_id'].contains(i['user_id'])) {
                        tasks++;
                      }
                      if (l['userstask_id'].contains(i['user_id']) &&
                          l['status'] == 1) {
                        tasksdone++;
                      }
                    }
                    reportinfo[mylista.indexOf(i)]['tasks'] = tasks;
                    reportinfo[mylista.indexOf(i)]['tasksdone'] = tasksdone;
                  }
                  List officelist = ['جميع النتائج', 'مخصص'];
                  for (var i in DB.officetable) {
                    officelist.add(i['officename']);
                  }
                  temp.clear();
                  for (var j in Home.searchlist) {
                    if (j['check'] == true) {
                      temp.add('1');
                    }
                  }
                  if (temp.length == Home.searchlist.length) {
                    officelistvalue = 'جميع النتائج';
                  } else if (temp.isEmpty) {
                    officelistvalue = 'مخصص';
                  } else if (temp.length == 1) {
                    officelistvalue = temp[0];
                  } else if (temp.length > 1) {
                    officelistvalue = 'مخصص';
                  }
                  return GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => GetBuilder<DBController>(
                      init: dbController,
                      builder: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Visibility(
                                  visible:
                                      DB.officetable.isNotEmpty ? true : false,
                                  child: Card(
                                    child: DropdownButton(
                                        value: officelistvalue,
                                        items: officelist
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text("$e")))
                                            .toList(),
                                        onChanged: (x) {
                                          mainController.chooseoffice(
                                            x,
                                          );
                                          dbController.update();
                                        }),
                                  )),
                              Expanded(
                                child: TextFieldMZ(
                                    label: "بحث",
                                    onChanged: (word) {
                                      mainController.search(
                                          word: word,
                                          list: mylista,
                                          range: [
                                            'user_id',
                                            'username',
                                            'fullname',
                                            'officename',
                                            'privilege',
                                            'offndx'
                                          ]);
                                    }),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("بحث بحسب التاريخ"),
                                    TextButton.icon(
                                        onPressed: () {
                                          mainController.choosedate(
                                              ctx: context,
                                              beginorend: 'begin');
                                        },
                                        icon: const Icon(Icons.date_range),
                                        label: Text(
                                            "من ${df.DateFormat('yyyy-MM-dd').format(Tasks.sortbydatebegin)}",
                                            style:
                                                const TextStyle(fontSize: 15))),
                                    TextButton.icon(
                                        onPressed: () {
                                          mainController.choosedate(
                                              ctx: context, beginorend: 'end');
                                        },
                                        icon: const Icon(Icons.date_range),
                                        label: Text(
                                            "إلى ${df.DateFormat('yyyy-MM-dd').format(Tasks.sortbydateend)}",
                                            style:
                                                const TextStyle(fontSize: 15))),
                                  ]),
                            ),
                          ),
                          Row(
                            children: [
                              ...dbusertableAction
                                  .map((e) => Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                e['label'],
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                          Expanded(
                            child: GetBuilder<MainController>(
                              init: mainController,
                              builder: (_) => Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: mylista.map((e) {
                                          return Visibility(
                                            visible: e['visible'],
                                            child: Card(
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              "# ${e['user_id']} _ ${e['fullname']}",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Visibility(
                                                      visible: reportinfo[mylista
                                                                      .indexOf(
                                                                          e)]
                                                                  ['tasks'] ==
                                                              0
                                                          ? false
                                                          : true,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 20,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3,
                                                                ),
                                                                Container(
                                                                  color: Colors
                                                                      .green,
                                                                  height: 20,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3 *
                                                                      ((reportinfo[mylista.indexOf(e)]['tasksdone'] *
                                                                              100) /
                                                                          reportinfo[mylista.indexOf(e)]
                                                                              [
                                                                              'tasks']) /
                                                                      100,
                                                                ),
                                                                Positioned(
                                                                  right: 10,
                                                                  child: Text(
                                                                    "${reportinfo[mylista.indexOf(e)]['tasksdone']}",
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  left: 10,
                                                                  child: Text(
                                                                    "${reportinfo[mylista.indexOf(e)]['tasks']}",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Text(
                                                      " ${reportinfo[mylista.indexOf(e)]['todo']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))
                                                  ]),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
              Positioned(left: 0, child: Notificationm()),
              GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) => Positioned(left: 0, child: PersonPanel())),
            ],
          ),
        ),
      ),
    );
  }
}
