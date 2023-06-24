import 'dart:io';
import 'dart:math';
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
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

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
    for (var i in PersonPanel.dropdbitemz) {
      i['size'] = 150.0;
    }
    PersonPanel.dropend = PersonPanel.dropend == 0.0 ? -150.0 : 0.0;
    MoreTools.dropend = 1000;

    update();
  }

  notifilistshow() {
    Notificationm.dropend = Notificationm.dropend == 0.0 ? -150.0 : 0.0;
    MoreTools.dropend = 1000;
    update();
  }

  moretoolsshow(ctx) {
    for (var i in MoreTools.moretoolslist) {
      i['size'] = 150.0;
    }
    MoreTools.dropend =
        MoreTools.dropend == 0.0 ? MediaQuery.of(ctx).size.height : 0.0;
    Notificationm.dropend = -150.0;
    PersonPanel.dropend = -150.0;
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
    MoreTools.dropend = 1000;
    // if (Whattodo.closebs == 1) {
    //   Get.back();
    // }
    update();
  }

  homemaincontent(x) async {
    HomePage.selectedPage = x;
    for (var i in BottomNBMZ.pageslist) {
      i['color'] = [
        Colors.transparent,
        Colors.transparent,
      ];
      i['border'] = Colors.transparent;
      i['rotate'] = i['irotate'] = 0.0 * pi / 180;
      i['rize'] = 0.0;
    }

    PersonPanel.dropend = -150;
    Notificationm.dropend = -150;
    MoreTools.dropend = 1000;
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

  deletecommenttodo({required ctx, id, commintid, index}) async {
    String errormsg = '';
    showDialog(
        context: ctx,
        builder: (_) {
          MainController mainController = Get.find();
          return Directionality(
              textDirection: TextDirection.rtl,
              child: GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('هل أنت متأكد من حذف التعليق'),
                      actions: [
                        Column(
                          children: [
                            Text(errormsg),
                            Row(
                              children: [
                                Visibility(
                                    visible: !Whattodo.deletewait,
                                    child: IconButton(
                                        onPressed: () async {
                                          Whattodo.deletewait = true;
                                          errormsg = '';
                                          update();
                                          try {
                                            await DBController()
                                                .deletecommenttodo(
                                                    commentid: commintid);
                                            Get.back();
                                          } catch (e) {
                                            errormsg = "$e";
                                          }
                                          Whattodo.deletewait = false;
                                          update();
                                        },
                                        icon: const Icon(Icons.delete))),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                            visible: Whattodo.deletewait,
                            child: const CircularProgressIndicator())
                      ],
                    );
                  }));
        });
  }

  rate(index, ratting, userid, todoid) async {
    for (var i in Whattodo.mylista[index]['rate_widget']) {
      i['icon'] = Icons.star_border;
    }
    f:
    for (var i in Whattodo.mylista[index]['rate_widget']) {
      i['icon'] = Icons.star;
      if (ratting == Whattodo.mylista[index]['rate_widget'].indexOf(i)) {
        break f;
      }
    }
    try {
      await DBController().rates(
          userid: userid, todoid: todoid, rate: ratting + 1, index: index);
    } catch (e) {
      null;
    }

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
            }
          }
        }
      }
    } catch (r) {}
    update();
  }

  changenotifitask({taskIndex, notifi, id}) async {
    await DBController()
        .changetasknotifi(notifi: notifi == true ? 1 : 0, id: id);
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
    String result = getExpiredate.stdout;
    return result;
  }

