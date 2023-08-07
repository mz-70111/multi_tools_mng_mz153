// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/remind.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class DBController extends GetxController {
  MainController mainController = Get.find();
  @override
  void onInit() async {
    LogIn.obscuretext = true;
    LogIn.loginwait = true;
    LogIn.Pref = await SharedPreferences.getInstance();
    LogIn.autologin = await getlogin() ?? [];
    // try {
    //   await DB().createappversiontable();
    //   await DB().createuserstable();
    //   await DB().createofficetable();
    //   await DB().createusersofficetable();
    //   await DB().createtaskstable();
    //   await DB().createuserstasktable();
    //   await DB().createuserstasksCommentstable();
    //   await DB().createtodotable();
    //   await DB().createuserstodo();
    //   await DB().createuserstodoCommentstable();
    //   await DB().createremindtable();
    //   await DB().createusersremindtable();
    //   await DB().createusersremindCommentable();
    //   await DB().createtodoimagetable();
    //   await DB().createremindlog();
    //   await DB().createremindrepeateevery();
    //   await DB().createmainlogtable();
    // } catch (e) {
    //   print(e);
    //   "$e".contains('timed out')
    //       ? LogIn.errorMSglogin = "لايمكن الوصول للمخدم"
    //       : LogIn.errorMSglogin = "يجب ادخال كلمة المرور واسم المستخدم";
    // }
    if (LogIn.autologin.isNotEmpty) {
      Future.delayed(Duration(seconds: 2), () async {
        LogIn.username.text = LogIn.autologin[0];
        LogIn.password.text = LogIn.autologin[1];
        await mainController.autologin();
        Home.logininfo = LogIn.username.text.toLowerCase();
      });
    } else {
      LogIn.errorMSglogin = '';
    }
    LogIn.loginwait = false;
    super.onInit();
    update();
  }

  @override
  onReady() async {
    super.onReady();

    update();
  }

  gettable(
      {type = 'custom',
      required List<Map> list,
      table,
      where = '',
      tableid = '',
      required usertable}) async {
    var ww, xx, yy, zz, desctable, selecttable;
    var temp = [],
        pr = [],
        of = [],
        usersOffice = [],
        usersC = [],
        usersIdC = [],
        comment = [],
        commentdate = [],
        commentId = [],
        images = [],
        remindlog = [],
        remindlogdate = [],
        every = [];

    list.clear();
    desctable = await DB().customquery(query: 'desc $table;');
    if (Home.selectall == true) {
      selecttable =
          await DB().customquery(query: 'select * from $table $where');
    } else {
      temp.clear();
      for (var i in Home.searchlist) {
        if (i['check'] == true) {
          selecttable = await DB().customquery(
              query: 'select * from $table where $tableid=${i['$tableid']};');
          temp.addAll(selecttable);
        }
      }
      selecttable = temp;
    }

    int x = 0, y = 0;
    for (var i in selecttable) {
      list.add({});
      y = 0;
      for (var j in desctable) {
        list[x].addAll({j[0]: i[y]});
        y++;
      }
      list[x].addAll({'check': true, 'visible': true});
      x++;
    }
    List ui = [], un = [], ndx = [];
    for (var i in list) {
      if (i.keys.toList().first == 'user_id') {
        yy = await DB().customquery(
            query:
                'select * from users_office where uf_user_id=${i['user_id']}');
        pr.clear();
        of.clear();
        for (var o in yy) {
          pr.add(o[3]);
          of.add(o[2]);
        }
        i['admin'] == 1 ? {pr.add('مسؤول'), of.add('=')} : null;
        pr.isEmpty ? {pr.add('_'), of.add('_')} : null;
        list[list.indexOf(i)].addAll({
          'privilege': [...pr],
          'office': [...of]
        });
        ndx.clear();
        try {
          for (var io in list[list.indexOf(i)]['office']) {
            ndx.add(DB.officetable[DB.officetable
                    .indexWhere((element) => element['office_id'] == io)]
                ['officename']);
          }
        } catch (e) {
          null;
        }
        list[list.indexOf(i)].addAll({
          'offndx': [...ndx]
        });
      } else if (i.keys.toList().first == 'office_id') {
        yy = await DB().customquery(
            query:
                'select * from users_office where uf_office_id=${i['office_id']}');
        usersOffice.clear();
        for (var o in yy) {
          usersOffice.add(o[1]);
        }
        list[list.indexOf(i)].addAll({
          'users': [...usersOffice],
        });
      } else if (i.keys.toList().first == 'todo_id') {
        if (type == 'custom') {
          await mainController.office_ids(
              offname: 'uf_office_id', type: 'custom');
        } else {
          await mainController.office_ids(offname: 'uf_office_id', type: 'all');
        }
        if (checkifUserisAdmin(
                usertable: usertable,
                userid: usertable[usertable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id']) ==
            true) {
          xx = await DB().customquery(query: 'select * from users_todo');
        } else {
          xx = await DB().customquery(
              query:
                  'select * from users_todo join users_office on uf_user_id=createby_id where ${LogIn.office_ids}');
        }
        for (var t in xx) {
          list[list.indexOf(i)].addAll({
            'createby_id': t[1],
            'createby': t[1] != null
                ? usertable[usertable.indexWhere(
                    (element) => element['user_id'] == t[1])]['fullname']
                : null,
            'editby_id': t[2],
            'editby': t[2] != null
                ? usertable[usertable.indexWhere(
                    (element) => element['user_id'] == t[2])]['fullname']
                : null,
          });
        }
        list[list.indexOf(i)].addAll({
          'comment_id': [...commentId],
          'users_id_comment': [...usersIdC],
          'users_c': [...usersC],
          'comment': [...comment],
          'commentdate': [...commentdate],
          'commentcontroller': TextEditingController(),
          'waitsend': true,
          'error': null
        });

        zz = await DB().customquery(
            query:
                'select * from todo_images where ti_todo_id=${i['todo_id']}');
        images.clear();
        for (var o in zz) {
          images.add(o[2]);
        }

        list[list.indexOf(i)].addAll({
          'images': [...images]
        });
      } else if (i.keys.toList().first == 'task_id') {
        if (type == 'custom') {
          await mainController.office_ids(
              offname: 'uf_office_id', type: 'custom');
        } else {
          await mainController.office_ids(offname: 'uf_office_id', type: 'all');
        }
        if (checkifUserisAdmin(
                usertable: usertable,
                userid: usertable[usertable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id']) ==
            true) {
          xx = await DB().customquery(query: 'select * from users_tasks');
        } else {
          xx = await DB().customquery(
              query:
                  'select * from users_tasks join users_office on uf_user_id=ut_user_id where ${LogIn.office_ids}');
        }
        ui.clear();
        un.clear();
        for (var t in xx) {
          ui.add(t[1]);
          un.add(t[1] != null
              ? usertable[usertable.indexWhere(
                  (element) => element['user_id'] == t[1])]['fullname']
              : null);
        }

        list[list.indexOf(i)].addAll({
          'userstask_id': [...ui],
          'userstask_name': [...un],
        });

        list[list.indexOf(i)].addAll({
          'comment_id': [...commentId],
          'users_id_comment': [...usersIdC],
          'users_c': [...usersC],
          'comment': [...comment],
          'commentdate': [...commentdate],
          'commentcontroller': TextEditingController(),
          'waitsend': true,
          'error': null
        });
      } else if (i.keys.toList().first == 'remind_id') {
        if (type == 'custom') {
          await mainController.office_ids(
              offname: 'uf_office_id', type: 'custom');
        } else {
          await mainController.office_ids(offname: 'uf_office_id', type: 'all');
        }
        ww = await DB().customquery(
            query:
                'select every from remind_every where revery_remind_id=${i['remind_id']}');
        every.clear();
        for (var evt in ww) {
          every.add(evt[0]);
        }
        list[list.indexOf(i)].addAll({
          'every': [...every]
        });

        if (checkifUserisAdmin(
                usertable: usertable,
                userid: usertable[usertable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id']) ==
            true) {
          xx = await DB().customquery(query: 'select * from users_remind');
        } else {
          xx = await DB().customquery(
              query:
                  'select * from users_remind join users_office on uf_user_id=createby_id where ${LogIn.office_ids}');
        }
        for (var t in xx) {
          list[list.indexOf(i)].addAll({
            'createby_id': t[1],
            'createby': t[1] != null
                ? usertable[usertable.indexWhere(
                    (element) => element['user_id'] == t[1])]['fullname']
                : null,
            'createdate': t[2],
            'editby_id': t[3],
            'editby': t[3] != null
                ? usertable[usertable.indexWhere(
                    (element) => element['user_id'] == t[3])]['fullname']
                : null,
            'editdate': t[4]
          });
        }

        list[list.indexOf(i)].addAll({
          'comment_id': [...commentId],
          'users_id_comment': [...usersIdC],
          'users_c': [...usersC],
          'comment': [...comment],
          'commentdate': [...commentdate],
          'commentcontroller': TextEditingController(),
          'waitsend': true,
          'error': null
        });
        zz = await DB().customquery(
            query:
                'select * from remind_log where rlog_remind_id=${i['remind_id']}');
        remindlog.clear();
        for (var o in zz) {
          remindlog.add(o[2]);
          remindlogdate.add(o[3]);
        }
        list[list.indexOf(i)].addAll({
          'log': [...remindlog],
          'logdate': [...remindlogdate]
        });
      }
    }
    return list;
  }

  adduser() async {
    String passw =
        codepassword(word: "${Employ.employs[2]['controller'].text}");
    await DB().customquery(query: '''
insert into users (username,fullname,password,email,mobile,admin,mustchgpass,addremind,addtodo,addping,pbx)
values
(
"${Employ.employs[0]['controller'].text.toString().toLowerCase()}",
"${Employ.employs[1]['controller'].text}",
"$passw",
"${Employ.employs[4]['controller'].text}",
"${Employ.employs[5]['controller'].text}",
${Employ.admin},
${Employ.mustchgpass},
${Employ.addremind},
${Employ.addtodo},
${Employ.addping},
${Employ.pbx}
);
''');
    var t = await DB().customquery(
        query:
            'select * from users where user_id=(Select MAX(user_id) from users);');
    Employ.mylista.add({});
    List pr = [], of = [];
    for (var i in t) {
      Employ.mylista[Employ.mylista.length - 1].addAll({
        'user_id': i[0],
        'username': i[1],
        'fullname': i[2],
        'admin': i[6],
        'enable': i[7],
        'mustchgpass': i[8],
        'addtodo': i[9],
        'addremind': i[10],
        'addping': i[11],
        'pbx': i[12],
        'check': true,
        'checkin': false,
        'visible': true
      });
      i[6] == 1 ? {pr.add('مسؤول'), of.add("=")} : null;
    }
    String privilegeforlog = '';

    if (Employ.privilege.isNotEmpty) {
      for (var i in Employ.privilege) {
        privilegeforlog += '''
${i['privilege']} ${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == i['office'])]['officename']}
''';
        await DB().customquery(query: '''
insert into users_office (uf_user_id,uf_office_id,privilege)values
(
${Employ.mylista[Employ.mylista.length - 1]['user_id']},
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == i['office'])]['office_id']},
"${i['privilege']}"
);
''');
      }
      var t = await DB().customquery(
          query:
              'select * from users_office where uf_user_id=(select Max(uf_user_id) from users_office where uf_id=(Select max(uf_id)from users_office));');
      for (var i in t) {
        pr.add(i[3]);
        of.add(i[2]);
      }
      Employ.mylista[Employ.mylista.length - 1].addAll({
        'privilege': [...pr],
        'office': [...of]
      });
    } else {
      if (pr.isEmpty) {
        pr.add("_");
        of.add("_");
      }
      Employ.mylista[Employ.mylista.length - 1].addAll({
        'privilege': [...pr],
        'office': [...of]
      });
    }
    DB.userstable.add(Employ.mylista[Employ.mylista.length - 1]);
    for (var i in of) {
      try {
        DB.officetable[DB.officetable
                .indexWhere((element) => element['office_id'] == i)]['users']
            .add(Employ.mylista[Employ.mylista.length - 1]['user_id']);
      } catch (e) {
        null;
      }
    }

    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']} 
بإضافة حساب ${Employ.employs[0]['controller'].text}
${Employ.employs[1]['controller'].text}
الصلاحيات
$privilegeforlog
''';
    Employ.admin == true ? "مسؤول" : null;
    Employ.addping == true ? "إضافة بينغ" : null;
    Employ.addremind == true ? "إضافة تذكير" : null;
    Employ.addtodo == true ? "إضافة إجرائية" : null;
    Employ.pbx == true ? "وصول لتسجيلات المقسم" : null;
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  addoffice() async {
    await DB().customquery(query: '''
insert into office
(officename,chatid,notifi,color)
values
(
"${Office.offices[0]['controller'].text}",
"${Office.offices[1]['controller'].text}",
${Office.notifi},
"${Office.selectcolor.toString().substring(Office.selectcolor.toString().indexOf('0x'), Office.selectcolor.toString().indexOf('0x') + 10)}"
);
''');
    var t = await DB().customquery(
        query:
            'select * from office where office_id=(Select max(office_id)from office);');
    Office.mylista.add({});
    for (var i in t) {
      Office.mylista[Office.mylista.length - 1].addAll({
        'office_id': i[0],
        'officename': i[1],
        'chatid': i[2],
        'notifi': i[3],
        'lastsendtask': i[4],
        'color': i[5],
        'autosendtasks': i[6],
        'lastsendremind': i[7],
        'users': [],
        'check': true,
        'visible': true
      });
    }
    DB.officetable.add(Office.mylista[Office.mylista.length - 1]);
    MYPAGE.officelist
        .add(Office.mylista[Office.mylista.length - 1]['officename']);
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']} 
بإضافة مكتب ${Office.offices[0]['controller'].text}
chatID ${Office.offices[1]['controller'].text}''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  addtodo() async {
    await DB().customquery(query: '''
insert into todo
(todoname,tododetails,createdate,todo_office_id)
values
(
"${Whattodo.todos[0]['controller'].text}",
"${Whattodo.todos[1]['controller'].text}",
"${DateTime.now()}",
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Whattodo.todoofficeNameselected)]['office_id']}
);
''');
    var todoid;
    var todoidT = await DB().customquery(
        query:
            "select todo_id from todo where todo_id=(Select MAX(todo_id) from todo);");
    for (var i in todoidT) {
      todoid = i[0];
    }
    await DB().customquery(query: '''
insert into users_todo
(createby_id,utd_todo_id)
values
(
${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == LogIn.username.text)]['user_id']},
$todoid
);
''');
    var t = await DB().customquery(
        query:
            'select * from todo where todo_id=(Select max(todo_id)from todo);');
    Whattodo.mylista.add({});
    for (var i in t) {
      Whattodo.mylista[Whattodo.mylista.length - 1].addAll({
        'todo_id': i[0],
        'todoname': i[1],
        'tododetails': i[2],
        'createdate': i[3],
        'editdate': i[4],
        'todo_office_id': i[5],
        'visible': true,
        'check': true
      });
    }
    var tt = await DB().customquery(
        query:
            'select * from users_todo where utd_id=(Select max(utd_id)from users_todo);');
    for (var i in tt) {
      Whattodo.mylista[Whattodo.mylista.length - 1].addAll({
        'createby_id': i[1],
        'createby': DB.userstable[DB.userstable
            .indexWhere((element) => element['user_id'] == i[1])]['fullname'],
        'commentdate': [],
        'comment': [],
        'waitsend': true,
        'error': null,
        'commentcontroller': TextEditingController(),
      });
    }

    for (var i in Whattodo.images) {
      try {
        await DB().customquery(query: '''
insert into todo_images
(images,ti_todo_id)values
(
"${await mainController.convertimagestodoTocode(image: i)}",
$todoid
);
''');
      } on Exception {
        null;
      } catch (e) {
        null;
      }
    }

    var imagest = await DB().customquery(
        query: 'select * from todo_images where ti_todo_id=$todoid;');
    var images = [];
    images.clear();
    for (var i in imagest) {
      images.add(i[2]);
    }
    Whattodo.mylista[Whattodo.mylista.length - 1].addAll({
      'images': [...images],
    });

    DB.todotable.add(Whattodo.mylista[Whattodo.mylista.length - 1]);
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']} 
بإضافة إجرائية ${Whattodo.todos[0]['controller'].text}
${Whattodo.todos[1]['controller'].text}''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  addtasks() async {
    await DB().customquery(query: '''
insert into tasks
(taskname,taskdetails,createby,createdate,duration,status,extratime,createby_id,notifi,task_office_id)
values
(
"${Tasks.tasks[0]['controller'].text}",
"${Tasks.tasks[1]['controller'].text}",
"${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}",
"${DateTime.now()}",
${Tasks.duration.toInt()},
0,
0,
${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']},
1,
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Tasks.taskofficeNameselected)]['office_id']}
);
''');

    var t0 = await DB().customquery(
        query:
            "select * from tasks where task_id=(Select MAX(task_id) from tasks);");
    Tasks.mylista.add({});
    for (var i in t0) {
      Tasks.mylista[Tasks.mylista.length - 1].addAll({
        'task_id': i[0],
        'taskname': i[1],
        'taskdetails': i[2],
        'createby_id': i[3],
        'createby': i[4],
        'createdate': i[5],
        'ediby_id': i[6],
        'editby': i[7],
        'editdate': i[8],
        'duration': i[9],
        'extratime': i[10],
        'status': i[11],
        'donedate': i[12],
        'notifi': i[13],
        'task_office_id': i[14],
        'visible': true,
        'check': true
      });
    }
    var taskid = Tasks.mylista[Tasks.mylista.length - 1]['task_id'];

    for (var i in Tasks.usersfortaskswidget) {
      await DB().customquery(query: '''
