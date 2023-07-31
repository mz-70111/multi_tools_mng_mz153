// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/01_homepage.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/remind.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

class MainController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    update();
  }

  passvis() {
    LogIn.iconpassvis = LogIn.iconpassvis == Icons.visibility_off
        ? Icons.visibility
        : Icons.visibility_off;
    LogIn.obscuretext = LogIn.obscuretext == true ? false : true;
    update();
  }

  personalpanelshow() {
    PersonPanel.dropend = PersonPanel.dropend == 0.0 ? -150.0 : 0.0;
    PersonPanel.personalvisible =
        PersonPanel.personalvisible == true ? false : true;

    Get.back();
    update();
  }

  notifilistshow() {
    Notificationm.dropend = Notificationm.dropend == 0.0 ? -150.0 : 0.0;
    Get.back();
    update();
  }

 

  opennotifi() async {
    Home.selectall = false;
    for (var i in Home.searchlist) {
      i['check'] = false;
    }
    for (var i in DB.tasktable) {
      if (i['status'] == 0 &&
          i['userstask_id'].contains(DB.userstable[DB.userstable.indexWhere(
                  (element) => element['username'] == Home.logininfo)]
              ['user_id'])) {
        Home.searchlist[Home.searchlist
                .indexWhere((element) => element['task_id'] == i['task_id'])]
            ['check'] = true;
      }
    }
    await DBController()
        .gettable(list: Tasks.mylista, table: 'tasks', tableid: 'task_id');
    await homemaincontent(4);
    update();
  }

  navbar(x) async {
    cloasedp();
    Get.back();
    for (var i in BottomNBMZ.pageslist) {
      i['color'] = [
        Colors.transparent,
        Colors.transparent,
      ];
      i['border'] = Colors.transparent;
      i['rotate'] = i['irotate'] = 0.0 * pi / 180;
      i['rize'] = 0.0;
    }
    BottomNBMZ.pageslist[x]['color'] = [
      Colors.transparent,
      Colors.indigoAccent,
      Colors.transparent,
    ];
    BottomNBMZ.pageslist[x]['border'] = Colors.indigo;
    BottomNBMZ.pageslist[x]['rotate'] = 45.0 * pi / 180;
    BottomNBMZ.pageslist[x]['irotate'] = -45.0 * pi / 180;
    BottomNBMZ.pageslist[x]['rize'] = -25.0;
    HomePage.selectedPage = x;

    PersonPanel.dropend = -150;
    Notificationm.dropend = -150;
    // if (Whattodo.closebs == 1) {
    //   Get.back();
    // }
    update();
  }

  homemaincontent(x) async {
    cloasedp();
    HomePage.selectedPage = x;
    for (var i in BottomNBMZ.pageslist) {
      i['color'] = [
        Colors.transparent,
        Colors.transparent,
      ];
      i['border'] = Colors.transparent;
      i['rotate'] = i['irotate'] = 0.0 * pi / 180;
      i['rize'] = 0.0;

      for (var i in Home.pages) {
        i['size'] = 50.0;
      }
    }

    PersonPanel.dropend = -150;
    Notificationm.dropend = -150;
    // if (Whattodo.closebs == 1) {
    //   Get.back();
    // }
    update();
  }

  searchvis() {
    Home.searchvis = Home.searchvis == true ? false : true;
    update();
  }

  search({word, list, required List range}) async {
    for (var i in list) {
      i['visible'] = false;
    }
    for (var e in list) {
      for (var i in range) {
        try {
          (e[i].toString().contains(word) ||
                  e['createdate'].toString().substring(0, 10).contains(word))
              ? e['visible'] = true
              : null;
        } catch (e) {
          null;
        }
      }
    }
    update();
  }

  int xyz = 0;
  sort({table, sortby}) async {
    xyz = xyz == 0 ? 1 : 0;
    xyz == 0
        ? await table.sort((a, b) {
            return a[sortby].toString().compareTo(b[sortby].toString());
          })
        : await table.sort((b, a) {
            return a[sortby].toString().compareTo(b[sortby].toString());
          });

    update();
    return table;
  }

  sortx({table, sortby}) async {
    xyz == 0
        ? await table.sort((a, b) {
            return a.toString().compareTo(b.toString());
          })
        : await table.sort((b, a) {
            return a.toString().compareTo(b.toString());
          });

    update();
    return table;
  }

  deleteuserfortask(index) {
    Tasks.usersfortaskswidget.removeAt(index);
    update();
  }

  selectuser(value, index) {
    Tasks.usersfortaskswidget[index]['name'] = value;
    update();
  }

  taskduration(x) {
    Tasks.duration = x;
    update();
  }

  chooseoffice(x) async {
    Tasks.sortbydatebegin = DateTime.parse('2022-10-01');
    Tasks.sortbydateend = DateTime.now();
    if (x == 'مخصص') {
      null;
    } else if (x == 'جميع المكاتب') {
      MYPAGE.selectedOffice = x;
      Home.selectall = true;
      for (var i in Home.searchlist) {
        i['check'] = true;
      }
    } else {
      Home.selectall = false;
      MYPAGE.selectedOffice = x;
      for (var i in Home.searchlist) {
        i['check'] = false;
        if (x == i['officename']) {
          i['check'] = true;
        }
      }
    }
    for (var i in Home.searchlist) {
      if (i.keys.toList().first == 'user_id') {
        for (var j in Home.searchlist) {
          if (i['check'] == true) {
            if (j.keys.toList().first == 'task_id') {
              if (j['userstask_name'].contains(i['fullname'])) {
                j['check'] = true;
              }
            }
            if (j.keys.toList().first == 'todo_id') {
              if (j['createby'] == i['fullname']) {
                j['check'] = true;
              }
            }
            if (j.keys.toList().first == 'remind_id') {
              if (j['createby'] == i['fullname']) {
                j['check'] = true;
              }
            }
          }
        }
      }
    }
    try {
      for (var i in Home.searchlist) {
        if (i.keys.toList().first == 'office_id') {
          for (var j in Home.searchlist) {
            if (i['check'] == true) {
              if (i['users'].contains(j['user_id'])) {
                j['check'] = true;
              }
              if (i['office_id'] == j['task_office_id']) {
                j['check'] = true;
              }
              if (i['office_id'] == j['todo_office_id']) {
                j['check'] = true;
              }
              if (i['office_id'] == j['remind_office_id']) {
                j['check'] = true;
              }
            }
          }
        }
      }
    } catch (r) {
      print(r);
    }
    update();
  }

  directsendTask({ctx, officeid, e}) async {
    String mymsg = Tasks.mymsgTask(e: e);
    mymsg +=
        'قام بإرسال الإشعار ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}';

    showDialog(
        context: ctx,
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,
              title: Text(
                  "إرسال اشعار التلغرام التالي الى ${DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == e['task_office_id'])]['officename']}"),
              content: Tasks.taskofficeNameselected == null
                  ? const Text("لست مشرفا في أي مكتب")
                  : Text(mymsg),
              actions: [
                IconButton(
                    onPressed: () async {
                      Tasks.sendtask(
                          msg: mymsg,
                          chatid: DB.officetable[DB.officetable.indexWhere(
                              (element) =>
                                  element['office_id'] ==
                                  e['task_office_id'])]['chatid']);
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          );
        });
  }

  autosendnotifitasks() async {
    String mymsg = '';
    int timenow = DateTime.now().hour;
    if (timenow == 09 || timenow == 9) {
      await DBController().gettable(
          list: DB.officetable, table: 'office', tableid: 'office_id');
      for (var i in DB.officetable) {
        List usershavetask = [];
        mymsg = '';
        if (i['sendstatus'] == 0) {
          mymsg += 'مهمات ${i['officename']}\n';
          if (i['notifi'] == 1) {
            for (var j in DB.tasktable) {
              var send = 0;
              for (var t in i['users']) {
                if (j['userstask_id'].contains(t)) {
                  send++;
                  if (j['notifi'] == 1) {
                    usershavetask.add(t);
                  }
                }
              }

              if (send > 0 && j['notifi'] == 1) {
                try {
                  List userstaskname = [];
                  for (var ii in j['userstask_id']) {
                    userstaskname.add(DB.userstable[DB.userstable
                            .indexWhere((element) => element['user_id'] == ii)]
                        ['fullname']);
                  }

                  mymsg += Tasks.mymsgTask(e: j);
                } catch (e) {
                  null;
                }
              }
            }
          }
          for (var p in i['users']) {
            if (!usershavetask.contains(p)) {
              if (checkifuserSupervisor(officeid: i['office_id'], userid: p) ==
                  false) {
                mymsg +=
                    ' * ${DB.userstable[DB.userstable.indexWhere((element) => element['user_id'] == p)]['fullname']} ليس لديه مهمة حاليا\n';
                mymsg += '--------------\n';
              }
            }
          }
          mymsg += 'تم ارسال الاشعار بشكل تلقائي';
        }
        if (mymsg.isNotEmpty) {
          Tasks.sendtask(msg: mymsg, chatid: i['chatid']);
        }
        try {
          await DB().customquery(query: 'update office set sendstatus=1');
        } catch (e) {
          null;
        }
      }
    } else {
      try {
        await DB().customquery(query: 'update office set sendstatus=0');
      } catch (e) {
        null;
      }
    }
    Future.delayed(const Duration(hours: 1), () => DBController().onReady());
  }

  getCert({required String host}) async {
    var getExpiredate = await Process.run('Powershell.exe', [
      '''
# Ignore SSL Warning
[Net.ServicePointManager]::ServerCertificateValidationCallback = { \$true }
# Create Web Http request to URI
\$webRequest = [Net.HttpWebRequest]::Create("$host")
# Retrieve the Information for URI
\$webRequest.GetResponse() | Out-NULL
# Get SSL Certificate Expiration Date
\$webRequest.ServicePoint.Certificate.GetExpirationDateString()
'''
    ]);
    String result = '';
    result = getExpiredate.stdout;
    result = result.substring(0, result.indexOf(' '));
    result = result.replaceAll('/', '-');
    List y = result.split('-');
    y[0].length == 1 ? y[0] = '0${y[0]}' : null;
    y[1].length == 1 ? y[1] = '0${y[1]}' : null;
    String MM = y[0];
    String dd = y[1];
    String yy = y[2];
    y[0] = yy;
    y[1] = MM;
    y[2] = dd;
    result = y.join('-');
    return result;
  }

//additem
  addItemMainController(
      {page,
      listofFeildmz,
      itemnameController,
      required ScrollController scrollcontroller}) async {
    for (var i in listofFeildmz) {
      i['error'] = null;
    }
    var checkdublicateoffice = false;
    bool duplicateCheck = true;
    ADDEDITINFOItem.errormsg = null;
    if (itemnameController.isEmpty) {
      listofFeildmz[0]['error'] =
          ADDEDITINFOItem.errormsg = 'لا يمكن ان يكون الاسم فارغا';
      ADDEDITINFOItem.firstpage = true;
    } else if (page == Office) {
      try {
        AddPanel.wait = true;

        update();
        await DBController().addoffice();
        for (var i in Office.offices) {
          i['controller'].text = '';
          i['error'] = null;
        }
        Get.back();
      } catch (e) {
        "$e".contains('timed out')
            ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
            : "$e".contains('Duplicat')
                ? {
                    ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                    ADDEDITINFOItem.firstpage = true
                  }
                : ADDEDITINFOItem.errormsg = "لا يمكن الوصول للمخدم'";
        ADDEDITINFOItem.firstpage = true;
      }
      AddPanel.wait = false;

      update();
    } else if (page == Employ) {
      checkdublicateoffice = false;
      if (Employ.employs[1]['controller'].text.isEmpty) {
        Employ.employs[1]['error'] =
            ADDEDITINFOItem.errormsg = 'لا يمكن ان يكون الاسم  فارغا';
        ADDEDITINFOItem.firstpage = true;
      } else if (Employ.employs[2]['controller'].text.isEmpty) {
        Employ.employs[2]['error'] =
            ADDEDITINFOItem.errormsg = 'لا يمكن ان يكون حقل كلمة المرور  فارغا';
        ADDEDITINFOItem.firstpage = true;
      } else if (Employ.employs[2]['controller'].text !=
          Employ.employs[3]['controller'].text) {
        Employ.employs[2]['error'] = Employ.employs[3]['error'] =
            ADDEDITINFOItem.errormsg = "كلمة مرور غير متطابقة";
        ADDEDITINFOItem.firstpage = true;
      } else if (Employ.privilege.isNotEmpty) {
        ch:
        for (var i in Employ.privilege) {
          for (var j in Employ.privilege) {
            if (i['office'] == j['office'] &&
                Employ.privilege.indexOf(i) != Employ.privilege.indexOf(j)) {
              checkdublicateoffice = true;
              ADDEDITINFOItem.errormsg = "لا يمكن اعطاء صلاحيتين في مكتب واحد";
              scrollcontroller
                  .jumpTo(scrollcontroller.position.minScrollExtent);
              break ch;
            }
          }
        }
        if (checkdublicateoffice == false) {
          try {
            AddPanel.wait = true;
            update();
            for (var i in Employ.privilege) {
              for (var l in Home.searchlist) {
                if (l['officename'] == i['office']) {
                  l['check'] = true;
                }
              }
            }
            await DBController().adduser();
            Get.back();
          } catch (e) {
            "$e".contains('timed out')
                ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? {
                        ADDEDITINFOItem.errormsg = 'اسم  محجوز مسبقا',
                        ADDEDITINFOItem.firstpage = true
                      }
                    : ADDEDITINFOItem.errormsg = "لا يمكن الوصول للمخدم'";
          }
          AddPanel.wait = false;
          update();
        }
      } else {
        if (checkdublicateoffice == false) {
          try {
            AddPanel.wait = true;
            update();
            for (var i in Employ.privilege) {
              for (var l in Home.searchlist) {
                if (l['officename'] == i['office']) {
                  l['check'] = true;
                }
              }
            }
            await DBController().adduser();
            Get.back();
          } catch (e) {
            "$e".contains('timed out')
                ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? {
                        ADDEDITINFOItem.errormsg = 'اسم  محجوز مسبقا',
                        ADDEDITINFOItem.firstpage = true
                      }
                    : ADDEDITINFOItem.errormsg = "لا يمكن الوصول للمخدم'";
          }
          AddPanel.wait = false;
          update();
        }
      }
    } else if (page == Tasks) {
      ADDEDITINFOItem.errormsg = null;
      if (Tasks.usersfortaskswidget.isEmpty) {
        ADDEDITINFOItem.errormsg =
            "لا يمكن أن تنشئ مهمة دون ان تعين لها موظف واحد على الأقل";
      } else {
        h:
        for (var i in Tasks.usersfortaskswidget) {
          for (var j in Tasks.usersfortaskswidget) {
            if (i['name'] == j['name'] &&
                Tasks.usersfortaskswidget.indexOf(i) !=
                    Tasks.usersfortaskswidget.indexOf(j)) {
              duplicateCheck = true;
              ADDEDITINFOItem.errormsg =
                  "لايمكن تعيين نفس الموظف للمهمة نفسها مرتين";
              break h;
            } else {
              duplicateCheck = false;
            }
          }
        }
        if (duplicateCheck == false) {
          try {
            AddPanel.wait = true;
            update();
            for (var i in DB.tasktable) {
              for (var l in Home.searchlist) {
                if (l['office_id'] == i['task_office_id']) {
                  l['check'] = true;
                }
              }
            }
            await DBController().addtasks();
            for (var i in Tasks.tasks) {
              i['controller'].text = '';
            }
            Get.back();
          } catch (e) {
            "$e".contains('timed out')
                ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? {
                        ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                        ADDEDITINFOItem.firstpage = true
                      }
                    : ADDEDITINFOItem.errormsg = "لا يمكن الوصول للمخدم'";
          }
          AddPanel.wait = false;
          update();
        }
      }
    } else if (page == Whattodo) {
      ADDEDITINFOItem.errormsg = null;
      try {
        AddPanel.wait = true;
        update();
        for (var i in DB.todotable) {
          for (var l in Home.searchlist) {
            if (l['office_id'] == i['todo_office_id']) {
              l['check'] = true;
            }
          }
        }
        await DBController().addtodo();
        for (var i in Whattodo.todos) {
          i['controller'].text = '';
        }
        Get.back();
      } catch (e) {
        "$e".contains('timed out')
            ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
            : "$e".contains('Duplicat')
                ? {
                    ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                    ADDEDITINFOItem.firstpage = true
                  }
                : ADDEDITINFOItem.errormsg = "$e";
      }
      AddPanel.wait = false;
      update();
    } else if (page == Remind) {
      ADDEDITINFOItem.errormsg = null;
      try {
        AddPanel.wait = true;
        update();
        for (var i in DB.todotable) {
          for (var l in Home.searchlist) {
            if (l['office_id'] == i['remind_office_id']) {
              l['check'] = true;
            }
          }
        }
        await DBController().addremind();
        for (var i in Remind.reminds) {
          i['controller'].text = '';
        }
        Get.back();
      } catch (e) {
        "$e".contains('timed out')
            ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
            : "$e".contains('Duplicat')
                ? {
                    ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                    ADDEDITINFOItem.firstpage = true
                  }
                : ADDEDITINFOItem.errormsg = "$e";
      }
      AddPanel.wait = false;
      update();
    }
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];
    update();
  }

  deleteItemMainController({e, required ctx, page}) async {
    MainController mainController = Get.find();
    bool deletewait = false;
    String errormsg = '';
    showDialog(
        context: ctx,
        builder: (_) {
          String name = '';
          try {
            page == Office
                ? name = Office.mylista[Office.mylista.indexWhere((element) => element['office_id'] == e['office_id'])]
                    ['officename']
                : page == Employ
                    ? name = Employ.mylista[Employ.mylista
                            .indexWhere((element) => element['user_id'] == e['user_id'])]
                        ['fullname']
                    : page == Tasks
                        ? name = Tasks.mylista[Tasks.mylista.indexWhere((element) => element['task_id'] == e['task_id'])]
                            ['taskname']
                        : page == Whattodo
                            ? name = Whattodo.mylista[Whattodo.mylista
                                    .indexWhere((element) => element['todo_id'] == e['todo_id'])]
                                ['todoname']
                            : page == Remind
                                ? name = Remind.mylista[Remind.mylista.indexWhere((element) => element['remind_id'] == e['remind_id'])]['remindname']
                                : null;
          } catch (r) {
            null;
          }
          return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                scrollable: true,
                title: Text('هل أنت متأكد من حذف "$name"'),
                actions: [
                  GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Column(
                      children: [
                        Text(errormsg),
                        Row(
                          children: [
                            Visibility(
                              visible: !deletewait,
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                            ),
                            Visibility(
                                visible: !deletewait,
                                child: IconButton(
                                    onPressed: () async {
                                      deletewait = true;
                                      errormsg = '';
                                      update();
                                      try {
                                        page == Office
                                            ? await DBController().deleteoffice(
                                                id: e['office_id'])
                                            : page == Employ
                                                ? await DBController()
                                                    .deleteuser(
                                                        id: e['user_id'])
                                                : page == Tasks
                                                    ? await DBController()
                                                        .deletetask(
                                                            id: e['task_id'])
                                                    : page == Whattodo
                                                        ? await DBController()
                                                            .deletetodo(
                                                                id: e[
                                                                    'todo_id'])
                                                        : page == Remind
                                                            ? await DBController()
                                                                .deleteremind(
                                                                    id: e[
                                                                        'remind_id'])
                                                            : null;

                                        Get.back();
                                        Get.back();
                                      } catch (e) {
                                        "$e".contains('timed out')
                                            ? errormsg = 'لا يمكن الوصول للمخدم'
                                            : "$e".contains('Duplicat')
                                                ? errormsg =
                                                    'اسم المستخدم  او الاسم الكامل محجوز مسبقا'
                                                : "$e".contains(
                                                        'task_office_id')
                                                    ? errormsg =
                                                        "لا يمكن حذف المكتب يوجد مهمات مرتبطة معه\n قم بحذف المهمات المرتبطة مع المكتب او تعديلها لمكتب آخر لتتكمن من الحذف"
                                                    : errormsg = "$e";
                                      }
                                      deletewait = false;
                                      update();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: deletewait,
                      child: const LinearProgressIndicator(
                        color: Colors.redAccent,
                      ))
                ],
              ));
        });
  }

  showeditpanel() {
    ADDEDITINFOItem.errormsg = null;
    Editpanel.savevisible = true;
    ADDEDITINFOItem.addeditvisible = true;
    update();
  }

  editItemMainController({e, page, listofFeildmz}) async {
    for (var i in listofFeildmz) {
      i['error'] = null;
    }
    var checkdublicateoffice = false;
    var checkdublicateuseroftask = false;
    ADDEDITINFOItem.errormsg = null;
    for (var i in listofFeildmz) {
      i['error'] = null;
    }
    if (listofFeildmz[0]['controller'].text.isEmpty) {
      listofFeildmz[0]['error'] =
          ADDEDITINFOItem.errormsg = 'لا يمكن ان يكون اسم فارغا';
      ADDEDITINFOItem.firstpage = true;
      ADDEDITINFOItem.addeditvisible = true;
    } else {
      if (page == Office) {
        try {
          Editpanel.wait = true;
          update();
          await DBController().editoffice(id: e['office_id']);
          ADDEDITINFOItem.addeditvisible = false;
          Editpanel.savevisible = false;
        } catch (e) {
          "$e".contains('timed out')
              ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
              : "$e".contains('Duplicat')
                  ? {
                      ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                      ADDEDITINFOItem.firstpage = true
                    }
                  : ADDEDITINFOItem.errormsg = "$e";
          ADDEDITINFOItem.addeditvisible = true;
          Editpanel.savevisible = true;
        }
        Editpanel.wait = false;
        ADDEDITINFOItem.firstpage = true;
        update();
      } else if (page == Employ) {
        if (Employ.employs[1]['controller'].text.isEmpty) {
          Employ.employs[1]['error'] =
              ADDEDITINFOItem.errormsg = 'لا يمكن ان يكون الاسم  فارغا';
          ADDEDITINFOItem.firstpage = true;
        } else if (Employ.employs[2]['controller'].text !=
            Employ.employs[3]['controller'].text) {
          Employ.employs[2]['error'] = Employ.employs[3]['error'] =
              ADDEDITINFOItem.errormsg = "كلمة مرور غير متطابقة";
          ADDEDITINFOItem.firstpage = true;
        } else if (Employ.privilege.isNotEmpty) {
          ch:
          for (var i in Employ.privilege) {
            for (var j in Employ.privilege) {
              if (i['office'] == j['office'] &&
                  Employ.privilege.indexOf(i) != Employ.privilege.indexOf(j)) {
                checkdublicateoffice = true;
                ADDEDITINFOItem.errormsg =
                    "لا يمكن اعطاء صلاحيتين في مكتب واحد";
                break ch;
              }
            }
          }
          if (checkdublicateoffice == false) {
            try {
              Editpanel.wait = true;
              update();
              await DBController().deleteprev(id: e['user_id']);
              for (var i in Employ.privilege) {
                for (var l in Home.searchlist) {
                  if (l['officename'] == i['office']) {
                    l['check'] = true;
                  }
                }
              }
              await DBController().edituser(id: e['user_id']);
              ADDEDITINFOItem.addeditvisible = false;
              Editpanel.savevisible = false;
            } catch (e) {
              "$e".contains('timed out')
                  ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                  : "$e".contains('Duplicat')
                      ? {
                          ADDEDITINFOItem.errormsg =
                              'اسم المستخدم  او الاسم الكامل محجوز مسبقا',
                          ADDEDITINFOItem.firstpage = true
                        }
                      : ADDEDITINFOItem.errormsg = "$e";
              ADDEDITINFOItem.addeditvisible = true;
              Editpanel.savevisible = true;
            }
            Editpanel.wait = false;
            ADDEDITINFOItem.firstpage = true;
            update();
          }
        } else {
          try {
            Editpanel.wait = true;
            update();
            await DBController().deleteprev(id: e['user_id']);
            for (var i in Employ.privilege) {
              for (var l in Home.searchlist) {
                if (l['officename'] == i['office']) {
                  l['check'] = true;
                }
              }
            }
            await DBController().edituser(id: e['user_id']);
            ADDEDITINFOItem.addeditvisible = false;
            Editpanel.savevisible = false;
          } catch (e) {
            "$e".contains('timed out')
                ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? {
                        ADDEDITINFOItem.errormsg =
                            'اسم المستخدم  او الاسم الكامل محجوز مسبقا',
                        ADDEDITINFOItem.firstpage = true
                      }
                    : ADDEDITINFOItem.errormsg = "$e";
            ADDEDITINFOItem.addeditvisible = true;
            Editpanel.savevisible = true;
          }
          Editpanel.wait = false;
          ADDEDITINFOItem.firstpage = true;
          update();
        }
      } else if (page == Tasks) {
        Tasks.extratimecontrollererror = null;
        if (Tasks.usersfortaskswidget.isEmpty) {
          ADDEDITINFOItem.errormsg =
              "لا يمكن أن تنشئ مهمة دون ان تعين لها موظف واحد على الأقل";
        } else {
          if (Tasks.extratimecontroller.text.isEmpty) {
            Tasks.extratimecontroller.text = 0.toString();
          }
          h:
          for (var i in Tasks.usersfortaskswidget) {
            for (var j in Tasks.usersfortaskswidget) {
              if (i['name'] == j['name'] &&
                  Tasks.usersfortaskswidget.indexOf(i) !=
                      Tasks.usersfortaskswidget.indexOf(j)) {
                checkdublicateuseroftask = true;
                ADDEDITINFOItem.errormsg =
                    "لايمكن تعيين نفس الموظف للمهمة نفسها مرتين";
                break h;
              } else {
                checkdublicateuseroftask = false;
              }
            }
          }
          if (checkdublicateuseroftask == false) {
            Tasks.extratimecontroller.text.isEmpty ? "0" : null;
            try {
              Editpanel.wait = true;
              update();
              await DBController().edittask(id: e['task_id']);
              ADDEDITINFOItem.addeditvisible = false;
              Editpanel.savevisible = false;
              ADDEDITINFOItem.firstpage = true;
            } catch (e) {
              "$e".contains('timed out')
                  ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
                  : "$e".contains('Duplicat')
                      ? {
                          ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                          ADDEDITINFOItem.firstpage = true
                        }
                      : "$e".contains('FormatExcep')
                          ? ADDEDITINFOItem.errormsg =
                              Tasks.extratimecontrollererror =
                                  "أدخل قيمة عددية صحيحة"
                          : ADDEDITINFOItem.errormsg = "$e";
              ADDEDITINFOItem.addeditvisible = true;
              Editpanel.savevisible = true;
            }
            Editpanel.wait = false;
            update();
          }
        }
      } else if (page == Whattodo) {
        try {
          Editpanel.wait = true;
          update();
          await DBController().edittodo(id: e['todo_id']);
          ADDEDITINFOItem.addeditvisible = false;
          Editpanel.savevisible = false;
          ADDEDITINFOItem.firstpage = true;
        } catch (e) {
          "$e".contains('timed out')
              ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
              : "$e".contains('Duplicat')
                  ? {
                      ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                      ADDEDITINFOItem.firstpage = true
                    }
                  : ADDEDITINFOItem.errormsg = "$e";
          ADDEDITINFOItem.addeditvisible = true;
          Editpanel.savevisible = true;
        }
        Editpanel.wait = false;
        update();
      } else if (page == Remind) {
        try {
          Editpanel.wait = true;
          update();
          await DBController().editremind(id: e['remind_id']);
          ADDEDITINFOItem.addeditvisible = false;
          Editpanel.savevisible = false;
          ADDEDITINFOItem.firstpage = true;
        } catch (e) {
          "$e".contains('timed out')
              ? ADDEDITINFOItem.errormsg = 'لا يمكن الوصول للمخدم'
              : "$e".contains('Duplicat')
                  ? {
                      ADDEDITINFOItem.errormsg = 'اسم محجوز مسبقا',
                      ADDEDITINFOItem.firstpage = true
                    }
                  : ADDEDITINFOItem.errormsg = "$e";
          ADDEDITINFOItem.addeditvisible = true;
          Editpanel.savevisible = true;
        }
        Editpanel.wait = false;
        update();
      }
    }
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];
    update();
  }

//all
  switchcase({x, item}) {
    item == Employ.enable ? Employ.enable = x : null;
    update();
  }

  checkboxadmin(x) {
    Employ.admin = x;
    update();
  }

  checkboxchngpass(x) {
    Employ.mustchgpass = x;
    update();
  }

  checkboxpbx(x) {
    Employ.pbx = x;
    update();
  }

  checkboxaddping(x) {
    Employ.addping = x;
    update();
  }

  checkboxaddremind(x) {
    Employ.addremind = x;
    update();
  }

  checkboxaddtodo(x) {
    Employ.addtodo = x;
    update();
  }

  checkboxSelectallHomeSearch(x) {
    Home.selectall = x;
    for (var i in Home.searchlist) {
      i['check'] = x;
    }
    update();
  }

  checkboxsearch(x, index) async {
    Home.searchlist[index]['check'] = x;
    if (x == false) {
      Home.selectall = false;
    }
    try {
      for (var i in Home.searchlist) {
        if (i.keys.toList().first == 'user_id') {
          for (var j in Home.searchlist) {
            if (i['check'] == true) {
              if (j.keys.toList().first == 'task_id') {
                if (j['userstask_name'].contains(i['fullname'])) {
                  if (calcdaterang(date: j['createdate']) == true) {
                    j['check'] = true;
                  } else {
                    j['check'] = false;
                  }
                }
              }
              if (j.keys.toList().first == 'todo_id') {
                if (j['createby'] == i['fullname']) {
                  j['check'] = true;
                }
              }
            }
          }
        }
      }
    } catch (r) {
      null;
    }
    try {
      for (var i in Home.searchlist) {
        if (i.keys.toList().first == 'office_id') {
          for (var j in Home.searchlist) {
            if (i['check'] == true) {
              if (i['users'].contains(j['user_id'])) {
                j['check'] = true;
              }
              if (i['office_id'] == j['task_office_id']) {
                if (calcdaterang(date: j['createdate']) == true) {
                  j['check'] = true;
                } else {
                  j['check'] = false;
                }
              }
              if (i['office_id'] == j['todo_office_id']) {
                j['check'] = true;
              }
              if (i['office_id'] == j['remind_office_id']) {
                j['check'] = true;
              }
            }
          }
        }
      }
    } catch (r) {
      print(r);
      null;
    }
    update();
  }

  calcdaterang({date}) {
    bool result = false;
    String resultstbegin =
        Tasks.sortbydatebegin.toString().substring(0, 10).replaceAll('-', '');
    String resultstend =
        Tasks.sortbydateend.toString().substring(0, 10).replaceAll('-', '');
    if (int.parse(resultstbegin) <=
            int.parse(date.toString().substring(0, 10).replaceAll('-', '')) &&
        int.parse(resultstend) >=
            int.parse(date.toString().substring(0, 10).replaceAll('-', ''))) {
      result = true;
    }
    return result;
  }
//E

  showpassAdduser() {
    Employ.employs[2]['obscuretext'] = Employ.employs[3]['obscuretext'] =
        Employ.employs[2]['obscuretext'] == true ? false : true;
    Employ.employs[2]['icon'] = Employ.employs[3]['icon'] =
        Employ.employs[2]['icon'] == Icons.visibility_off
            ? Icons.visibility
            : Icons.visibility_off;
    update();
  }

  addprivilege({required ScrollController scrollController}) async {
    if (DB.officetable.isNotEmpty) {
      Employ.privilege.add({
        'privilege': Employ.permission[0],
        'office': DB.officetable[0]['officename']
      });
      scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
    } else {
      ADDEDITINFOItem.errormsg = 'لم تقم بإضافة أي مكتب';
    }
    update();
  }

  deleteprivilege(index) {
    Employ.privilege.removeAt(index);
    update();
  }

  convertimagestodoTocode({image}) async {
    if (image.runtimeType == Image) {
      return Whattodo.imagcode[Whattodo.x];
    } else {
      Uint8List imagebytes = await image.readAsBytes();
      String base64string = base64.encode(imagebytes);
      return base64string;
    }
  }

  convertimagestodoTodecode({image}) {
    Uint8List imagei;
    image =
        "${image.toString().length % 4 != 0 ? image.toString().substring(0, image.toString().length - image.toString().length % 4) : image}";
    imagei = base64.decode(image);
    return Image.memory(imagei);
  }

  deleteimagetodo(index) {
    if (Whattodo.images[index].runtimeType == Image) {
      Whattodo.imagcode.removeAt(index);
    }
    Whattodo.images.removeAt(index);
    update();
  }

  selectpriv(value, index) {
    Employ.privilege[index]['privilege'] = value;
    update();
  }

  selectoffice(value, index) {
    Employ.privilege[index]['office'] = value;
    update();
  }

//office
  changeofficeNotifi(x) {
    Office.notifi = x;
    update();
  }

  changeonhoverOfficecolor(x) {
    Office.colorpicklist[x]['size'] = 35.0;
    update();
  }

  changeonExitOfficecolor(x) {
    Office.colorpicklist[x]['size'] = 30.0;
    update();
  }

  selectOfficecolor(x) {
    Office.selectcolor = x;
    Get.back();
    update();
  }

  gotousers({list, office}) async {
    for (var i in Home.searchlist) {
      i['check'] = false;
      update();
    }
    Home.selectall = false;
    for (var i in list) {
      Home.searchlist[Home.searchlist
          .indexWhere((element) => element['user_id'] == i)]['check'] = true;
    }
    Home.searchlist[Home.searchlist
            .indexWhere((element) => element['officename'] == office)]
        ['check'] = true;

    for (var i in Home.searchlist) {
      if (i.keys.toList().first == 'office_id' && i['check'] == true) {
        for (var j in Home.searchlist) {
          if (j.keys.toList().first == 'user_id') {
            ini:
            for (var c in j['office']) {
              if (c == i['office_id']) {
                j['check'] = true;
                break ini;
              }
            }
          }
        }
      }
      if (i.keys.toList().first == 'user_id' && i['check'] == true) {
        for (var j in Home.searchlist) {
          if (j.keys.toList().first == 'todo_id') {
            if (j['createby'] == i['username']) {
              j['check'] = true;
            }
          }
          if (j.keys.toList().first == 'task_id') {
            for (var l in j['userstask_name']) {
              if (l == i['username']) {
                j['check'] = true;
              }
            }
          }
        }
      }
    }
    await DBController()
        .gettable(list: Employ.mylista, table: 'users', tableid: 'user_id');
    homemaincontent(3);
  }
//endoffice

//tasks

  checkifuserSupervisor({officeid, userid}) {
    bool usersupervisor = false;
    for (var i = 0;
        i <
            DB
                .userstable[DB.userstable
                        .indexWhere((element) => element['user_id'] == userid)]
                    ['privilege']
                .length;
        i++) {
      if (DB.userstable[DB.userstable
                  .indexWhere((element) => element['user_id'] == userid)]
              ['privilege'][i] ==
          'مشرف') {
        if (DB.userstable[DB.userstable
                    .indexWhere((element) => element['user_id'] == userid)]
                ['office'][i] ==
            officeid) {
          usersupervisor = true;
        }
      }
    }
    return usersupervisor;
  }

  getusersinofficeifsupervisor() async {
    List office = [];
    office.clear();
    try {
      var t = await DB().customquery(
          query:
              'select uf_office_id,privilege from users_office where uf_user_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}');
      for (var i in t) {
        if (i[1] == 'مشرف') {
          office.add(i[0]);
        }
      }
      for (var i in office) {
        var t = await DB().customquery(
            query:
                'select uf_user_id from users_office where uf_office_id=$i;');
        for (var j in t) {
          if (Tasks.usersfortasks.contains(DB.userstable[DB.userstable
                  .indexWhere((element) => element['user_id'] == j[0])]
              ['fullname'])) {
            continue;
          } else {
            Tasks.usersfortasks.add(DB.userstable[DB.userstable
                    .indexWhere((element) => element['user_id'] == j[0])]
                ['fullname']);
          }
        }
      }
    } catch (e) {
      null;
    }
  }

  chooseofficetask(x) {
    Tasks.usersfortasks.clear();
    Tasks.usersfortaskswidget.clear();
    Tasks.taskofficeNameselected = x;
    update();
  }

  addusertotask({userid, required ScrollController scrollcontroller}) async {
    ADDEDITINFOItem.errormsg = null;
    Tasks.usersfortasks.clear();
    try {
      await getofficeUsers(
          list: Tasks.usersfortasks,
          officeid: DB.officetable[DB.officetable.indexWhere((element) =>
                  element['officename'] == Tasks.taskofficeNameselected)]
              ['office_id']);
      if (Tasks.usersfortasks.isEmpty) {
        ADDEDITINFOItem.errormsg =
            'لايوجد اي موظف في المكتب الذي تملك صلاحية الاشراف عليه';
      } else {
        Tasks.usersfortaskswidget.add({'i': 0, 'name': Tasks.usersfortasks[0]});
        scrollcontroller
            .jumpTo(scrollcontroller.position.maxScrollExtent + 100);
      }
    } catch (e) {
      ADDEDITINFOItem.errormsg = "لايمكن الوصول للمخدم";
    }
    update();
  }

  addimagetotodo({required ScrollController scrollcontroller}) async {
    x() async {
      File result;
      FilePickerResult? filepick =
          await FilePicker.platform.pickFiles(type: FileType.image);
      PlatformFile file;
      if (filepick != null) {
        file = filepick.files.single;
        if (file.size / 1024 > 200) {
          ADDEDITINFOItem.errormsg = "لا يمكن رفع صورة بحجم اكبر من  200kb";
        } else {
          result = File(file.path!);
          Whattodo.images.add(result);
        }
      } else {
        null;
      }
    }

    await x();
    update();
  }

  addcomment({e, addcommentaction}) async {
    e['error'] = null;
    try {
      e['waitsend'] = false;
      update();
      await addcommentaction;
      e['commentcontroller'].text = '';
      e['waitsend'] = true;
      update();
    } catch (c) {
      e['error'] = "لا يمكن الوصول للمخدم";
      update();
    }
    e['waitsend'] = true;
    update();
  }

  taskstatuschg(x) async {
    Tasks.taskstatus = x;
    update();
  }

  tasknotifichg({x, e}) async {
    try {
      await DB().customquery(
          query:
              "update tasks set notifi=${x == true ? 1 : 0} where task_id=${e['task_id']}");
      e['notifi'] = x == true ? 1 : 0;
    } catch (t) {}
    update();
  }

  deletecomment({e, required Function actiondeletecomment}) async {
    Comment.errmsg = null;
    update();
    try {
      Comment.wait = true;
      update();
      await actiondeletecomment();
      Get.back();
    } catch (e) {
      Comment.errmsg = 'لايمكن الوصول للمخدم';
    }
    Comment.wait = false;
    update();
  }

  editcomment({e, required Function actioneditcomment}) async {
    Comment.errmsg = null;
    update();
    try {
      Comment.wait = true;
      update();
      await actioneditcomment();
      Get.back();
    } catch (e) {
      Comment.errmsg = 'لايمكن الوصول للمخدم';
    }
    Comment.wait = false;
    update();
  }

//changepassword
  changepasswordPresonal({ctx, old}) async {
    PersonPanel.personalvisible =
        PersonPanel.personalvisible == true ? false : true;
    MainController mainController = Get.find();
    TextEditingController old = TextEditingController();
    TextEditingController newpass = TextEditingController();
    TextEditingController confirmnewpass = TextEditingController();
    String? errorold, errornew;
    bool showpass = false;
    bool waitchg = false;
    String? errornoconnect;
    update();
    showDialog(
        context: ctx,
        builder: (_) {
          return GetBuilder<MainController>(
            init: mainController,
            builder: (_) => AlertDialog(
              scrollable: true,
              title: const Text("تغيير كلمة المرور"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldMZ(
                    suffixIcon: IconButton(
                        onPressed: () {
                          showpass = showpass == true ? false : true;
                          update();
                        },
                        icon: const Icon(Icons.visibility)),
                    label: "كلمة المرور الحالية",
                    error: errorold,
                    textEditingController: old,
                    obscureText: !showpass,
                    onChanged: (x) => null,
                  ),
                  TextFieldMZ(
                      onChanged: (x) => null,
                      suffixIcon: IconButton(
                          onPressed: () {
                            showpass = showpass == true ? false : true;

                            update();
                          },
                          icon: const Icon(Icons.visibility)),
                      label: "كلمة المرور الجديدة",
                      error: errornew,
                      textEditingController: newpass,
                      obscureText: !showpass),
                  TextFieldMZ(
                      onChanged: (x) => null,
                      suffixIcon: IconButton(
                          onPressed: () {
                            showpass = showpass == true ? false : true;
                            update();
                          },
                          icon: const Icon(Icons.visibility)),
                      label: "تأكيد كلمة المرور الجديدة",
                      error: errornew,
                      textEditingController: confirmnewpass,
                      obscureText: !showpass),
                  Visibility(
                      visible: errornoconnect == null ? false : true,
                      child: Text(
                        "$errornoconnect",
                        style: const TextStyle(color: Colors.red),
                      ))
                ],
              ),
              actions: [
                Visibility(
                    visible: waitchg, child: const CircularProgressIndicator()),
                Visibility(
                  visible: !waitchg,
                  child: TextButton.icon(
                      onPressed: () async {
                        errornew = errorold = null;
                        update();
                        if (codepassword(word: old.text) !=
                            DB.userstable[DB.userstable.indexWhere((element) =>
                                    element['username'] == Home.logininfo)]
                                ['password']) {
                          errorold = "كلمة المرور الحالية غير صحيحة";
                          update();
                        } else if (newpass.text.isEmpty) {
                          errornew = "لا يمكن ان تكون الكلمة فارغة";
                          update();
                        } else if (newpass.text != confirmnewpass.text) {
                          errornew = "كلمة المرورغير متطابقة";
                          update();
                        } else {
                          waitchg = true;
                          update();
                          try {
                            await DBController().updatepassword(
                                newpass: newpass.text,
                                id: DB.userstable[DB.userstable.indexWhere(
                                    (element) =>
                                        element['username'] ==
                                        Home.logininfo)]['user_id']);
                            Get.back();
                            waitchg = false;
                          } catch (e) {
                            waitchg = false;
                            errornoconnect = "لا يمكن الوصول للمخدم";
                            update();
                          }
                        }
                      },
                      icon: const Icon(Icons.thumb_up),
                      label: const Text("تأكيد")),
                )
              ],
            ),
          );
        });
    update();
  }

  mustchgpass() async {
    DBController dbController = Get.find();
    if (LogIn.newpassword.text.isEmpty) {
      LogIn.errorMSglogin = 'لا يجب أن تكون كلمة المرور فارغة';
    } else if (LogIn.newpassword.text != LogIn.confirmnewpassword.text) {
      LogIn.errorMSglogin = 'كلمة المرور غير متطابقة';
    } else {
      LogIn.errorMSglogin = '';
      try {
        LogIn.loginwait = true;
        update();
        await dbController.updatepassword(
            newpass: LogIn.newpassword.text,
            id: DB.userstable[DB.userstable.indexWhere((element) =>
                    element['username'] == LogIn.username.text.toLowerCase())]
                ['user_id']);
        await setlogin(
            username: LogIn.username.text.toLowerCase(),
            password: LogIn.newpassword.text);
        Home.searchlist = [
          ...DB.officetable,
          ...DB.userstable,
          ...DB.tasktable,
          ...DB.todotable,
          ...DB.remindtable
        ];
        Home.logininfo = LogIn.username.text.toLowerCase();
        await Get.offNamed("/home");
      } catch (r) {
        LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
      }
      LogIn.loginwait = false;
      update();
    }

    update();
  }

//endemploy
  changeonhoverpagestitle({x, required ctx}) {
    for (var i in Home.pages) {
      i['size'] = 50.0;
    }
    Home.pages[x]['size'] = 55.0;
    update();
  }

  changeonexitdropMore({x, required ctx}) {
    Home.pages[x]['size'] = 50.0;
    update();
  }

  changeonhoverdropPersonal({x, ctx}) {
    for (var i in PersonPanel.dropdbitemz) {
      i['size'] = 20.0;
    }
    PersonPanel.dropdbitemz[x]['size'] = 25.0;
    update();
  }

//close drob
  cloasedp() {
    PersonPanel.personalvisible = false;
    Notificationm.dropend = -150.0;
    update();
  }

  //choosedate
  choosedate({ctx, beginorend}) async {
    DateTime? date = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse('2022-10-01'),
        lastDate: DateTime.now());
    if (date != null) {
      beginorend == 'begin'
          ? Tasks.sortbydatebegin = date
          : Tasks.sortbydateend = date;
    }
    update();
  }

  setdate() {
    DBController dbController = Get.find();
    var officecheckon = false;
    Home.selectall = false;
    for (var k in Home.searchlist) {
      if (k.keys.toList().first == 'office_id' && k['check'] == true) {
        officecheckon = true;
        break;
      } else {
        officecheckon = false;
      }
    }
    for (var j in Home.searchlist) {
      if (j.keys.toList().first == 'task_id') {
        if (officecheckon == true) {
          for (var i in Home.searchlist) {
            if (i.keys.toList().first == 'office_id') {
              if (j['task_office_id'] == i['office_id'] && i['check'] == true) {
                if (calcdaterang(date: j['createdate']) == true) {
                  j['check'] = true;
                } else {
                  j['check'] = false;
                }
              }
            }
          }
        } else {
          if (calcdaterang(date: j['createdate']) == true) {
            j['check'] = true;
          } else {
            j['check'] = false;
          }
        }
      }
    }
    dbController.update();

    update();
  }

//todo
  chooseofficetodo(x) {
    Whattodo.todoofficeNameselected = x;
    update();
  }

  chooseofficeremind(x) {
    Remind.remindofficeNameselected = x;
    update();
  }

  chooseremindtype(x) {
    Remind.typevalue = x;
    update();
  }

  chooseremindrepeat(x) {
    Remind.repeat = x;
    update();
  }

  setreminddate({ctx}) async {
    DateTime? dt = await showDatePicker(
        context: ctx,
        initialDate: Remind.onetimeremid,
        firstDate: DateTime.parse('2022-07-13'),
        lastDate: DateTime.now().add(const Duration(days: 364)));
    if (dt != null) {
      Remind.onetimeremid = dt;
      update();
    }
  }

  setstartreminddate({ctx}) async {
    var dt = await showTimePicker(context: ctx, initialTime: TimeOfDay.now());
    if (dt != null) {
      Remind.hourlystartremindvalue = dt;
      update();
    }
  }

  gettodayinweek() {
    String t = df.DateFormat("EEEE").format(DateTime.now()).toLowerCase();
    int today = 1;
    switch (t) {
      case 'friday':
        today = 5;
        break;
      case 'satarday':
        today = 6;
        break;
      case 'sunday':
        today = 7;
        break;
      case 'monday':
        today = 1;
        break;
      case 'tuesday':
        today = 2;
        break;
      case 'wednesday':
        today = 3;
        break;
      case 'thursday':
        today = 4;
        break;
    }
    return today;
  }

  getday({required String dayinString}) {
    int day = 1;

    switch (dayinString) {
      case 'friday':
        day = 5;
        break;
      case 'satarday':
        day = 6;
        break;
      case 'sunday':
        day = 7;
        break;
      case 'monday':
        day = 1;
        break;
      case 'tuesday':
        day = 2;
        break;
      case 'wednesday':
        day = 3;
        break;
      case 'thursday':
        day = 4;
        break;
    }
    return day;
  }

  getreminddate({typevalue, manytimevalue, id, required certsrc}) async {
    Remind.remiddate = null;
    List<int> dateandlist = [];
    int? dateand0, monthdays;
    int w = 7;
    DateTime? reminddate;
    dateand0 = null;
    if (DateTime.now().month == 1 ||
        DateTime.now().month == 3 ||
        DateTime.now().month == 5 ||
        DateTime.now().month == 7 ||
        DateTime.now().month == 8 ||
        DateTime.now().month == 10 ||
        DateTime.now().month == 12) {
      monthdays = 31;
    } else if (DateTime.now().month == 1 ||
        DateTime.now().month == 4 ||
        DateTime.now().month == 6 ||
        DateTime.now().month == 9 ||
        DateTime.now().month == 11) {
      monthdays = 30;
    } else if (DateTime.now().month == 2) {
      monthdays = 28;
    }
    try {
      if (Remind.typevalue == Remind.typelist[1] || typevalue == '1') {
        var t = await DB().customquery(
            query:
                "select every from remind_every where revery_remind_id=$id;");
        if (Remind.manytimesremindgroup == Remind.manytimesremindlist[0] ||
            manytimevalue == 0) {
          for (var i in t) {
            if (gettodayinweek() - getday(dayinString: i[0]) < 0) {
              dateandlist.add(
                  -1 * (gettodayinweek() - getday(dayinString: i[0])) as int);
            } else if (gettodayinweek() - getday(dayinString: i[0]) > 0) {
              dateandlist.add(
                  7 - (gettodayinweek() - getday(dayinString: i[0])) as int);
            } else {
              dateandlist.add(gettodayinweek() - getday(dayinString: i[0]));
            }
          }
          dateandlist.sort();
          dateand0 = dateandlist[0];
          if (dateand0 != null) {
            reminddate = DateTime.now().add(Duration(days: dateand0));
            await DB().customquery(
                query:
                    'update remind set reminddate="$reminddate" where remind_id=$id;');
            Remind.remiddate = reminddate;
          }
        } else if (Remind.manytimesremindgroup ==
                Remind.manytimesremindlist[1] ||
            manytimevalue == 1) {
          int daynum = 0;
          for (var i in t) {
            if (i[0] == 'last') {
              if (DateTime.now().month == 1 ||
                  DateTime.now().month == 3 ||
                  DateTime.now().month == 5 ||
                  DateTime.now().month == 7 ||
                  DateTime.now().month == 8 ||
                  DateTime.now().month == 10 ||
                  DateTime.now().month == 12) {
                daynum = 31;
              } else if (DateTime.now().month == 1 ||
                  DateTime.now().month == 4 ||
                  DateTime.now().month == 6 ||
                  DateTime.now().month == 9 ||
                  DateTime.now().month == 11) {
                daynum = 30;
              } else if (DateTime.now().month == 2) {
                daynum = 28;
              }
            } else {
              daynum = int.parse(i[0]);
            }
            dateandlist.add(daynum);
          }
          dateandlist.sort();
          for (var i in dateandlist) {
            if (i - DateTime.now().day < 0) {
              dateand0 = monthdays! + i;
            } else {
              dateand0 = i;
              break;
            }
          }
          if (dateand0 != null) {
            reminddate = DateTime.now()
                .add(Duration(days: dateand0 - DateTime.now().day));
            await DB().customquery(
                query:
                    'update remind set reminddate="$reminddate" where remind_id=$id;');
            Remind.remiddate = reminddate;
          }
        }
      } else if (Remind.typevalue == Remind.typelist[2] || typevalue == '2') {
        certsrc.startsWith('www.') ? certsrc = certsrc.substring(4) : null;
        certsrc.startsWith('https://') ? null : certsrc = 'https://$certsrc';
        await DB().customquery(
            query:
                'update remind set autocerturl="$certsrc" where remind_id=$id;');
        String cert = await getCert(host: certsrc);
        await DB().customquery(
            query:
                'update remind set reminddate="${DateTime.parse(cert)}" where remind_id=$id;');
        Remind.remiddate = DateTime.parse(cert);
      }
    } catch (e) {
      null;
    }

    update();
  }

  getreminddateauto() async {
    if (DateTime.now().minute == int.parse(Remind.timez.text)) {
      for (var i in DB.remindtable) {
        if (i['type'] == '2' && i['reminddate'] == null) {
          try {
            String cert = await getCert(host: i['autocerturl']);
            await DB().customquery(
                query:
                    'update remind set reminddate="${DateTime.parse(cert)}" where remind_id=${i['remind_id']};');
            Remind.remiddate = DateTime.parse(cert);
          } catch (e) {}
        }
      }
    }
    Future.delayed(Duration(minutes: 1), () => DBController().onReady());
  }

  choosemanytimesremind(x) {
    Remind.manytimesremindgroup = x;
    update();
  }

  chooseremindmonthlyvalue(x) {
    Remind.monthlydaysvalue = x;
    update();
  }

  addmonthlyremindday({value}) {
    if (!Remind.days.contains(value)) {
      Remind.monthly.add({'day': "$value", 'check': false});
      Remind.days.add(value);
    }
    update();
  }

  sendalertbeforremindadd() {
    Remind.sendalertbefor++;
    update();
  }

  sendalertbeforremindmin() {
    if (Remind.sendalertbefor > 0) {
      Remind.sendalertbefor--;
    }
    update();
  }

  repeatalertbeforremindadd() {
    if (Remind.repeat < 60) {
      Remind.repeat = Remind.repeat + 15;
    } else {
      Remind.repeat = Remind.repeat + 60;
    }
    update();
  }

  repeatalertbeforremindmin() {
    if (Remind.repeat > 15) {
      if (Remind.repeat <= 60) {
        Remind.repeat = Remind.repeat - 15;
      } else {
        Remind.repeat = Remind.repeat - 60;
      }
    }
    update();
  }

  removemonthlyremindday({value}) {
    Remind.days.remove(value);
    Remind.monthly.removeWhere((element) => element['day'] == "$value");
    update();
  }

  remindweeklycheckbox({x, index}) {
    Remind.weekly[index]['check'] = x;
    update();
  }

  remindmonthlycheckbox({x, index}) {
    Remind.monthly[index]['check'] = x;
    update();
  }

  snakbar(ctx, String mymsg) {
    SnackBar mysnak = SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(mymsg),
      backgroundColor: Colors.indigoAccent,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(ctx).showSnackBar(mysnak);
  }

//login

  checklogin() async {
    bool check = false;
    DBController dbController = Get.find();
    DB.userstable.clear();
    DB.officetable.clear();
    DB.tasktable.clear();
    DB.todotable.clear();
    DB.remindtable.clear();
    Home.selectall = true;
    LogIn.errorMSglogin = "الرجاء الانتظار .. جار جلب المعلومات";
    LogIn.loginwait = true;
    LogIn.errorMSglogin = '';
    update();
    if (LogIn.username.text.isEmpty) {
      LogIn.errorMSglogin = "يجب ادخال كلمة المرور واسم المستخدم";
    } else {
      try {
        await dbController.gettable(list: DB.userstable, table: 'users');
        await dbController.gettable(list: DB.officetable, table: 'office');
        await dbController.gettable(list: DB.tasktable, table: 'tasks');
        await dbController.gettable(list: DB.todotable, table: 'todo');
        await dbController.gettable(list: DB.remindtable, table: 'remind');
        i:
        for (var i in DB.userstable) {
          if (LogIn.username.text.toLowerCase() ==
                  i['username'].toLowerCase() &&
              codepassword(word: LogIn.password.text) == i['password']) {
            if (i['enable'] == 0) {
              LogIn.errorMSglogin = "تم تعطيل حسابك اتصل بالمسؤول";
              break i;
            } else if (i['mustchgpass'] == 1) {
              LogIn.errorMSglogin = '';
              LogIn.usernamereadonly = true;
              LogIn.oldpassvisible = false;
              update();
            } else {
              await setlogin(
                  username: LogIn.username.text.toLowerCase(),
                  password: LogIn.password.text);
              Home.logininfo = LogIn.username.text.toLowerCase();
              office_ids('office_id');
              await dbController.gettable(
                list: DB.userstable,
                table: 'users',
                where: DB.userstable[DB.userstable.indexWhere((element) =>
                            element['username'] == Home.logininfo)]['admin'] ==
                        1
                    ? ''
                    : 'join users_office on uf_user_id=user_id join office on uf_office_id=office_id where ${LogIn.office_ids} group by username',
              );
              await dbController.gettable(
                list: DB.officetable,
                table: 'office',
                where: DB.userstable[DB.userstable.indexWhere((element) =>
                            element['username'] == Home.logininfo)]['admin'] ==
                        1
                    ? ''
                    : 'join users_office on uf_office_id=office_id join users on uf_user_id=user_id where user_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}',
              );
              office_ids('task_office_id');
              await dbController.gettable(
                  list: DB.tasktable,
                  table: 'tasks',
                  where: DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['admin'] ==
                          1
                      ? ''
                      : 'where ${LogIn.office_ids}');

              office_ids('todo_office_id');
              await dbController.gettable(
                  list: DB.todotable,
                  table: 'todo',
                  where: DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['admin'] ==
                          1
                      ? ''
                      : 'where ${LogIn.office_ids}');
              office_ids('remind_office_id');
              await dbController.gettable(
                  list: DB.remindtable,
                  table: 'remind',
                  where: DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['admin'] ==
                          1
                      ? ''
                      : 'where ${LogIn.office_ids}');

              Home.searchlist = [
                ...DB.officetable,
                ...DB.userstable,
                ...DB.tasktable,
                ...DB.todotable,
                ...DB.remindtable
              ];
              for (var i in Home.searchlist) {
                i['check'] = true;
              }
              await Get.offNamed("/home");
              break i;
            }
          } else if (LogIn.username.text != i['username'] ||
              codepassword(word: LogIn.password.text) != i['password']) {
            if (i['mustchgpass'] != 1) {
              LogIn.errorMSglogin = "كلمة المرور او اسم المستخدم غير صحيح";
            }
          }
        }
      } catch (e) {
        LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
      }
    }
    LogIn.loginwait = false;
    update();
  }

  office_ids(offname) {
    LogIn.office_ids = '';
    for (var i in DB.userstable[DB.userstable
            .indexWhere((element) => element['username'] == Home.logininfo)]
        ['office']) {
      LogIn.office_ids += '$offname= $i or ';
    }
    LogIn.office_ids =
        LogIn.office_ids.substring(0, LogIn.office_ids.lastIndexOf(' or'));
    LogIn.office_ids = "(${LogIn.office_ids})";
  }

  autologin() async {
    DBController dbController = Get.find();
    DB.userstable.clear();
    DB.officetable.clear();
    DB.tasktable.clear();
    DB.todotable.clear();
    DB.remindtable.clear();
    Home.selectall = true;
    LogIn.errorMSglogin = "الرجاء الانتظار .. جار جلب المعلومات";
    LogIn.loginwait = true;
    update();
    try {
      await dbController.gettable(list: DB.userstable, table: 'users');
      await dbController.gettable(list: DB.officetable, table: 'office');
      await dbController.gettable(list: DB.tasktable, table: 'tasks');
      await dbController.gettable(list: DB.todotable, table: 'todo');
      await dbController.gettable(list: DB.remindtable, table: 'remind');

      i:
      for (var i in DB.userstable) {
        if (LogIn.username.text.toLowerCase() == i['username'].toLowerCase() &&
            codepassword(word: LogIn.password.text) == i['password']) {
          if (i['enable'] == 0) {
            LogIn.errorMSglogin = "تم تعطيل حسابك اتصل بالمسؤول";
            break i;
          } else if (i['mustchgpass'] == 1) {
            LogIn.errorMSglogin = '';
            LogIn.usernamereadonly = true;
            LogIn.oldpassvisible = false;
          } else {
            Home.logininfo = LogIn.username.text.toLowerCase();
            office_ids('office_id');
            await dbController.gettable(
              list: DB.userstable,
              table: 'users',
              where: DB.userstable[DB.userstable.indexWhere((element) =>
                              element['username'] == LogIn.username.text)]
                          ['admin'] ==
                      1
                  ? ''
                  : 'join users_office on uf_user_id=user_id join office on uf_office_id=office_id where ${LogIn.office_ids} group by username',
            );
            await dbController.gettable(
              list: DB.officetable,
              table: 'office',
              where: DB.userstable[DB.userstable.indexWhere((element) =>
                              element['username'] == Home.logininfo)]
                          ['admin'] ==
                      1
                  ? ''
                  : 'join users_office on uf_office_id=office_id join users on uf_user_id=user_id where user_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}',
            );
            office_ids('task_office_id');
            await dbController.gettable(
                list: DB.tasktable,
                table: 'tasks',
                where: DB.userstable[DB.userstable.indexWhere((element) =>
                                element['username'] == Home.logininfo)]
                            ['admin'] ==
                        1
                    ? ''
                    : 'where ${LogIn.office_ids}');

            office_ids('todo_office_id');
            await dbController.gettable(
                list: DB.todotable,
                table: 'todo',
                where: DB.userstable[DB.userstable.indexWhere((element) =>
                                element['username'] == Home.logininfo)]
                            ['admin'] ==
                        1
                    ? ''
                    : 'where ${LogIn.office_ids}');
            office_ids('remind_office_id');
            await dbController.gettable(
                list: DB.remindtable,
                table: 'remind',
                where: DB.userstable[DB.userstable.indexWhere((element) =>
                                element['username'] == Home.logininfo)]
                            ['admin'] ==
                        1
                    ? ''
                    : 'where ${LogIn.office_ids}');

            Home.searchlist = [
              ...DB.officetable,
              ...DB.userstable,
              ...DB.tasktable,
              ...DB.todotable,
              ...DB.remindtable
            ];
            for (var i in Home.searchlist) {
              i['check'] = true;
            }
            await Get.offNamed("/home");
            break i;
          }
        } else {
          if (i['mustchgpass'] != 1) {
            LogIn.errorMSglogin = "كلمة المرور او اسم المستخدم غير صحيح";
          }
        }
      }
    } catch (e) {
      LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
    }

    update();
  }

  firstbackpage() {
    ADDEDITINFOItem.firstpage =
        ADDEDITINFOItem.firstpage == true ? false : true;
    ADDEDITINFOItem.errormsg = null;
    update();
  }
}
