import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';

import 'package:users_tasks_mz_153/pages/03_reports.dart';
import 'package:users_tasks_mz_153/pages/checkemail.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/pbx.dart';
import 'package:users_tasks_mz_153/pages/ping.dart';
import 'package:users_tasks_mz_153/pages/remind.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:intl/intl.dart' as df;
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

import 'log.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  ThemeController themeController = Get.find();
  MainController mainController = Get.find();
  ThemeController dbController = Get.find();

  static String logininfo = '';
  static bool searchvis = false;
  static List<Map> searchlist = [];
  static bool selectall = true;
  static String backlabel = '';
  static String? connectionerrorIN;
  static List pages = [
    {
      'visible': false,
      'label': 'الصفحة الرئيسية',
      'icon': Icons.departure_board,
      'page': Home(),
      'size': 25.0
    },
    {
      'visible': false,
      'label': 'السجل',
      'icon': Icons.departure_board,
      'page': Logs(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'المكاتب',
      'icon': Icons.work,
      'page': const Office(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'الحسابات',
      'icon': Icons.people,
      'page': const Employ(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'المهام',
      'icon': Icons.task_alt_outlined,
      'page': Tasks(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'الإجرائيات',
      'icon': Icons.work_history,
      'page': Whattodo(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'التذكير',
      'icon': Icons.punch_clock,
      'page': Remind(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'بينغ',
      'icon': Icons.wifi_2_bar_rounded,
      'page': Ping(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'تسجيلات المقسم',
      'icon': Icons.phone,
      'page': PBX(),
      'size': 25.0
    },
    {
      'visible': true,
      'label': 'تفقد أخطاء البريد الالكتروني',
      'icon': Icons.mark_email_unread_outlined,
      'page': Checkemail(),
      'size': 25.0
    },
  ];
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    Future(() async => await mainController.loginlogoutlog(1));
    return Scaffold(
      body: GetBuilder<ThemeController>(
        init: themeController,
        builder: (_) => Stack(
          children: [
            Center(
                child: GetBuilder<MainController>(
              init: mainController,
              builder: (_) {
                pages[2]['visible'] = pages[3]['visible'] = checkifUserisAdmin(
                    usertable: DB.userstable,
                    userid: DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['user_id']);
                pages[8]['visible'] = DB.userstable[DB.userstable.indexWhere(
                                (element) =>
                                    element['username'] == Home.logininfo)]
                            ['pbx'] ==
                        1
                    ? true
                    : false;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "تكامل",
                            style: TextStyle(fontSize: 30),
                          ),
                          TweenMZ.transperant(
                            duration: 2000,
                            child0: Image.asset(
                              'lib\\assets\\images\\takamollogo.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 75,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    maxCrossAxisExtent: 250),
                            children: [
                              ...pages
                                  .where(
                                      (element) => element['visible'] != false)
                                  .map((m) {
                                return GestureDetector(
                                    onTap: () => mainController
                                        .homemaincontent(pages.indexOf(m)),
                                    child: TweenMZ.translatey(
                                      begin: -150.0,
                                      duration: (pages.indexOf(m) + 1) * 50,
                                      end: 0.0,
                                      child0: MouseRegion(
                                          onHover: (x) {
                                            mainController
                                                .changeonhoverpagestitle(
                                                    ctx: context,
                                                    x: pages.indexOf(m));
                                          },
                                          onExit: (x) {
                                            mainController.changeonexitdropMore(
                                                ctx: context,
                                                x: pages.indexOf(m));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 3)
                                                ]),
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        m['icon'],
                                                        size: m['size'],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        m['label'],
                                                        style: ThemeMZ()
                                                            .theme()
                                                            .textTheme
                                                            .labelMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ));
                              })
                            ]),
                      )
                    ]);
              },
            )),
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
