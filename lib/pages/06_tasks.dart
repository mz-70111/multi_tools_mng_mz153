// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teledart/teledart.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
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
  static List<Map> mylista = [];
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
      'maxlines': 3
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
    List items(i) => [
          {
            'item': [
              [
                {'i': 'task_id', 'w': Text("$i")},
                {'i': 'taskname', 'w': Text("$i")}
              ],
              // ['status'],
              // ['userstask_name']
            ]
          },
          // {
          //   'item': [
          //     ['notifi']
          //   ]
          // },
        ];
    Map addFunction = {
      'action': () => addtask(),
      'addlabel': 'إضافة حساب جديد',
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
                              ['user_id']);
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
      items: items(MYPAGE.eE),
      notifi: const SizedBox(),
      addlabel: addFunction['addlabel'],
      action: addFunction['action'],
      customInitdataforAdd: () => customInitforAdd(),
      customWidgetofADD: customWidgetofADD(),
      customInitforEdit: () => customInitforEdit(e: MYPAGE.eE),
      customWidgetofEdit: customWidgetofEdit(),
      textfeildlista: tasks,
      scrollController: scrollController,
      mainEditvisible: checkifUserisAdmin() == true ? true : false,
      mainAddvisible: checkifUserisAdmin() == true ? true : false,
      getinfo: () => getinfo(e: MYPAGE.eE, ctx: context),
      actionSave: () => edittask(e: MYPAGE.eE),
      actionEdit: () => mainController.showeditpanel(),
      actionDelete: () => deletetask(),
    );
  }

  getinfo({e, ctx}) {
    buildcomment(mylista: mylista);
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

  customInitforEdit({e}) {
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
    for (var i in e['userstask_name']) {
      usersfortasks.add(i);
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

  deletetask({ctx, e}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Tasks);
  }
}

updateafteredit({e}) {
  e['taskname'] = Tasks.tasks[0]['controller'].text;
  e['taskdetails'] = Tasks.tasks[1]['controller'].text;
  e['notifi'] = Tasks.notifi == true ? 1 : 0;
  e['duration'] = Tasks.duration.toInt();
  e['extratime'] = int.parse(Tasks.extratimecontroller.text);
}