insert into users_tasks
(ut_user_id,ut_task_id)
values
(
${DB.userstable[DB.userstable.indexWhere((element) => element['fullname'] == i['name'])]['user_id']},
$taskid
);
''');
    }
    var t1 = await DB().customquery(
        query:
            'select * from users_tasks where ut_task_id=(select Max(ut_task_id) from users_tasks where ut_id=(Select max(ut_id)from users_tasks));');
    var users = [], usersname = [];
    users.clear();
    usersname.clear();
    for (var i in t1) {
      users.add(i[1]);
    }

    for (var i in users) {
      usersname.add(DB.userstable[DB.userstable
          .indexWhere((element) => element['user_id'] == i)]['fullname']);
    }
    Tasks.mylista[Tasks.mylista.length - 1].addAll({
      'userstask_id': [...users],
      'userstask_name': [...usersname],
      'commentdate': [],
      'comment': [],
      'waitsend': true,
      'error': null,
      'commentcontroller': TextEditingController(),
    });

    DB.tasktable.add(Tasks.mylista[Tasks.mylista.length - 1]);
    List usersintask = [];
    for (var i in Tasks.usersfortaskswidget) {
      usersintask.add(i['name']);
    }
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']} 
بإضافة مهمة ${Tasks.tasks[0]['controller'].text}
${Tasks.tasks[1]['controller'].text}
الموظفين المكلفين بالمهمة $usersintask
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  addcommenttodo({userid, todoid, comment}) async {
    await DB().customquery(query: '''
