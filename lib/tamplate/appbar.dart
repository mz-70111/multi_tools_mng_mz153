// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/01_homepage.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

MainController mainController = Get.find();

class PersonPanel extends StatelessWidget {
  DBController dbController = Get.find();
  ThemeController themeController = Get.find();
  static TextEditingController oldpassword = TextEditingController();
  static TextEditingController newpassword = TextEditingController();
  static TextEditingController confirmpassword = TextEditingController();
  static bool obscuretext = true;
  static IconData iconchangepass = Icons.visibility_off;
  PersonPanel({super.key});
  static double dropend = -150.0;
  static String updatepassworderror = '';
  static bool personalvisible = false;
  static List dropdbitem({ctx}) => [
        {
          'label': Home.logininfo.isNotEmpty
              ? DB.userstable[DB.userstable.indexWhere(
                      (element) => element['username'] == Home.logininfo)]
                  ['fullname']
              : '',
          'action': () {
            showinfo(ctx: ctx);
          },
          'size': 150.0
        },
        {
          'label': 'تغيير كلمة المرور',
          'action': () {
            mainController.changepasswordPresonal(ctx: ctx);
          },
          'size': 150.0
        },
        {
          'label': 'تسجيل الخروج',
          'action': () async {
            LogIn.removelogin();
            personalvisible = false;
          },
          'size': 150.0
        }
      ];
  static List dropdbitemz = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: mainController,
      builder: (_) {
        dropdbitemz = dropdbitem(ctx: context);
        return Visibility(
          visible: personalvisible,
          child: SizedBox(
            width: 180,
            child: Card(
              child: Column(
                children: dropdbitemz
                    .map((e) => SizedBox(
                        width: e['size'],
                        child: GestureDetector(
                          onTap: e['action'],
                          child: MouseRegion(
                            onHover: (r) {
                              mainController.changeonhoverdropPersonal(
                                  ctx: context, x: dropdbitemz.indexOf(e));
                            },
                            child: TweenMZ.translatex(
                              begin: -100.0,
                              end: 0.0,
                              duration: 100 * dropdbitemz.indexOf(e),
                              child0: Card(
                                color: Colors.indigoAccent.withOpacity(0.7),
                                child: GetBuilder<ThemeController>(
                                  init: themeController,
                                  builder: (_) => Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      e['label'],
                                      style: ThemeMZ()
                                          .theme()
                                          .textTheme
                                          .labelMedium,
                                    ),
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
      },
    );
  }
}

class Notificationm extends StatelessWidget {
  Notificationm({super.key});
  ThemeController themeController = Get.find();
  MainController mainController = Get.find();
  static double dropend = -150.0;
  static List notifilist = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        init: mainController,
        builder: (_) => TweenMZ.translatey(
              begin: -150.0,
              end: dropend,
              duration: 200,
              child0: GetBuilder<ThemeController>(
                init: themeController,
                builder: (_) => Card(
                  color: Colors.grey,
                  elevation: 25,
                  child: Column(
                    children: notifilist
                        .map((e) => SizedBox(
                            width: 150,
                            child: TweenMZ.translatex(
                              begin: -150.0,
                              duration: (notifilist.indexOf(e) + 1) * 200,
                              end: dropend,
                              child0: GestureDetector(
                                onTap: e['action'],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    e['label'],
                                    style:
                                        ThemeMZ().theme().textTheme.labelMedium,
                                  ),
                                ),
                              ),
                            )))
                        .toList(),
                  ),
                ),
              ),
            ));
  }
}

AppBarMZ(ctx) {
  MainController mainController = Get.find();
  ThemeController themeController = Get.find();

  return AppBar(
    title: GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Text(Home.pages[HomePage.selectedPage]['label'])),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    flexibleSpace: GetBuilder<ThemeController>(
      init: themeController,
      builder: (_) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: ThemeMZ().appbarbk())),
      ),
    ),
    actions: [
      // GetBuilder<MainController>(
      //     init: mainController,
      //     builder: (_) {
      //       HomePage.notifitask = 0;
      //       Notificationm.notifilist.clear();
      //       for (var i in DB.tasktable) {
      //         if (i['notifi'] == 1 &&
      //             i['userstask_id'].contains(DB.userstable[DB.userstable
      //                 .indexWhere((element) =>
      //                     element['username'] == Home.logininfo)]['user_id'])) {
      //           HomePage.notifitask++;
      //         }
      //       }
      //       if (HomePage.notifitask > 0) {
      //         Notificationm.notifilist.add({
      //           'label': "لديك مهام حالية ${HomePage.notifitask}",
      //           'action': () async {
      //             await MainController().opennotifi();
      //           }
      //         });
      //       }
      //       return IconButton(
      //           onPressed: () {
      //             PersonPanel.dropend = -150.0;
      //           },
      //           icon: HomePage.notifitask == 0
      //               ? const Icon(Icons.notifications)
      //               : Stack(
      //                   children: [
      //                     const Icon(
      //                       Icons.notifications,
      //                       color: Colors.orangeAccent,
      //                     ),
      //                     Text(HomePage.notifitask.toString())
      //                   ],
      //                 ));
      //     }),
      Visibility(
          visible: checkifUserisAdmin(
              usertable: DB.userstable,
              userid: DB.userstable[DB.userstable.indexWhere(
                      (element) => element['username'] == Home.logininfo)]
                  ['user_id']),
          child: IconButton(
              onPressed: () {
                showusersonline(ctx);
              },
              icon: Icon(Icons.online_prediction))),
      IconButton(
          onPressed: () {
            mainController.personalpanelshow();
          },
          icon: const Icon(Icons.settings)),
      IconButton(
          onPressed: () {
            themeController.changemode();
          },
          icon: GetBuilder<ThemeController>(
              init: themeController,
              builder: (_) => TweenMZ.rotate(
                  end: themeController.iconmodeEndrotate,
                  duration: 200,
                  child0: Icon(ThemeMZ().modeicon())))),
    ],
  );
}

showusersonline(ctx) async {
  try {
    List users = [];
    String userson = 'المستخدمون الذين قاموا بتسجيل الدخول حاليا';
    var t = await DB()
        .customquery(query: 'select fullname from users where logstatus=1');
    for (var i in t) {
      users.add(i[0]);
    }
    for (var i in users) {
      userson += '\n$i';
    }
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            content: Text(userson),
          );
        });
  } catch (e) {}
}