//additem
  addItemMainController(
      {page,
      listofFeildmz,
      itemnameController,
      required ScrollController scrollcontroller}) async {
    var checkdublicateoffice = false;
    bool duplicateCheck = true;
    AddPanel.errormsg = null;
    if (itemnameController.isEmpty) {
      listofFeildmz[0]['error'] = 'لا يمكن ان يكون الاسم فارغا';
      scrollcontroller.jumpTo(scrollcontroller.position.minScrollExtent);
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
            ? AddPanel.errormsg = 'لا يمكن الوصول للمخدم'
            : "$e".contains('Duplicat')
                ? AddPanel.errormsg = 'اسم محجوز مسبقا'
                : AddPanel.errormsg = "لا يمكن الوصول للمخدم'";
      }
      AddPanel.wait = false;

      update();
    } else if (page == Employ) {
      checkdublicateoffice = false;
      if (Employ.employs[1]['controller'].text.isEmpty) {
        Employ.employs[1]['error'] = 'لا يمكن ان يكون الاسم  فارغا';
        scrollcontroller.jumpTo(scrollcontroller.position.minScrollExtent);
      } else if (Employ.employs[2]['controller'].text.isEmpty) {
        Employ.employs[2]['error'] = 'لا يمكن ان يكون حقل كلمة المرور  فارغا';
        scrollcontroller.jumpTo(scrollcontroller.position.minScrollExtent);
      } else if (Employ.employs[2]['controller'].text !=
          Employ.employs[3]['controller'].text) {
        Employ.employs[2]['error'] =
            Employ.employs[3]['error'] = "كلمة مرور غير متطابقة";
        scrollcontroller.jumpTo(scrollcontroller.position.minScrollExtent);
      } else if (Employ.privilege.isNotEmpty) {
        ch:
        for (var i in Employ.privilege) {
          for (var j in Employ.privilege) {
            if (i['office'] == j['office'] &&
                Employ.privilege.indexOf(i) != Employ.privilege.indexOf(j)) {
              checkdublicateoffice = true;
              AddPanel.errormsg = "لا يمكن اعطاء صلاحيتين في مكتب واحد";
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
                ? AddPanel.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? AddPanel.errormsg = 'اسم  محجوز مسبقا'
                    : AddPanel.errormsg = "لا يمكن الوصول للمخدم'";
            scrollcontroller.jumpTo(0);
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
                ? AddPanel.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? AddPanel.errormsg = 'اسم  محجوز مسبقا'
                    : AddPanel.errormsg = "لا يمكن الوصول للمخدم'";
            scrollcontroller.jumpTo(0);
          }
          AddPanel.wait = false;
          update();
        }
      }
    } else if (page == Tasks) {
      Tasks.errormsg = null;
      if (Tasks.usersfortaskswidget.isEmpty) {
        Tasks.errormsg =
            "لا يمكن أن تنشئ مهمة دون ان تعين لها موظف واحد على الأقل";
      } else {
        h:
        for (var i in Tasks.usersfortaskswidget) {
          for (var j in Tasks.usersfortaskswidget) {
            if (i['name'] == j['name'] &&
                Tasks.usersfortaskswidget.indexOf(i) !=
                    Tasks.usersfortaskswidget.indexOf(j)) {
              duplicateCheck = true;
              Tasks.errormsg = "لايمكن تعيين نفس الموظف للمهمة نفسها مرتين";
              break h;
            } else {
              duplicateCheck = false;
            }
          }
        }
        if (duplicateCheck == false) {
          try {
            Tasks.addwaitvis = true;
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
            Tasks.addwaitvis = false;
            "$e".contains('timed out')
                ? Tasks.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? Tasks.errormsg = 'اسم محجوز مسبقا'
                    : Tasks.errormsg = "لا يمكن الوصول للمخدم'";
          }
          Tasks.addwaitvis = false;
          update();
        }
      }
    } else if (page == Whattodo) {
      Whattodo.errormsg = null;
      try {
        Whattodo.addwaitvis = true;
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
        Whattodo.addwaitvis = false;
        "$e".contains('timed out')
            ? Whattodo.errormsg = 'لا يمكن الوصول للمخدم'
            : "$e".contains('Duplicat')
                ? Whattodo.errormsg = 'اسم محجوز مسبقا'
                : Whattodo.errormsg = "$e";
      }
      Whattodo.addwaitvis = false;
      update();
    }

    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable
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
                        ? name = Tasks.mylista[Tasks.mylista.indexWhere((element) => element['task_id'] == Tasks.taskid)]
                            ['taskname']
                        : page == Whattodo
                            ? name = Whattodo.mylista[Whattodo.mylista
                                    .indexWhere((element) => element['todo_id'] == Whattodo.todoid)]
                                ['todoname']
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
    Editpanel.errormsg = null;
    Editpanel.savevisible = true;
    ADDEDITINFOItem.addeditvisible = true;
    update();
  }

  editItemMainController({e, ctx, page, listofFeildmz}) async {
    var checkdublicateoffice = false;
    var checkdublicateuseroftask = false;
    Editpanel.errormsg = null;
    for (var i in listofFeildmz) {
      i['error'] = null;
    }
    if (listofFeildmz[0]['controller'].text.isEmpty) {
      listofFeildmz[0]['error'] = 'لا يمكن ان يكون اسم فارغا';
    } else {
      if (page == Office) {
        try {
          Editpanel.wait = true;
          update();
          await DBController().editoffice(id: e['office_id']);
        } catch (e) {
          "$e".contains('timed out')
              ? Editpanel.errormsg = 'لا يمكن الوصول للمخدم'
              : "$e".contains('Duplicat')
                  ? Editpanel.errormsg = 'اسم محجوز مسبقا'
                  : Editpanel.errormsg = "$e";
        }
        Editpanel.wait = false;
        Editpanel.savevisible = false;
        ADDEDITINFOItem.addeditvisible = false;
        update();
      } else if (page == Employ) {
        if (Employ.employs[1]['controller'].text.isEmpty) {
          Employ.employs[1]['error'] = 'لا يمكن ان يكون الاسم  فارغا';
        } else if (Employ.employs[2]['controller'].text !=
            Employ.employs[3]['controller'].text) {
          Employ.employs[2]['error'] =
              Employ.employs[3]['error'] = "كلمة مرور غير متطابقة";
        } else if (Employ.privilege.isNotEmpty) {
          ch:
          for (var i in Employ.privilege) {
            for (var j in Employ.privilege) {
              if (i['office'] == j['office'] &&
                  Employ.privilege.indexOf(i) != Employ.privilege.indexOf(j)) {
                checkdublicateoffice = true;
                Editpanel.errormsg = "لا يمكن اعطاء صلاحيتين في مكتب واحد";
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
            } catch (e) {
              "$e".contains('timed out')
                  ? Editpanel.errormsg = 'لا يمكن الوصول للمخدم'
                  : "$e".contains('Duplicat')
                      ? Editpanel.errormsg =
                          'اسم المستخدم  او الاسم الكامل محجوز مسبقا'
                      : Editpanel.errormsg = "$e";
            }
            Editpanel.wait = false;
            Editpanel.savevisible = false;
            ADDEDITINFOItem.addeditvisible = false;
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
          } catch (e) {
            "$e".contains('timed out')
                ? Editpanel.errormsg = 'لا يمكن الوصول للمخدم'
                : "$e".contains('Duplicat')
                    ? Editpanel.errormsg =
                        'اسم المستخدم  او الاسم الكامل محجوز مسبقا'
                    : Editpanel.errormsg = "$e";
          }

          Editpanel.wait = false;
          Editpanel.savevisible = false;
          ADDEDITINFOItem.addeditvisible = false;
          update();
        }
      } else if (page == Tasks) {
        Tasks.extratimecontrollererror = null;
        if (Tasks.usersfortaskswidget.isEmpty) {
          Tasks.errormsg =
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
                Tasks.errormsg = "لايمكن تعيين نفس الموظف للمهمة نفسها مرتين";
                break h;
              } else {
                checkdublicateuseroftask = false;
              }
            }
          }
          if (checkdublicateuseroftask == false) {
            Tasks.addwaitvis = true;
            update();
            Tasks.extratimecontroller.text.isEmpty ? "0" : null;
            try {
              int.parse(Tasks.extratimecontroller.text);
            } catch (o) {
              Tasks.extratimecontrollererror = "أدخل قيمة عددية صحيحة فقط";
            }
            try {
              Tasks.addwaitvis = true;
              update();
              await DBController().edittask(
                  id: Tasks.taskid,
                  taskname: Tasks.tasks[0]['controller'].text,
                  taskdetails: Tasks.tasks[1]['controller'].text,
                  extratime: int.parse(Tasks.extratimecontroller.text),
                  taskofficeid: DB.officetable[DB.officetable.indexWhere(
                      (element) =>
                          element['officename'] ==
                          Tasks.taskofficeNameselected)]['office_id']);
              Get.back();
            } catch (e) {
              "$e".contains('timed out')
                  ? Tasks.errormsg = 'لا يمكن الوصول للمخدم'
                  : "$e".contains('Duplicat')
                      ? Tasks.errormsg = 'اسم محجوز مسبقا'
                      : "$e".contains('FormatExcep')
                          ? Tasks.errormsg = 'أدخل قيمة عددية صحيحة'
                          : Tasks.errormsg = "$e";
              update();
            }
            Tasks.addwaitvis = false;
            update();
          }
        }
      } else if (page == Whattodo) {
        try {
          Whattodo.addwaitvis = true;
          update();
          await DBController().edittodo(
              useredit:
                  "${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}",
              todoname: Whattodo.todos[0]['controller'].text,
              tododetails: Whattodo.todos[1]['controller'].text,
              id: Whattodo.todoid);
          Get.back();
        } catch (e) {
          Whattodo.addwaitvis = false;
          "$e".contains('timed out')
              ? Whattodo.errormsg = 'لا يمكن الوصول للمخدم'
              : "$e".contains('Duplicat')
                  ? Whattodo.errormsg = 'اسم محجوز مسبقا'
                  : Whattodo.errormsg = "$e";
        }
        Whattodo.addwaitvis = false;
        update();
      }
    }
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable
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
                  searchbydatesearch(j);
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
                if (j['task_office_id'] == i['office_id']) {
                  searchbydatesearch(j);
                }
              }
              if (i['office_id'] == j['todo_office_id']) {
                j['check'] = true;
              }
            }
          }
        }
      }
    } catch (r) {
      null;
    }
    update();
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
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      AddPanel.errormsg = 'لم تقم بإضافة أي مكتب';
    }
    update();
  }

  deleteprivilege(index) {
    Employ.privilege.removeAt(index);
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

  addusertotask({userid}) async {
    Tasks.errormsg = null;
    Tasks.usersfortasks.clear();
    try {
      var t = await DB().customquery(
          query:
              'select uf_user_id from users_office where uf_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Tasks.taskofficeNameselected)]['office_id'])]['office_id']}');
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

      if (Tasks.usersfortasks.isEmpty) {
        Tasks.errormsg =
            'لايوجد اي موظف في المكتب الذي تملك صلاحية الاشراف عليه';
      } else {
        Tasks.usersfortaskswidget.add({'i': 0, 'name': Tasks.usersfortasks[0]});
      }
    } catch (e) {
      Tasks.errormsg = "لايمكن الوصول للمخدم";
    }

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

  editcomment(
      {ctx,
      errorcomment,
      commentcontrolleredit,
      editcommentwait,
      editcommentaction,
      commentid,
      page}) async {
    DBController dbController = Get.find();
    MainController mainController = Get.find();
    showDialog(
        context: ctx,
        builder: (_) {
          return GetBuilder<MainController>(
            init: mainController,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldMZ(
                      onChanged: (x) => null,
                      label: "",
                      textEditingController: commentcontrolleredit,
                      error: errorcomment),
                ],
              ),
              actions: [
                Visibility(
                    visible: !editcommentwait,
                    child: IconButton(
                        onPressed: () async {
                          errorcomment = null;
                          if (commentcontrolleredit.text.isEmpty) {
                            errorcomment = "لايمكن أن يكون فارغا";
                            update();
                          } else {
                            try {
                              editcommentwait = true;
                              update();
                              page == Tasks
                                  ? await dbController.editcommenttask(
                                      comment: Tasks.commentcontrolleredit.text,
                                      id: commentid)
                                  : page == Whattodo
                                      ? await dbController.editcommenttodo(
                                          comment: Whattodo
                                              .commentcontrolleredit.text,
                                          id: commentid)
                                      : null;
                              Get.back();
                            } catch (e) {
                              errorcomment = "لايمكن الوصول للمخدم";
                              update();
                            }
                            editcommentwait = false;
                            update();
                          }
                        },
                        icon: const Icon(Icons.edit))),
                Visibility(
                    visible: editcommentwait,
                    child: const LinearProgressIndicator())
              ],
            ),
          );
        });

    update();
  }

  deletecommen({required ctx, id, commintid, page, deletewait}) async {
    MainController mainController = Get.find();
    String errormsg = '';
    showDialog(
        context: ctx,
        builder: (_) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: GetBuilder<MainController>(
                  init: mainController,
                  builder: (_) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('هل أنت متأكد من حذف التعليق'),
                      actions: [
                        Column(
                          children: [
                            Text(errormsg),
                            Row(
                              children: [
                                Visibility(
                                    visible: !deletewait,
                                    child: IconButton(
                                        onPressed: () async {
                                          deletewait = true;
                                          update();
                                          errormsg = '';
                                          update();
                                          try {
                                            page == Tasks
                                                ? await DBController()
                                                    .deletecommenttask(
                                                        commentid: commintid)
                                                : page == Whattodo
                                                    ? await DBController()
                                                        .deletecommenttodo(
                                                            commentid:
                                                                commintid)
                                                    : null;
                                            Get.back();
                                          } catch (e) {
                                            errormsg = "لا يمكن الوصول للمخدم";
                                          }
                                          deletewait = false;
                                          update();
                                        },
                                        icon: const Icon(Icons.delete))),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                            visible: Tasks.deletewait,
                            child: const CircularProgressIndicator())
                      ],
                    );
                  }));
        });
  }

  taskstatuschg(x) async {
    Tasks.taskstatus = x;
    update();
  }