insert into users_todo_comments
(utdc_user_id,utdc_todo_id,comments,commentdate)
values
(
$userid,
$todoid,
"$comment",
"${DateTime.now()}"
);
''');

    await gettable(
        list: Whattodo.mylista,
        table: 'todo',
        tableid: 'todo_id',
        usertable: DB.userstable);
    update();
  }

  addcommentremind({userid, remindid, comment}) async {
    await DB().customquery(query: '''
insert into users_remind_comments
(urc
$userid,
$remindid,
"$comment",
"${DateTime.now()}"
);
''');

    await gettable(
        list: Remind.mylista,
        table: 'remind',
        tableid: 'remind_id',
        usertable: DB.userstable);
    update();
  }

  addcommenttask({userid, taskid, comment}) async {
    await DB().customquery(query: '''
insert into users_tasks_comments
(utc_user_id,utc_task_id,comments,commentdate)
values
(
$userid,
$taskid,
"$comment",
"${DateTime.now()}"
);
''');
    await gettable(
        list: Tasks.mylista,
        table: 'tasks',
        tableid: 'task_id',
        usertable: DB.userstable);
    update();
  }

  deleteuser({id}) async {
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}
بحذف حساب ${DB.userstable[DB.userstable.indexWhere((element) => element['user_id'] == id)]['username']}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    await DB().customquery(query: '''
update users_todo_comments set utdc_user_id=null where utdc_user_id=$id;''');
    await DB().customquery(query: '''
