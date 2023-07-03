// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teledart/teledart.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

class Tasks extends StatelessWidget {
  Tasks({super.key});
  DBController dbController = Get.find();
  static TextEditingController taskname = TextEditingController();
  static TextEditingController taskdetails = TextEditingController();
  static TextEditingController extratimecontroller =
      TextEditingController(text: '0');
  static TextEditingController commentcontrolleredit = TextEditingController();
  static String? extratimecontrollererror;
  static String? taskofficeNameselected;
  static List taskofficelist = [];
  static List<Map> mylista = [], comment = [];
  static double duration = 7;
  static bool taskstatus = false, notifi = true;
  static String taskstatus0() =>
      taskstatus == true ? " > منجزة <" : "> غير منجزة <";
  static List usersfortasks = [];
  static List usersfortaskswidget = [];
  static List<Map> tasks = [
    {
      'label': 'اسم المهمة',
      'controller': taskname,
      'error': null,
      'icon': Icons.whatshot,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.rtl
    },
    {
      'label': 'تفاصيل',
      'controller': taskdetails,
      'error': null,
      'icon': Icons.details,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.rtl,
      'maxlines': 5
    },
  ];
  static DateTime sortbydatebegin = DateTime.parse('2022-10-01');
  static DateTime sortbydateend = DateTime.now();
  static ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    List mainColumn = [
      {
        'label': 'اسم المهمة',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'taskname');
        }
      },
      {
        'label': 'حالة المهمة',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'status');
        }
      },
      {'label': 'المكلف بالمهمة', 'icon': Icons.people, 'action': null},
    ];
    List itemskey = [
      'task_office_id',
      'task_id',
      'taskname',
      'status',
      'userstask_name',
    ];
    List itemResult = [];
    List colors = [];
    Widget itemsWidget() {
      colors.clear();
      colors.add(DB.officetable[DB.officetable
              .indexWhere((element) => element['office_id'] == itemResult[0])]
          ['color']);
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...colors.map((c) =>
                  Container(height: 40, width: 10, color: Color(int.parse(c)))),
              Expanded(child: Text("# ${itemResult[1]}_ ${itemResult[2]}")),
              Expanded(child: Text(itemResult[3] == 1 ? "منجزة" : "غير منجزة")),
              Expanded(
                  child:
                      Column(children: [...itemResult[4].map((t) => Text(t))]))
            ],
          ),
        ),
        const Divider(),
      ]);
    }

    Map addFunction = {
      'action': () => addtask(),
      'addlabel': 'إضافة مهمة جديدة',
    };
    Widget customWidgetofADD() => GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
              const Row(children: [
                Expanded(child: Text("المدة المحددة لانجاز المهمة")),
              ]),
              Row(children: [
                Expanded(
                  flex: 2,
                  child: Slider(
                      min: 1,
                      max: 30,
                      divisions: 30,
                      value: Tasks.duration,
                      label: Tasks.duration.toInt().toString(),
                      onChanged: (x) {
                        mainController.taskduration(x);
                      }),
                ),
                Text(Tasks.duration.toInt().toString()),
                const Text("يوم")
              ]),
              Row(children: [
                const Text("اختيار مكتب"),
                DropdownButton(
                  value: taskofficeNameselected,
                  items: taskofficelist
                      .map((e) => DropdownMenuItem(value: "$e", child: Text(e)))
                      .toList(),
                  onChanged: (x) {
                    mainController.chooseofficetask(x);
                  },
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    onPressed: () {
                      mainController.addusertotask(
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] == Home.logininfo)]
                              ['user_id'],
                          scrollcontroller: scrollController);
                    },
                    icon: const Icon(Icons.add)),
                const Text("تعيين موظف"),
              ]),
              Column(
                children: Tasks.usersfortaskswidget
                    .map((e) => Usersoftasks(
                          user: e['name'],
                          selectuser: (x) => mainController.selectuser(
                              x, Tasks.usersfortaskswidget.indexOf(e)),
                          index: Tasks.usersfortaskswidget.indexOf(e),
                        ))
                    .toList(),
              ),
            ]));
    Widget customWidgetofEdit() =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          customWidgetofADD(),
          const Divider(),
          GetBuilder<MainController>(
            init: mainController,
            builder: (_) => Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                        child: Text("تمديد تاريخ انتهاء المدة الزمنية الى")),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextFieldMZ(
                            onChanged: (x) => null,
                            label: "أدخل عدد الايام",
                            error: Tasks.extratimecontrollererror,
                            textEditingController: Tasks.extratimecontroller)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          GetBuilder<MainController>(
            init: mainController,
            builder: (_) => Row(
              children: [
                const Text("حالة المهمة"),
                Switch(
                    value: Tasks.taskstatus,
                    onChanged: (bool x) {
                      mainController.taskstatuschg(x);
                    }),
                Text(Tasks.taskstatus0())
              ],
            ),
          ),
        ]);
    return MYPAGE(
      mylista: mylista,
      table: 'tasks',
      tableId: 'task_id',
      page: Tasks,
      searchRange: const ['taskname', 'userstask_name'],
      mainColumn: mainColumn,
      items: itemskey,
      itemsResult: itemResult,
      itemsWidget: () => itemsWidget(),
      notifi: const SizedBox(),
      addlabel: addFunction['addlabel'],
      action: addFunction['action'],
      customInitdataforAdd: () => customInitforAdd(),
      customWidgetofADD: customWidgetofADD(),
      customInitforEdit: () => customInitforEdit(e: MYPAGE.eE),
      customWidgetofEdit: customWidgetofEdit(),
      textfeildlista: tasks,
      scrollController: scrollController,
      mainEditvisible: () {
        return (checkifUserisAdmin() == true ||
                checkifUserisSupervisorinOffice(
                        officeid: MYPAGE.eE['task_office_id']) ==
                    true)
            ? true
            : false;
      },
      subeditvisible: () => checkifUserisSupervisorinOffice(
                  officeid: MYPAGE.eE['task_office_id']) ==
              true
          ? true
          : false,
      mainAddvisible:
          checkifUserisSupervisorinAnyOffice() == true ? true : false,
      getinfo: () {
        return getinfo(
          e: MYPAGE.eE,
          ctx: context,
        );
      },
      actionSave: () => edittask(e: MYPAGE.eE),
      actionEdit: () => mainController.showeditpanel(),
      actionDelete: () => deletetask(ctx: context, e: MYPAGE.eE),
    );
  }

  getinfo({e, ctx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$taskofficeNameselected"),
        SelectableText('''
              # ${e['task_id']} ${e['taskname']}
              ${e['taskdetails']}
              '''),
        const Divider(),
        Text(e['createby_id'] != null
            ? 'تم إنشاءها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['createdate'])} بواسطة ${DB.userstable[DB.userstable.indexWhere((y) => y['user_id'] == e['createby_id'])]['fullname']}'
            : ' تم إنشاءها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['createdate'])} بواسطة حساب محذوف'),
        Visibility(
          visible: e['editdate'] == null ? false : true,
          child: Text(e['editby_id'] != null
              ? 'تم تعديلها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['editdate'] ?? DateTime.now())} بواسطة ${DB.userstable[DB.userstable.indexWhere((y) => y['user_id'] == e['editby_id'])]['fullname']}'
              : 'تم تعديلها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['editdate'] ?? DateTime.now())} بواسطة حساب محذوف'),
        ),
        const Divider(),
        Text("الوقت المحددة لإنجاز المهمة < '${e['duration']}' > يوم/أيام"),
        Visibility(
            visible: e['extratime'] == 0 ? false : true,
            child: Text(
                "الوقت المضاف لإنجاز المهمة < '${e['extratime']}' > يوم/أيام")),
        const Divider(),
        const Text("الموظفين المكلفين بالمهمة"),
        Column(
          children: [...e['userstask_name'].map((e) => Text(e))],
        ),
        const Divider(),
        Text(
            "التاريخ النهائي لإنجاز المهمة ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['createdate'].add(Duration(days: e['duration'] + e['extratime'])))}"),
        const Divider(),
        Visibility(
          visible: e['status'] == 1 ? false : true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e['createdate']
                              .add(Duration(
                                  days: e['duration'] + e['extratime']))
                              .difference(DateTime.now())
                              .inDays >
                          0
                      ? "المدة المتبقية لإنجاز المهمة  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays} يوم"
                      : e['createdate']
                                  .add(Duration(
                                      days: e['duration'] + e['extratime']))
                                  .difference(DateTime.now())
                                  .inDays ==
                              0
                          ? "المدة المتبقية لإنجاز المهمة منتهية منذ  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inHours} ساعة"
                          : "المدة المتبقية لإنجاز المهمة منتهية منذ  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays} يوم",
                  style: TextStyle(
                    color: (e['createdate']
                                .add(Duration(
                                    days: e['duration'] + e['extratime']))
                                .difference(DateTime.now())
                                .inDays <=
                            0
                        ? Colors.red
                        : Colors.green),
                  ),
                ),
              )
            ],
          ),
        ),
        Text(
          "حالة المهمة : ${e['status'] == 1 ? 'منجزة' : 'غير منجزة'}",
          style: TextStyle(
              color: e['status'] == 1 ? Colors.green : Colors.redAccent),
        ),
        Visibility(
            visible: e['status'] == 0 ? false : true,
            child: Row(children: [
              Text(
                  " أنجزت بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['donedate'] ?? DateTime.now())}"),
            ])),
        Comment(
          e: e,
          comment: comment,
          deletecomment: () => deletecomment(ctx: ctx, e: e),
          editcomment: () => editcomment(ctx: ctx, e: e),
          table: 'users_tasks_comments',
          tableIdname: 'utc_task_id',
          tableId: e['task_id'],
          officeId: e['task_office_id'],
          userIdname: 'utc_user_id',
        ),
        WriteComment(e: e, writeComment: () => addcomment(e: MYPAGE.eE))
      ],
    );
  }

  static mymsgTask({e}) {
    String mymsg = """
اسم المهمة ${e['taskname']}
التفاصيل:\n ${e['taskdetails']}
تم انشاءها بتاريخ ${df.DateFormat('yyyy-MM-dd || HH:mm').format(e['createdate'])} بواسطة ${e['createby'] ?? 'حساب محذوف'}
${e['editdate'] != null ? "تم تعديلها بتاريخ ${df.DateFormat('yyyy-MM-dd || HH:mm').format(e['editdate'])} بواسطة ${e['editby'] ?? 'حساب محذوف'}" : ''}
الموظفين المكلفين بالمهمة \n ${e['userstask_name']}
${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays > 0 ? "المدة المتبقية لإنجاز المهمة  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays} يوم" : e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays == 0 ? "المدة المتبقية لإنجاز المهمة منتهية منذ  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inHours} ساعة" : "المدة المتبقية لإنجاز المهمة منتهية منذ  ${e['createdate'].add(Duration(days: e['duration'] + e['extratime'])).difference(DateTime.now()).inDays} يوم"}
حالة المهمة  ${e['status'] == 1 ? 'منجزة' : 'غير منجزة'}
=========
""";
    return mymsg;
  }

  static sendtask({msg, chatid}) async {
    String apitoken = '5642405200:AAGOphV_UpNdPBKLC7PtW4PN2Vb4CLBAS5o';
    try {
      await TeleDart(apitoken, Event('send')).sendMessage(chatid, msg);
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  customInitforAdd() {
    notifi = true;
    taskofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisSupervisorinOffice(officeid: i['office_id']) == true) {
        taskofficelist.add(i['officename']);
      }
    }
    taskofficeNameselected = taskofficelist[0];
    usersfortasks.clear();
    usersfortaskswidget.clear();
    duration = 7;
    extratimecontroller.text = 0.toString();
  }

  customInitforEdit({e}) async {
    for (var i in Tasks.tasks) {
      i['error'] = null;
    }
    Tasks.extratimecontrollererror = null;
    taskofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisSupervisorinOffice(officeid: i['office_id']) == true) {
        taskofficelist.add(i['officename']);
      }
    }
    taskofficeNameselected = DB.officetable[DB.officetable.indexWhere(
            (element) => element['office_id'] == e['task_office_id'])]
        ['officename'];
    Tasks.duration = e['duration'].toDouble();
    Tasks.extratimecontroller.text = e['extratime'].toString();
    Tasks.taskname.text = e['taskname'];
    Tasks.taskdetails.text = e['taskdetails'];
    usersfortasks.clear();
    usersfortaskswidget.clear();
    await getofficeUsers(
        list: Tasks.usersfortasks,
        officeid: DB.officetable[DB.officetable.indexWhere((element) =>
                element['officename'] == Tasks.taskofficeNameselected)]
            ['office_id']);
    for (var i in e['userstask_name']) {
      usersfortaskswidget.add({'i': 0, 'name': i});
    }
  }

  addtask() async {
    MainController mainController = Get.find();
    await mainController.addItemMainController(
        page: Tasks,
        listofFeildmz: Tasks.tasks,
        itemnameController: Tasks.taskname.text,
        scrollcontroller: Tasks.scrollController);
  }

  edittask({e}) async {
    MainController mainController = Get.find();

    await mainController.editItemMainController(
        page: Tasks, e: MYPAGE.eE, listofFeildmz: Tasks.tasks);
    updateafteredit(e: e);
  }

  updateafteredit({e}) {
    e['taskname'] = Tasks.tasks[0]['controller'].text;
    e['taskdetails'] = Tasks.tasks[1]['controller'].text;
    e['notifi'] = Tasks.notifi == true ? 1 : 0;
    e['duration'] = Tasks.duration.toInt();
    e['extratime'] = int.parse(Tasks.extratimecontroller.text);
  }

  deletetask({ctx, e}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Tasks);
  }

  addcomment({e}) async {
    if (e['commentcontroller'].text.isNotEmpty) {
      await mainController.addcomment(
        e: e,
        addcommentaction: dbController.addcommenttask(
            userid: DB.userstable[DB.userstable.indexWhere(
                (element) => element['username'] == Home.logininfo)]['user_id'],
            taskid: e['task_id'],
            comment: e['commentcontroller'].text),
      );
    }
  }

  deletecomment({e, ctx, actiondelete}) async {
    await deletecommentT(
        ctx: ctx,
        actiondelete: () async => await dbController.deletecomment(
            table: 'users_tasks_comments',
            commentIdname: 'utc_id',
            commentId: Comment.Ee['utc_id'],
            maintableidname: e['task_id'],
            maintablename: 'tasks'));
  }

  editcomment({e, ctx, actionedit}) async {
    commentcontrolleredit.text = Comment.Ee['comments'];
    await editcommentT(
        ctx: ctx,
        controller: commentcontrolleredit,
        actionedit: () async => await dbController.editcomment(
            table: 'users_tasks_comments',
            commentIdname: 'utc_id',
            commentId: Comment.Ee['utc_id'],
            maintableidname: e['task_id'],
            maintablename: 'tasks',
            comment: commentcontrolleredit.text));
  }
}