//changepassword
  changepasswordPresonal({ctx, old}) async {
    PersonPanel.dropend = -150.0;
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
        await dbController.updatepassword(
            newpass: LogIn.newpassword.text,
            id: DB.userstable[DB.userstable.indexWhere(
                    (element) => element['username'] == LogIn.username.text)]
                ['user_id']);
        await setlogin(
            username: LogIn.username.text, password: LogIn.newpassword.text);
        Home.searchlist = [
          ...DB.officetable,
          ...DB.userstable,
          ...DB.tasktable,
          ...DB.todotable
        ];
        Home.logininfo = LogIn.username.text.toLowerCase();
        await Get.offNamed("/home");
      } catch (r) {
        LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
      }
    }

    update();
  }

//endemploy
  changeonhoverdropMore({x}) {
    for (var i in MoreTools.moretoolslist) {
      i['size'] = 150.0;
    }
    MoreTools.moretoolslist[x]['size'] = 170.0;
    update();
  }

  changeonhoverdropPersonal({x, ctx}) {
    for (var i in PersonPanel.dropdbitemz) {
      i['size'] = 150.0;
    }
    PersonPanel.dropdbitemz[x]['size'] = 170.0;
    update();
  }

//close drob
  cloasedp() {
    PersonPanel.dropend = -150.0;
    Notificationm.dropend = -150.0;
    MoreTools.dropend = 1000.0;
    update();
  }

  //choosedate
  choosedate({ctx, beginorend, officeid}) async {
    DBController dbController = Get.find();

    DateTime? date = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.parse('2022-10-01'),
        lastDate: DateTime.now());
    if (date != null) {
      beginorend == 'begin'
          ? MYPAGE.sortbydatebegin = date
          : MYPAGE.sortbydateend = date;
    }
    Home.selectall = false;

    for (var i in Home.searchlist) {
      if (i.keys.toList().first == 'office_id' && i['check'] == true) {
        for (var j in Home.searchlist) {
          if (j['task_office_id'] == i['office_id']) {
            if (MYPAGE.sortbydatebegin.isBefore(j['createdate']) &&
                MYPAGE.sortbydateend
                    .add(const Duration(days: 1))
                    .isAfter(j['createdate'])) {
              j['check'] = true;
            } else {
              j['check'] = false;
            }
          }
        }
      } else {
        var withoutoffice = 0;
        for (var o in Home.searchlist) {
          if (o.keys.toList().first == 'office_id' && o['check'] == true) {
            withoutoffice = 1;
          }
        }
        if (withoutoffice == 0) {
          for (var j in Home.searchlist) {
            if (j.keys.toList().first == 'task_id') {
              if (MYPAGE.sortbydatebegin.isBefore(j['createdate']) &&
                  MYPAGE.sortbydateend
                      .add(const Duration(days: 1))
                      .isAfter(j['createdate'])) {
                j['check'] = true;
              } else {
                j['check'] = false;
              }
            }
          }
        }
      }
      dbController.update();
      update();
    }
  }

  searchbydatesearch(j) async {
    if (Tasks.sortbydatebegin.isBefore(j['createdate']) &&
        Tasks.sortbydateend
            .add(const Duration(days: 1))
            .isAfter(j['createdate'])) {
      j['check'] = true;
    }
    update();
  }