update users_todo set editby_id=null where editby_id=$id;''');
    await DB().customquery(query: '''
update users_todo set createby_id=null where createby_id=$id;''');
    await DB().customquery(query: '''
update users_tasks_comments set utc_user_id=null where utc_user_id=$id;''');
    await DB().customquery(query: '''
update tasks set createby_id=null,createby=null where createby_id=$id;''');
    await DB().customquery(query: '''
update tasks set editby_id=null,editby=null where editby_id=$id;''');
    await DB().customquery(query: '''
update users_remind_comments set urc_user_id=null where urc_user_id=$id;''');
    await DB().customquery(query: '''
update users_remind set createby_id=null where createby_id=$id;''');
    await DB().customquery(query: '''
update users_remind set editby_id=null where editby_id=$id;''');

    await DB().customquery(query: '''
delete from users_tasks where ut_user_id=$id;''');
    await DB().customquery(query: '''
delete from users_office where uf_user_id=$id;''');

    await DB().customquery(query: 'delete from users where user_id=$id;' '');
    Employ.mylista.removeWhere((element) => element['user_id'] == id);
    DB.userstable.removeWhere((element) => element['user_id'] == id);
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];

    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  deleteoffice({id}) async {
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}
بحذف مكتب ${DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == id)]['officename']}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    await DB().customquery(query: '''
update tasks set task_office_id=null where task_office_id=$id;''');
    await DB().customquery(query: '''
