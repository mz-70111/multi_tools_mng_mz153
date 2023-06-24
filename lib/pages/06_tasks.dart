// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teledart/teledart.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

MainController mainController = Get.find();

class Tasks extends StatelessWidget {
  Tasks({super.key});
  DBController dbController = Get.find();
  static String? errorcomment;
  static bool editcommentwait = false;
  static TextEditingController taskname = TextEditingController();
  static TextEditingController taskdetails = TextEditingController();
  static TextEditingController extratimecontroller =
      TextEditingController(text: '0');
  static TextEditingController commentcontrolleredit = TextEditingController();
  static String? extratimecontrollererror;
  static bool addwaitvis = false;
  static bool editvisible = false;
  static bool editsavevisible = true;
  static String? taskofficeNameselected;
  static List taskofficelist = [];
  static double dialogeBegin = 1000;
  static double dialogeEnd = 0;
  static IconData addicon = Icons.add;
  static List<Map> mylista = [];
  static String? errormsg;
  static late int taskid;
  static bool edittask = false;
  static double duration = 7;
  static bool createbyvis = false;
  static bool taskstatus = false;
  static List temp = [];
  static List taskschecktrue = [];
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
  static List dbtasktableAction = [
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
  static List easyeditask({e, ctx}) => [
        {
          'invisible': true,
          'visible': DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                          ['user_id'] ==
                      e['createby_id'] ||
                  DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                          ['admin'] ==
                      1 ||
                  mainController.checkifuserSupervisor(
                          officeid: e['task_office_id'],
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) => element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
              ? true
              : false,
          'icon': Icons.delete,
          'action': () async {
            Get.back();
            await mainController.deleteItemMainController(
              ctx: ctx,
              page: Tasks,
            );
          },
          'color': Colors.redAccent
        },
        {
          'invisible': editsavevisible,
          'visible': DB.userstable[DB.userstable.indexWhere(
                              (element) => element['username'] == Home.logininfo)]
                          ['user_id'] ==
                      e['createby_id'] ||
                  mainController.checkifuserSupervisor(
                          officeid: e['task_office_id'],
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
              ? true
              : false,
          'icon': Icons.send_outlined,
          'action': () async {
            await mainController.directsendTask(
                e: e, ctx: ctx, officeid: e['office_id']);
          },
          'color': Colors.greenAccent
        },
        {
          'invisible': editsavevisible,
          'visible': e['status'] == 1
              ? false
              : DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['user_id'] ==
                          e['createby_id'] ||
                      mainController.checkifuserSupervisor(
                              officeid: e['task_office_id'],
                              userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] ==
                                      Home.logininfo)]['user_id']) ==
                          true
                  ? true
                  : false,
          'icon': Icons.edit,
          'action': () async {
            await mainController.showeditpanel();
          },
          'color': Colors.indigoAccent
        },
        {
          'invisible': !editsavevisible,
          'visible': true,
          'icon': Icons.save,
          'action': () async {
            taskid = e['task_id'];
            await mainController.editItemMainController(
              page: Tasks,
              // pagelisttextfeild: tasks,
              // editsavevisible: editsavevisible
            );
          },
          'color': Colors.indigoAccent
        }
      ];
  static List easyeditaskcomment({ctx, commentid, commenttext, usercomment}) =>
      [
        {
          'visible': true,
          'icon': Icons.delete,
          'action': () async {},
          'color': Colors.grey
        },
        {
          'visible': DB.userstable[DB.userstable.indexWhere(
                          (element) => element['username'] == Home.logininfo)]
                      ['fullname'] ==
                  usercomment
              ? true
              : false,
          'icon': Icons.edit,
          'action': () async {
            commentcontrolleredit.text = commenttext;
            await mainController.editcomment(
              page: Tasks,
              ctx: ctx,
              errorcomment: errorcomment,
              commentid: commentid,
              editcommentwait: editcommentwait,
              commentcontrolleredit: commentcontrolleredit,
            );
          },
          'color': Colors.grey
        }
      ];
  static List<Widget> customWidgetofADD() => [
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
                            (element) => element['username'] == Home.logininfo)]
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
      ];
  Widget actionadd({action}) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !addwaitvis,
                    child: TextButton.icon(
                        onPressed: () async {
                          mainController.addItemMainController(
                            scrollcontroller: ScrollController(),
                            page: Tasks,
                            itemnameController: taskname.text,
                            listofFeildmz: tasks,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "إضافة مهمة جديدة",
                        )),
                  ),
                  Visibility(
                      visible: addwaitvis,
                      child: const CircularProgressIndicator())
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: Tasks.errormsg == null ? false : true,
          child: Text(
            Tasks.errormsg ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ]);
  static List customWidgetofEdit({ctx}) => [
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
        const Divider(),
        Column(
          children: [
            const Row(
              children: [
                Expanded(child: Text("تمديد تاريخ انتهاء المدة الزمنية الى")),
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
        const Divider(),
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
                            (element) => element['username'] == Home.logininfo)]
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
        const Divider(),
        Row(
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
      ];
  static bool commentvisible = false;
  static String officelistvalue = 'مخصص';
  static DateTime sortbydatebegin = DateTime.parse('2022-10-01');
  static DateTime sortbydateend = DateTime.now();
  static List tempforgetdate = [];
  static bool selectall = false;
  static bool deletewait = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<DBController>(
        init: dbController,
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              FutureBuilder(future: Future(() async {
                try {
                  return await dbController.gettable(
                    list: mylista,
                    tableid: 'task_id',
                    table: 'tasks',
                  );
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
                  if (!DB.userstable[DB.userstable.indexWhere((element) =>
                          element['username'] == Home.logininfo)]['privilege']
                      .contains("مشرف")) {
                    Future(() => mainController.snakbar(
                        context, 'لست مشرفا في اي مكتب لا يمكنك اضافة مهام'));
                  }
                  return GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) {
                        if (DB.todotable.isEmpty) {
                          return const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("لا يوجد اي مهمة مضافة الى الآن")
                                ]),
                          );
                        } else {
                          List checkallvaluetrue = [];
                          List officelist = ['جميع النتائج', 'مخصص'];
                          for (var i in DB.officetable) {
                            officelist.add(i['officename']);
                          }
                          checkallvaluetrue.clear();
                          temp.clear();
                          for (var j in Home.searchlist) {
                            if (j['check'] == true) {
                              checkallvaluetrue.add('1');
                              if (j.keys.toList().first == 'office_id') {
                                temp.add(j['officename']);
                              }
                            }
                          }
                          if (checkallvaluetrue.length ==
                              Home.searchlist.length) {
                            officelistvalue = 'جميع النتائج';
                          } else if (temp.length == 1) {
                            officelistvalue = temp[0];
                          } else {
                            officelistvalue = 'مخصص';
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  //sort by office
                                  Visibility(
                                      visible: DB.officetable.isNotEmpty
                                          ? true
                                          : false,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: DropdownButton(
                                              value: officelistvalue,
                                              items: officelist
                                                  .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text("$e")))
                                                  .toList(),
                                              onChanged: (x) {
                                                mainController.chooseoffice(x);
                                                dbController.update();
                                              }),
                                        ),
                                      )),
                                  Expanded(
                                    child: TextFieldMZ(
                                        label: "بحث",
                                        onChanged: (word) {
                                          mainController.search(
                                              word: word,
                                              list: mylista,
                                              range: [
                                                'task_id',
                                                'taskname',
                                                'taskdetails',
                                                'userstask_name',
                                                'comment'
                                              ]);
                                        }),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            "من ${df.DateFormat('yyyy-MM-dd').format(sortbydatebegin)}",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        TextButton.icon(
                                            onPressed: () {
                                              mainController.choosedate(
                                                  ctx: context,
                                                  beginorend: 'end');
                                            },
                                            icon: const Icon(Icons.date_range),
                                            label: Text(
                                              "إلى ${df.DateFormat('yyyy-MM-dd').format(sortbydateend)}",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            )),
                                      ]),
                                ),
                              ),
                              Row(children: [
                                ...dbtasktableAction
                                    .map((e) => Expanded(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: e['action'],
                                                  icon: Icon(e['icon'])),
                                              Expanded(
                                                child: Text(
                                                  e['label'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ]),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: mylista.map((e) {
                                      return Visibility(
                                        visible: e['visible'],
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 30,
                                                    color: Color(int.parse(DB
                                                            .officetable[
                                                        DB.officetable.indexWhere(
                                                            (element) =>
                                                                element[
                                                                    'office_id'] ==
                                                                e['task_office_id'])]['color'])),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        // dialogeditinfo(
                                                        //     ctx: context, e: e);
                                                      },
                                                      icon: const Icon(
                                                          Icons.info_outline)),
                                                  Expanded(
                                                    child: Text(
                                                      "# ${e['task_id']} _ ${e['taskname']} _>",
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e['status'] == 1
                                                              ? "منجزة"
                                                              : "غير منجزة",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                        ...e['userstask_name']
                                                            .map((e) =>
                                                                Text("$e"))
                                                            .toList()
                                                      ])),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  Switch(
                                                      value: e['notifi'] == 1
                                                          ? true
                                                          : false,
                                                      onChanged: DB.userstable[DB.userstable.indexWhere((element) => element['user_id'] == DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id'])][
                                                                      'admin'] ==
                                                                  1 ||
                                                              DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)][
                                                                      'user_id'] ==
                                                                  e[
                                                                      'createby_id'] ||
                                                              mainController.checkifuserSupervisor(
                                                                      officeid: e['task_office_id'],
                                                                      userid: DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']) ==
                                                                  true
                                                          ? (x) {
                                                              mainController
                                                                  .changenotifitask(
                                                                      notifi: x,
                                                                      id: e[
                                                                          'task_id']);
                                                            }
                                                          : null),
                                                  Text(e['notifi'] == 1
                                                      ? "اشعار مفعل"
                                                      : "إشعار غير مفعل")
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      });
                }
              }),

              Visibility(
                  visible: DB.userstable[DB.userstable.indexWhere(
                                  (e1) => e1['username'] == Home.logininfo)]
                              ['privilege']
                          .contains("مشرف")
                      ? true
                      : false,
                  child: Positioned(
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // dialogeadd(ctx: context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50)))),
                          child: const Icon(Icons.add),
                        ),
                      ))),
              //moretools
              Positioned(bottom: 0, left: 0, child: MoreTools()),
              //notification
              Positioned(left: 0, child: Notificationm()),
              //personal panel(logout and chang password)
              Positioned(left: 0, child: PersonPanel()),
            ],
          ),
        ),
      ),
    );
  }

  getinfo({e, ctx}) {
    buildcomment(mylista: mylista);
    return Visibility(
        visible: !editvisible,
        child: Column(
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
            const Divider(),
            Comment(
              page: Tasks,
              mylista: mylista,
            ),
            WriteComment(
              e: e,
              writeComment: () async {
                await mainController.addcomment(
                    e: e,
                    addcommentaction: e['commentcontroller'].text.isNotEmpty
                        ? dbController.addcommenttask(
                            userid: DB.userstable[DB.userstable.indexWhere(
                                    (element) =>
                                        element['username'] == Home.logininfo)]
                                ['user_id'],
                            taskid: e['task_id'],
                            comment: e['commentcontroller'].text)
                        : null);
              },
            )
          ],
        ));
  }

  // dialogeditinfo({ctx, e}) {
  //   editvisible = false;
  //   editsavevisible = true;
  //   initialdataforEdit(e);
  //   showADDEDITINFO(
  //       context: ctx,
  //       begin: dialogeBegin,
  //       end: dialogeEnd,
  //       content: GetBuilder<MainController>(
  //         init: mainController,
  //         builder: (_) {
  //           return ADDEDITINFOItem(
  //             addlabel: '',
  //             scrollController: ScrollController(),
  //             visibility: editvisible,
  //             listofFeildmz: tasks,
  //             customWidget: Column(children: [
  //               ...customWidgetofEdit(
  //                 ctx: ctx,
  //               )
  //             ]),
  //             easyeditvisible:
  //                 DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
  //                                 ['admin'] ==
  //                             1 ||
  //                         DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
  //                                 ['user_id'] ==
  //                             e['createby_id'] ||
  //                         mainController.checkifuserSupervisor(
  //                                 officeid: e['task_office_id'],
  //                                 userid: DB.userstable[DB.userstable.indexWhere(
  //                                         (element) => element['username'] == Home.logininfo)]
  //                                     ['user_id']) ==
  //                             true
  //                     ? true
  //                     : false,
  //             easyeditpanel: Row(
  //               children: [
  //                 Visibility(
  //                   visible: !addwaitvis,
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                           children: easyeditask(
  //                         e: e,
  //                         ctx: ctx,
  //                       )
  //                               .map((e) => Visibility(
  //                                     visible: e['visible'],
  //                                     child: Visibility(
  //                                       visible: e['invisible'],
  //                                       child: IconButton(
  //                                           onPressed: e['action'],
  //                                           icon: Icon(
  //                                             e['icon'],
  //                                             color: e['color'],
  //                                           )),
  //                                     ),
  //                                   ))
  //                               .toList()),
  //                       Visibility(
  //                         visible: Tasks.errormsg == null ? false : true,
  //                         child: Text(
  //                           Tasks.errormsg ?? '',
  //                           textAlign: TextAlign.center,
  //                           style: const TextStyle(color: Colors.redAccent),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Visibility(
  //                     visible: addwaitvis,
  //                     child: const LinearProgressIndicator())
  //               ],
  //             ),
  //             getinfo: getinfo(e: e, ctx: ctx),
  //           );
  //         },
  //       ),
  //       listofFeildmz: tasks);
  // }

  initialdataforEdit(e) {
    Tasks.extratimecontrollererror = null;
    taskid = e['task_id'];
    Tasks.errormsg = null;
    taskofficelist.clear();
    for (var i = 0;
        i <
            DB
                .userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['privilege']
                .length;
        i++) {
      if (DB.userstable[DB.userstable.indexWhere(
                  (element) => element['username'] == Home.logininfo)]
              ['privilege'][i] ==
          'مشرف') {
        taskofficelist.add(DB.officetable[DB.officetable.indexWhere((element) =>
            element['office_id'] ==
            DB.userstable[DB.userstable.indexWhere(
                    (element) => element['username'] == Home.logininfo)]
                ['office'][i])]['officename']);
      }
    }
    taskofficeNameselected = DB.officetable[DB.officetable.indexWhere(
            (element) => element['office_id'] == e['task_office_id'])]
        ['officename'];
    for (var i in Tasks.tasks) {
      i['error'] = null;
    }
    duration = e['duration'].toDouble();
    extratimecontroller.text = e['extratime'].toString();
    Tasks.taskname.text = e['taskname'];
    Tasks.taskdetails.text = e['taskdetails'];
    duration = e['duration'].toDouble();
    extratimecontroller.text = e['extratime'].toString();
    taskstatus = e['status'] == 1 ? true : false;
    usersfortasks.clear();
    usersfortaskswidget.clear();
    mainController.getusersinofficeifsupervisor();
    for (var i in e['userstask_name']) {
      usersfortasks.add(i);
      usersfortaskswidget.add({'i': 0, 'name': i});
    }
    mainController.cloasedp();
  }

  // dialogeadd({ctx}) {
  //   dialogeEnd = dialogeEnd;
  //   initialdataforAdd();
  //   showADDEDITINFO(
  //       context: ctx,
  //       begin: dialogeBegin,
  //       end: dialogeEnd,
  //       content: GetBuilder<MainController>(
  //         init: mainController,
  //         builder: (_) => ADDEDITINFOItem(
  //           addlabel: '',
  //           scrollController: ScrollController(),
  //           visibility: true,
  //           listofFeildmz: tasks,
  //           customWidget: Column(children: [...customWidgetofADD()]),
  //           // actionadd: actionadd(
  //           //     action: () => mainController.addItemMainController(
  //           //           scrollcontroller: ScrollController(),
  //           //           page: Tasks,
  //           //           listofFeildmz: tasks,
  //           //           itemnameController: taskname.text,
  //           //         )),
  //           easyeditvisible: false,
  //         ),
  //       ),
  //       listofFeildmz: tasks);
  // }

  initialdataforAdd() {
    taskofficelist.clear();
    for (var i in tasks) {
      i['controller'].text = '';
      i['error'] = null;
    }
    for (var i = 0;
        i <
            DB
                .userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['privilege']
                .length;
        i++) {
      if (DB.userstable[DB.userstable.indexWhere(
                  (element) => element['username'] == Home.logininfo)]
              ['privilege'][i] ==
          'مشرف') {
        taskofficelist.add(DB.officetable[DB.officetable.indexWhere((element) =>
            element['office_id'] ==
            DB.userstable[DB.userstable.indexWhere(
                    (element) => element['username'] == Home.logininfo)]
                ['office'][i])]['officename']);
      }
    }
    taskofficeNameselected = taskofficelist[0];

    errormsg = null;
    usersfortasks.clear();
    usersfortaskswidget.clear();
    duration = 7;
    extratimecontroller.text = 0.toString();
    mainController.cloasedp();
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
}