//todo
  chooseofficetodo(x) {
    Whattodo.todooffice = x;
    update();
  }

  snakbar(ctx, String mymsg) {
    SnackBar mysnak = SnackBar(
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
    DBController dbController = Get.find();
    DB.userstable.clear();
    DB.officetable.clear();
    DB.tasktable.clear();
    DB.todotable.clear();
    Home.selectall = true;
    LogIn.errorMSglogin = "الرجاء الانتظار .. جار جلب المعلومات";
    LogIn.loginwait = true;
    update();
    if (LogIn.username.text.isEmpty) {
      LogIn.errorMSglogin = "يجب ادخال كلمة المرور واسم المستخدم";
    } else {
      try {
        await dbController.gettable(list: DB.userstable, table: 'users');
        await dbController.gettable(list: DB.officetable, table: 'office');
        await dbController.gettable(list: DB.tasktable, table: 'tasks');
        await dbController.gettable(list: DB.todotable, table: 'todo');
        for (var i in Home.searchlist) {
          i['check'] = true;
        }

        i:
        for (var i in DB.userstable) {
          if (LogIn.username.text.toLowerCase() ==
                  i['username'].toLowerCase() &&
              codepassword(word: LogIn.password.text) == i['password']) {
            if (i['enable'] == 0) {
              LogIn.errorMSglogin = "تم تعطيل حسابك اتصل بالمسؤول";
              break i;
            } else if (i['mustchgpass'] == 1) {
              LogIn.usernamereadonly = true;
              LogIn.oldpassvisible = false;
            } else {
              await setlogin(
                  username: LogIn.username.text, password: LogIn.password.text);
              Home.searchlist = [
                ...DB.officetable,
                ...DB.userstable,
                ...DB.tasktable,
                ...DB.todotable
              ];
              Home.logininfo = LogIn.username.text.toLowerCase();
              await Get.offNamed("/home");
              break i;
            }
          } else if (LogIn.username.text != i['username'] ||
              codepassword(word: LogIn.password.text) != i['password']) {
            LogIn.errorMSglogin = "كلمة المرور او اسم المستخدم غير صحيح";
          }
        }
      } catch (e) {
        LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
      }
    }
    LogIn.loginwait = false;
    update();
  }

  autologin() async {
    DBController dbController = Get.find();
    DB.userstable.clear();
    DB.officetable.clear();
    DB.tasktable.clear();
    DB.todotable.clear();
    Home.selectall = true;
    LogIn.errorMSglogin = "الرجاء الانتظار .. جار جلب المعلومات";
    LogIn.loginwait = true;
    update();
    try {
      await dbController.gettable(list: DB.userstable, table: 'users');
      await dbController.gettable(list: DB.officetable, table: 'office');
      await dbController.gettable(list: DB.tasktable, table: 'tasks');
      await dbController.gettable(list: DB.todotable, table: 'todo');
      for (var i in Home.searchlist) {
        i['check'] = true;
      }
      i:
      for (var i in DB.userstable) {
        if (LogIn.username.text.toLowerCase() == i['username'].toLowerCase() &&
            codepassword(word: LogIn.password.text) == i['password']) {
          if (i['enable'] == 0) {
            LogIn.errorMSglogin = "تم تعطيل حسابك اتصل بالمسؤول";
            break i;
          } else if (i['mustchgpass'] == 1) {
            LogIn.usernamereadonly = true;
            LogIn.oldpassvisible = false;
          } else {
            Get.offNamed("/home");
            break i;
          }
        } else {
          LogIn.errorMSglogin = "كلمة المرور او اسم المستخدم غير صحيح";
        }
      }
    } catch (e) {
      LogIn.errorMSglogin = "لايمكن الوصول للمخدم";
    }
    LogIn.loginwait = false;
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable
    ];
    update();
  }
}