update todo set todo_office_id=null where todo_office_id=$id;''');
    await DB().customquery(query: '''
update remind set remind_office_id=null where remind_office_id=$id;''');
    await DB().customquery(query: '''
delete from users_office where uf_office_id=$id;''');
    await DB().customquery(query: '''
delete from office where office_id=$id;''');
    Office.mylista.removeWhere((element) => element['office_id'] == id);
    DB.officetable.removeWhere((element) => element['office_id'] == id);

    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];

    update();
  }

  deletetodo({id}) async {
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}
بحذف إجرائية ${DB.todotable[DB.todotable.indexWhere((element) => element['todo_id'] == id)]['todoname']}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    await DB().customquery(query: '''
delete from users_todo_comments where utdc_todo_id=$id;''');
    await DB().customquery(query: '''
delete from users_todo where utd_todo_id=$id; ''');
    await DB().customquery(query: '''
delete from todo_images where ti_todo_id=$id; ''');
    await DB().customquery(query: '''
delete from todo where todo_id=$id; ''');

    Whattodo.mylista.removeWhere((element) => element['todo_id'] == id);
    DB.todotable.removeWhere((element) => element['todo_id'] == id);
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];

    update();
  }

  deletetask({id}) async {
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}
بحذف مهمة ${DB.tasktable[DB.tasktable.indexWhere((element) => element['task_id'] == id)]['taskname']}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    await DB().customquery(query: '''
delete from users_tasks_comments where utc_task_id=$id;''');
    await DB().customquery(query: '''
delete from users_tasks where ut_task_id=$id;''');
    await DB().customquery(query: '''
delete from tasks where task_id=$id;''');

    Tasks.mylista.removeWhere((element) => element['task_id'] == id);
    DB.tasktable.removeWhere((element) => element['task_id'] == id);
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];

    update();
  }

  deleteprev({id}) async {
    await DB().customquery(query: '''
delete from users_office where uf_user_id=$id;''');
    update();
  }

  deletecomment(
      {table, commentIdname, commentId, maintablename, maintableidname}) async {
    await DB().customquery(query: '''
delete from $table where $commentIdname=$commentId;''');
    await gettable(
        list: Whattodo.mylista,
        table: maintablename,
        tableid: maintableidname,
        usertable: DB.userstable);
  }

  editcomment(
      {table,
      comment,
      commentIdname,
      commentId,
      maintablename,
      maintableidname}) async {
    await DB().customquery(query: '''
update $table set 
comments="$comment"
where $commentIdname=$commentId
''');
    await gettable(
        list: Whattodo.mylista,
        table: maintablename,
        tableid: maintableidname,
        usertable: DB.userstable);
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];
    update();
  }

  edituser({id}) async {
    String passw =
        codepassword(word: "${Employ.employs[2]['controller'].text}");
    Employ.employs[2]['controller'].text.isNotEmpty
        ? await DB().customquery(query: '''
update users set
username="${Employ.employs[0]['controller'].text}",
fullname="${Employ.employs[1]['controller'].text}",
password="$passw",
email="${Employ.employs[4]['controller'].text}",
mobile="${Employ.employs[5]['controller'].text}",
admin=${Employ.admin == true ? 1 : 0},
enable=${Employ.enable == true ? 1 : 0},
mustchgpass=${Employ.mustchgpass == true ? 1 : 0},
addremind=${Employ.addremind == true ? 1 : 0},
addping=${Employ.addping == true ? 1 : 0},
addtodo=${Employ.addtodo == true ? 1 : 0},
pbx=${Employ.pbx == true ? 1 : 0}
where user_id=$id;
''')
        : await DB().customquery(query: '''
update users set
username="${Employ.employs[0]['controller'].text}",
fullname="${Employ.employs[1]['controller'].text}",
email="${Employ.employs[4]['controller'].text}",
mobile="${Employ.employs[5]['controller'].text}",
admin=${Employ.admin == true ? 1 : 0},
enable=${Employ.enable == true ? 1 : 0},
mustchgpass=${Employ.mustchgpass == true ? 1 : 0},
addremind=${Employ.addremind == true ? 1 : 0},
addping=${Employ.addping == true ? 1 : 0},
addtodo=${Employ.addtodo == true ? 1 : 0},
pbx=${Employ.pbx == true ? 1 : 0}
where user_id=$id;
''');
    for (var i in Employ.privilege) {
      await DB().customquery(query: '''
insert into users_office 
(uf_user_id,uf_office_id,privilege)
values
(
$id,
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == i['office'])]['office_id']},
"${i['privilege']}"
);
''');
    }
    await gettable(
        list: Employ.mylista,
        table: 'users',
        tableid: 'user_id',
        usertable: DB.userstable);
    DB.userstable[
            DB.userstable.indexWhere((element) => element['user_id'] == id)] =
        Employ.mylista[
            Employ.mylista.indexWhere((element) => element['user_id'] == id)];
    try {
      for (var i in DB.officetable) {
        i['users'].removeWhere((e) => e == id);
      }
      for (var i in Employ.privilege) {
        DB.officetable[DB.officetable.indexWhere(
                (element) => element['officename'] == i['office'])]['users']
            .add(id);
      }
    } catch (e) {
      null;
    }
    update();
  }

  updatepassword({newpass, id}) async {
    String passw = codepassword(word: newpass);
    await DB().customquery(query: '''
  update users set 
  password="$passw",
  mustchgpass=0
  where user_id=$id;
  ''');
    update();
  }

  editoffice({id}) async {
    await DB().customquery(query: '''
update office set
officename="${Office.offices[0]['controller'].text}",
chatid="${Office.offices[1]['controller'].text}",
notifi=${Office.notifi == true ? 1 : 0},
color="${Office.selectcolor.toString().substring(Office.selectcolor.toString().indexOf('0x'), Office.selectcolor.toString().indexOf('0x') + 10)}"
where office_id=$id;
''');
    await gettable(
        usertable: DB.userstable,
        list: Office.mylista,
        table: 'office',
        tableid: 'office_id');
    DB.officetable[DB.officetable
            .indexWhere((element) => element['office_id'] == id)] =
        Office.mylista[
            Office.mylista.indexWhere((element) => element['office_id'] == id)];
    update();
  }

  edittodo({id}) async {
    await DB().customquery(query: '''
  update users_todo set
  editby_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}
  where utd_todo_id=$id;
  ''');
    await DB().customquery(query: '''
update todo set
todoname="${Whattodo.todos[0]['controller'].text}",
tododetails="${Whattodo.todos[1]['controller'].text}",
editdate="${DateTime.now()}",
todo_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Whattodo.todoofficeNameselected)]['office_id']}
where todo_id=$id;
''');
    await DB().customquery(query: '''
delete from todo_images where ti_todo_id=$id;
''');
    Whattodo.x = -1;
    for (var i in Whattodo.images) {
      if (i.runtimeType == Image) {
        Whattodo.x++;
      }
      try {
        await DB().customquery(query: '''
insert into todo_images
(images,ti_todo_id)values
(
"${await mainController.convertimagestodoTocode(image: i)}",
$id
);
''');
      } catch (e) {
        null;
      }
    }
    await gettable(
        usertable: DB.userstable,
        list: Whattodo.mylista,
        table: 'todo',
        tableid: 'todo_id');
    DB.todotable[
            DB.todotable.indexWhere((element) => element['todo_id'] == id)] =
        Whattodo.mylista[
            Whattodo.mylista.indexWhere((element) => element['todo_id'] == id)];
    update();
  }

  edittask({id}) async {
    await DB()
        .customquery(query: 'delete from users_tasks where ut_task_id=$id');
    await DB().customquery(query: '''
update tasks set taskname="${Tasks.tasks[0]['controller'].text}",
taskdetails="${Tasks.tasks[1]['controller'].text}",
status=${Tasks.taskstatus},
duration=${Tasks.duration.toInt()},
editdate="${DateTime.now()}",
extratime=${int.parse(Tasks.extratimecontroller.text)},
editby="${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}",
editby_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']},
task_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Tasks.taskofficeNameselected)]['office_id']}
where task_id=$id;
''');
    if (Tasks.taskstatus == true) {
      await DB().customquery(query: '''
update tasks set donedate="${DateTime.now()}" where task_id=$id;
''');
    }
    for (var i in Tasks.usersfortaskswidget) {
      await DB().customquery(query: '''
insert into users_tasks
(ut_user_id,ut_task_id)values
(${DB.userstable[DB.userstable.indexWhere((element) => element['fullname'] == i['name'])]['user_id']},
$id
);
''');
    }
    await gettable(
        usertable: DB.userstable,
        list: Tasks.mylista,
        table: 'tasks',
        tableid: 'task_id');
    DB.tasktable[
            DB.tasktable.indexWhere((element) => element['task_id'] == id)] =
        Tasks.mylista[
            Tasks.mylista.indexWhere((element) => element['task_id'] == id)];
    update();
  }

  changetasknotifi({notifi, id}) async {
    await DB().customquery(query: '''
update tasks set
notifi=$notifi
where task_id=$id;
''');
    await gettable(
        usertable: DB.userstable,
        list: Tasks.mylista,
        table: 'tasks',
        tableid: 'task_id');
    DB.tasktable[
            DB.tasktable.indexWhere((element) => element['task_id'] == id)] =
        Tasks.mylista[
            Tasks.mylista.indexWhere((element) => element['task_id'] == id)];
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];
    update();
  }

  updatepersonalinfo({fullname, mobile, email, id}) async {
    await DB().customquery(query: '''
update users set
fullname="$fullname",
mobile="$mobile",
email="$email"
where user_id=$id;
''');
    mainController.office_ids(offname: 'office_id');
    List<Map> users = [];

    await gettable(
      usertable: users,
      list: users,
      table: 'users',
      tableid: 'user_id',
    );
    DB.userstable[
            DB.userstable.indexWhere((element) => element['user_id'] == id)] =
        users[users.indexWhere((element) => element['user_id'] == id)];
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];
  }

  addremind() async {
    List every = [];
    if (Remind.typevalue == Remind.typelist[0]) {
      await DB().customquery(query: '''
insert into remind
(remindname,reminddetails,createdate,remind_office_id,type,startsendat,sendalertbefor,reminddate,`repeat`)
values
(
"${Remind.reminds[0]['controller'].text}",
"${Remind.reminds[1]['controller'].text}",
"${DateTime.now()}",
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
'0',
"${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
${Remind.sendalertbefor},
"${Remind.onetimeremid}",
${Remind.repeat}
);
''');
    } else if (Remind.typevalue == Remind.typelist[1]) {
      await DB().customquery(query: '''
insert into remind
(remindname,reminddetails,createdate,remind_office_id,type,startsendat,sendalertbefor,manytimestype,`repeat`)
values
(
"${Remind.reminds[0]['controller'].text}",
"${Remind.reminds[1]['controller'].text}",
"${DateTime.now()}",
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
'1',
"${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
${Remind.sendalertbefor},
${Remind.manytimesremindgroup == Remind.manytimesremindlist[0] ? "0" : "1"},
${Remind.repeat}
);
''');
    } else if (Remind.typevalue == Remind.typelist[2]) {
      await DB().customquery(query: '''
insert into remind
(remindname,reminddetails,createdate,remind_office_id,type,startsendat,sendalertbefor,`repeat`)
values
(
"${Remind.reminds[0]['controller'].text}",
"${Remind.reminds[1]['controller'].text}",
"${DateTime.now()}",
${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
'2',
"${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
${Remind.sendalertbefor},
${Remind.repeat}
);
''');
    }

    var remindid;
    var remindidT = await DB().customquery(
        query:
            "select remind_id from remind where remind_id=(Select MAX(remind_id) from remind);");
    for (var i in remindidT) {
      remindid = i[0];
    }
    if (Remind.typevalue == Remind.typelist[1]) {
      if (Remind.manytimesremindgroup == Remind.manytimesremindlist[0]) {
        String day = '';
        for (var i in Remind.weekly) {
          if (i['check'] == true) {
            switch (i['day']) {
              case 'الجمعة':
                day = 'friday';
                break;
              case 'السبت':
                day = 'satarday';
                break;
              case 'الأحد':
                day = 'sunday';
                break;
              case 'الاثنين':
                day = 'monday';
                break;
              case 'الثلاثاء':
                day = 'tuesday';
                break;
              case 'الأربعاء':
                day = 'wednesday';
                break;
              case 'الخميس':
                day = 'thursday';
                break;
            }
            await DB().customquery(query: '''
insert into remind_every
(revery_remind_id,every)
values
(
$remindid,
"$day"
);
''');
          }
        }
      } else {
        for (var i in Remind.monthly) {
          String day = '';
          if (i['check'] == true) {
            if (i['day'].contains("يوم")) {
              day = 'last';
            } else {
              day = i['day'];
            }
            await DB().customquery(query: '''
insert into remind_every
(revery_remind_id,every)
values
(
$remindid,
"$day"
);
''');
          }
        }
      }
    }
    await MainController()
        .getreminddate(certsrc: Remind.autoCertificateurl.text, id: remindid);
    await DB().customquery(query: '''
insert into users_remind
(createby_id,createdate,ur_remind_id)
values
(
${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']},
"${DateTime.now()}",
$remindid
);
''');
    var t = await DB()
        .customquery(query: 'select * from remind where remind_id=$remindid');
    Remind.mylista.add({});
    for (var i in t) {
      Remind.mylista[Remind.mylista.length - 1].addAll({
        'remind_id': i[0],
        'remindname': i[1],
        'reminddetails': i[2],
        'createdate': i[3],
        'editdate': i[4],
        'remind_office_id': i[5],
        'notifi': i[6],
        'status': i[7],
        'type': i[8],
        'lastsend': i[9],
        'repeat': i[10],
        'reminddate': i[11],
        'startsendat': i[12],
        'sendalertbefor': i[13],
        'autocerturl': i[14],
        'manytimestype': i[15],
        'pause': i[16],
        'pausedate': i[17],
        'visible': true,
        'check': true
      });
    }
    var evt = await DB().customquery(
        query:
            'select every from remind_every where revery_remind_id=(select Max(revery_remind_id) from remind_every where revery_id=(Select max(revery_id)from remind_every));');
    every.clear();
    for (var evr in evt) {
      every.add(evr[0]);
    }
    Remind.mylista[Remind.mylista.length - 1].addAll({
      'every': [...every]
    });

    var tt = await DB().customquery(
        query:
            'select * from users_remind where ur_id=(Select max(ur_id)from users_remind);');
    for (var i in tt) {
      Remind.mylista[Remind.mylista.length - 1].addAll({
        'createby_id': i[1],
        'createby': DB.userstable[DB.userstable
            .indexWhere((element) => element['user_id'] == i[1])]['fullname'],
        'createdate': i[2],
        'editby_id': i[3],
        'editdate': i[4],
        'commentdate': [],
        'comment': [],
        'waitsend': true,
        'error': null,
        'commentcontroller': TextEditingController(),
      });
    }
    DB.remindtable.add(Remind.mylista[Remind.mylista.length - 1]);
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']} 
بإضافة تذكير ${Remind.reminds[0]['controller'].text}
${Remind.reminds[1]['controller'].text}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    update();
  }

  editremind({id}) async {
    await DB().customquery(query: '''
  update users_remind set
  editby_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']},
  editdate="${DateTime.now()}"
  where ur_remind_id=$id;
  ''');

    if (Remind.typevalue == Remind.typelist[0]) {
      await DB().customquery(query: '''
update remind set
remindname="${Remind.reminds[0]['controller'].text}",
reminddetails="${Remind.reminds[1]['controller'].text}",
editdate="${DateTime.now()}",
remind_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
type='0',
startsendat="${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
sendalertbefor=${Remind.sendalertbefor},
reminddate="${Remind.onetimeremid}",
`repeat`=${Remind.repeat},
autocerturl=null
where remind_id=$id;
''');
    } else if (Remind.typevalue == Remind.typelist[1]) {
      await DB().customquery(query: '''
update remind set
remindname="${Remind.reminds[0]['controller'].text}",
reminddetails="${Remind.reminds[1]['controller'].text}",
editdate="${DateTime.now()}",
remind_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
type='1',
startsendat="${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
sendalertbefor=${Remind.sendalertbefor},
manytimestype=${Remind.manytimesremindgroup == Remind.manytimesremindlist[0] ? "0" : "1"},
`repeat`=${Remind.repeat},
reminddate=null,
autocerturl=null
where remind_id=$id;
''');
    } else if (Remind.typevalue == Remind.typelist[2]) {
      await DB().customquery(query: '''
update remind set
remindname="${Remind.reminds[0]['controller'].text}",
reminddetails="${Remind.reminds[1]['controller'].text}",
editdate="${DateTime.now()}",
remind_office_id=${DB.officetable[DB.officetable.indexWhere((element) => element['officename'] == Remind.remindofficeNameselected)]['office_id']},
type='2',
startsendat="${Remind.hourlystartremindvalue.hour}:${Remind.hourlystartremindvalue.minute}",
sendalertbefor=${Remind.sendalertbefor},
`repeat`=${Remind.repeat},
reminddate=null
where remind_id=$id;
''');
    }
    await DB().customquery(
        query: 'delete from remind_every where revery_remind_id=$id;');
    if (Remind.typevalue == Remind.typelist[1]) {
      if (Remind.manytimesremindgroup == Remind.manytimesremindlist[0]) {
        String day = '';
        for (var i in Remind.weekly) {
          if (i['check'] == true) {
            switch (i['day']) {
              case 'الجمعة':
                day = 'friday';
                break;
              case 'السبت':
                day = 'satarday';
                break;
              case 'الأحد':
                day = 'sunday';
                break;
              case 'الاثنين':
                day = 'monday';
                break;
              case 'الثلاثاء':
                day = 'tuesday';
                break;
              case 'الأربعاء':
                day = 'wednesday';
                break;
              case 'الخميس':
                day = 'thursday';
                break;
            }
            await DB().customquery(query: '''
insert into remind_every
(revery_remind_id,every)
values
(
$id,
"$day"
);
''');
          }
        }
      } else {
        for (var i in Remind.monthly) {
          String day = '';
          if (i['check'] == true) {
            if (i['day'].contains("يوم")) {
              day = 'last';
            } else {
              day = i['day'];
            }
            await DB().customquery(query: '''
insert into remind_every
(revery_remind_id,every)
values
(
$id,
"$day"
);
''');
          }
        }
      }
    }
    await MainController()
        .getreminddate(certsrc: Remind.autoCertificateurl.text, id: id);
    await gettable(
        usertable: DB.userstable,
        list: Remind.mylista,
        table: 'remind',
        tableid: 'remind_id');
    DB.remindtable[DB.remindtable
            .indexWhere((element) => element['remind_id'] == id)] =
        Remind.mylista[
            Remind.mylista.indexWhere((element) => element['remind_id'] == id)];
    update();
  }

  deleteremind({id}) async {
    String log = '';
    log = '''
قام ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}
بحذف تذكير ${DB.remindtable[DB.remindtable.indexWhere((element) => element['remind_id'] == id)]['remindname']}
''';
    await DB().customquery(
        query:
            'insert into logs (content,logdate)values("$log","${DateTime.now()}")');
    await DB().customquery(query: '''
delete from users_remind where ur_remind_id=$id;''');
    await DB().customquery(query: '''
delete from remind_every where revery_remind_id=$id;''');
    await DB().customquery(query: '''
delete from remind where remind_id=$id;''');
    Remind.mylista.removeWhere((element) => element['remind_id'] == id);
    DB.remindtable.removeWhere((element) => element['remind_id'] == id);
    Home.searchlist = [
      ...DB.officetable,
      ...DB.userstable,
      ...DB.tasktable,
      ...DB.todotable,
      ...DB.remindtable
    ];

    update();
  }
}
