import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

MainController mainController = Get.find();

// ignore: must_be_immutable
class Whattodo extends StatelessWidget {
  Whattodo({super.key});
  ThemeController themeController = Get.find();
  DBController dbController = Get.find();
  static DateTime sortbydatebegin = DateTime.parse('2022-10-01');
  static DateTime sortbydateend = DateTime.now();
  static TextEditingController todoname = TextEditingController();
  static TextEditingController tododetails = TextEditingController();
  static bool editvisible = false;
  static bool editsavevisible = true;
  static bool addwaitvis = false;
  static bool notifi = false;
  static bool selectall = false;
  static bool deletewait = false;
  static String? errormsg;
  static String officelistvalue = 'مخصص';
  List temp = [];
  static late int todoid;
  static double dialogeBegin = 1000;
  static double dialogeEnd = 0;
  static double wid = 50, hi = 50;
  static List<Map> mylista = [];
  static String timedayvalue = 'غير محدد';
  static String timemonthvalue = 'غير محدد';
  static String timeyearvalue = 'غير محدد';
  static String? errorcomment;
  static bool editcommentwait = false;
  static TextEditingController commentcontrolleredit = TextEditingController();

  static List<Map> todos = [
    {
      'label': 'اسم الإجرائية',
      'controller': todoname,
      'error': null,
      'icon': Icons.work,
      'obscuretext': false,
      'hint': '',
    },
    {
      'label': 'التفاصيل',
      'controller': tododetails,
      'error': null,
      'icon': Icons.api,
      'obscuretext': false,
      'hint': '',
      'maxlines': 4
    },
  ];
  static List todoofficelist = [];
  static String? todooffice;

  static List customWidgetofADD({ctx, action, createbyId}) => [
        Row(
          children: [
            const Text("اختيار مكتب"),
            DropdownButton(
                value: todooffice,
                items: todoofficelist
                    .map((e) => DropdownMenuItem(value: "$e", child: Text(e)))
                    .toList(),
                onChanged: (x) {
                  mainController.chooseofficetodo(x);
                }),
          ],
        )
      ];
  static List easyedittodo({e, ctx}) => [
        {
          'invisible': true,
          'visible': DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                          ['user_id'] ==
                      e['createby_id'] ||
                  DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                          ['admin'] ==
                      1 ||
                  mainController.checkifuserSupervisor(
                          officeid: e['todo_office_id'],
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) => element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
              ? true
              : false,
          'icon': Icons.delete,
          'action': () async {
            todoid = e['todo_id'];
            await mainController.deleteItemMainController(
              ctx: ctx,
              page: Whattodo,
            );
          },
          'color': Colors.redAccent,
        },
        {
          'invisible': editsavevisible,
          'visible': DB.userstable[DB.userstable.indexWhere(
                              (element) => element['username'] == Home.logininfo)]
                          ['user_id'] ==
                      e['createby_id'] ||
                  mainController.checkifuserSupervisor(
                          officeid: e['todo_office_id'],
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
              ? true
              : false,
          'icon': Icons.edit,
          'action': () async {
            todoid = e['todo_id'];
            await mainController.showeditpanel();
          },
          'color': Colors.indigoAccent,
        },
        {
          'invisible': !editsavevisible,
          'visible': DB.userstable[DB.userstable.indexWhere(
                              (element) => element['username'] == Home.logininfo)]
                          ['user_id'] ==
                      e['createby_id'] ||
                  mainController.checkifuserSupervisor(
                          officeid: e['todo_office_id'],
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
              ? true
              : false,
          'icon': Icons.save,
          'action': () async {
            todoid = e['todo_id'];
            await mainController.editItemMainController(
              e: e,
              page: Whattodo,
              // pagelisttextfeild: todos,
            );
          },
          'color': Colors.indigoAccent
        }
      ];
  static List customWidgetofEdit({ctx}) => [
        //   Row(
        //     children: [
        //       const Text(" تقييم "),
        //       ...Whattodo.mylista[0]['rate_widget'].map((r) => IconButton(
        //           onPressed: () {
        //             mainController.rate(
        //               0,
        //               Whattodo.mylista[0]['rate_widget'].indexOf(r),
        //               DB.userstable[DB.userstable.indexWhere(
        //                       (element) => element['username'] == Home.logininfo)]
        //                   ['user_id'],
        //               todoid,
        //             );
        //           },
        //           icon: Icon(r['icon'])))
        //     ],
        //   ),
      ];
  List dbtodotableAction = [
    {
      'label': 'اسم الإجرائية',
      'action': () {
        mainController.sort(table: mylista, sortby: 'todoname');
      }
    }
  ];
  Widget actionadd({action}) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !addwaitvis,
              child: TextButton.icon(
                  onPressed: action,
                  icon: const Icon(Icons.add),
                  label: const Text("إضافة إجرائية جديدة")),
            ),
            Visibility(
                visible: addwaitvis, child: const CircularProgressIndicator())
          ],
        ),
        Visibility(
          visible: Whattodo.errormsg == null ? false : true,
          child: Text(
            Whattodo.errormsg ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ]);
  static List easyedittodocomment({ctx, commentid, commenttext, usercomment}) =>
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
          'action': () async {},
          'color': Colors.grey
        }
      ];

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
                    tableid: 'todo_id',
                    table: 'todo',
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
                  if (!(DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['privilege']
                          .contains("موظف") ||
                      DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['privilege']
                          .contains("مشرف"))) {
                    Future(() => mainController.snakbar(context,
                        'لست عضوا في اي مكتب لا يمكنك اضافة إجرايئات'));
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
                                Text("لا يوجد اي إجرائية مضافة الى الآن")
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
                                //search
                                Expanded(
                                  child: TextFieldMZ(
                                      label: "بحث",
                                      onChanged: (word) {
                                        mainController.search(
                                            word: word,
                                            list: mylista,
                                            range: [
                                              'todoname',
                                              'tododetails',
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
                                          style: const TextStyle(fontSize: 15),
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
                            Expanded(
                              child: Column(
                                children: [
                                  //main column name and sort
                                  Row(children: [
                                    ...dbtodotableAction
                                        .map((e) => Expanded(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: e['action'],
                                                      icon: const Icon(
                                                          Icons.sort)),
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
                                  //todo list
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: mylista.map((e) {
                                          return Visibility(
                                            visible: e['visible'],
                                            child: Card(
                                              child: Row(children: [
                                                Container(
                                                    width: 10,
                                                    height: 30,
                                                    color: Color(int.parse(DB
                                                                .officetable[
                                                            DB.officetable.indexWhere(
                                                                (element) =>
                                                                    element[
                                                                        'office_id'] ==
                                                                    e['todo_office_id'])]
                                                        ['color']))),
                                                IconButton(
                                                    onPressed: () {
                                                      dialogeditinfo(
                                                          ctx: context, e: e);
                                                    },
                                                    icon: const Icon(
                                                        Icons.info_outline)),
                                                Expanded(
                                                  child: Text(
                                                    "# ${e['todo_id']} _${e['todoname']}",
                                                  ),
                                                ),
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
                          ],
                        );
                      }
                    },
                  );
                }
              }),
              //any user in a office with can add todo
              // Visibility(
              //     visible: DB.userstable[DB.userstable.indexWhere((element) =>
              //                         element['username'] == Home.logininfo)]
              //                     ['privilege']
              //                 .contains("موظف") ||
              //             DB.userstable[DB.userstable.indexWhere((element) =>
              //                         element['username'] == Home.logininfo)]
              //                     ['privilege']
              //                 .contains("مشرف")
              //         ? true
              //         : false,
              //     child: Positioned(
              //         left: 0,
              //         bottom: 0,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: ElevatedButton(
              //             onPressed: () {
              //               dialogeadd(ctx: context);
              //             },
              //             style: ElevatedButton.styleFrom(
              //                 shape: const RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.only(
              //                         topRight: Radius.circular(50)))),
              //             child: const Icon(Icons.add),
              //           ),
              //         ))),
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
    // buildcomment(mylista: mylista);
    return Visibility(
      visible: !editvisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(''' 
        ${e['todo_office_id'] != null ? DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == e['todo_office_id'])]['officename'] : 'مكتب محذوف'}
        # ${e['todo_id']} ${e['todoname']}
        التفاصيل
        ${e['tododetails']}
        '''),
          const Divider(),
          Text(e['createby'] != null
              ? 'تم إنشاءها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['createdate'])} بواسطة ${e['createby']}'
              : ' تم إنشاءها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['createdate'])} بواسطة حساب محذوف'),
          Visibility(
            visible: e['editdate'] == null ? false : true,
            child: Text(e['editby_id'] != null
                ? 'تم تعديلها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['editdate'] ?? DateTime.now())} بواسطة ${e['editby']}'
                : 'تم تعديلها بتاريخ ${df.DateFormat("HH:mm ||yyyy-MM-dd").format(e['editdate'] ?? DateTime.now())} بواسطة حساب محذوف'),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // dialogeadd({ctx}) {
  //   dialogeEnd = dialogeEnd;
  //   initialdataforAdd();
  //   showdialogeADDEDITINFO(
  //       context: ctx,
  //       begin: dialogeBegin,
  //       end: dialogeEnd,
  //       content: GetBuilder<MainController>(
  //         init: mainController,
  //         builder: (_) => ADDEDITINFOItem(
  //           visibility: true,
  //           listofFeildmz: todos,
  //           customWidget: Column(children: [
  //             ...customWidgetofADD(
  //               ctx: ctx,
  //             )
  //           ]),
  //           actionadd: actionadd(
  //               action: () => mainController.addItemMainController(
  //                   page: Whattodo,
  //                   listofFeildmz: todos,
  //                   nameEmptycond: todoname.text,
  //                   errormsg: errormsg)),
  //           easyeditvisible: false,
  //         ),
  //       ),
  //       listofFeildmz: todos);
  // }

  dialogeditinfo({ctx, e}) {
    mainController.cloasedp();
    editvisible = false;
    editsavevisible = true;
    // initialdataforEdit(e);
    //   showdialogeADDEDITINFO(
    //       context: ctx,
    //       begin: dialogeBegin,
    //       end: dialogeEnd,
    //       content: GetBuilder<MainController>(
    //         init: mainController,
    //         builder: (_) => ADDEDITINFOItem(
    //           visibility: editvisible,
    //           listofFeildmz: todos,
    //           customWidget: Column(children: [
    //             ...customWidgetofEdit(
    //               ctx: ctx,
    //             )
    //           ]),
    //           easyeditvisible:
    //               DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
    //                               ['admin'] ==
    //                           1 ||
    //                       DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
    //                               ['user_id'] ==
    //                           e['createby_id'] ||
    //                       mainController.checkifuserSupervisor(
    //                               officeid: e['todo_office_id'],
    //                               userid: DB.userstable[DB.userstable.indexWhere(
    //                                       (element) => element['username'] == Home.logininfo)]
    //                                   ['user_id']) ==
    //                           true
    //                   ? true
    //                   : false,
    //           easyeditpanel: Row(
    //             children: [
    //               Visibility(
    //                 visible: !addwaitvis,
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                         children: easyedittodo(ctx: ctx, e: e)
    //                             .map((e) => Visibility(
    //                                 visible: e['visible'],
    //                                 child: Visibility(
    //                                   visible: e['invisible'],
    //                                   child: IconButton(
    //                                       onPressed: e['action'],
    //                                       icon: Icon(
    //                                         e['icon'],
    //                                         color: e['color'],
    //                                       )),
    //                                 )))
    //                             .toList()),
    //                     Visibility(
    //                       visible: Whattodo.errormsg == null ? false : true,
    //                       child: Text(
    //                         Whattodo.errormsg ?? '',
    //                         textAlign: TextAlign.center,
    //                         style: const TextStyle(color: Colors.redAccent),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               Visibility(
    //                   visible: addwaitvis,
    //                   child: const CircularProgressIndicator())
    //             ],
    //           ),
    //           getinfo: getinfo(e: e, ctx: ctx),
    //         ),
    //       ),
    //       listofFeildmz: todos);
    // }

    initialdataforAdd() {
      for (var i in todos) {
        i['controller'].text = '';
        i['error'] = null;
      }
      errormsg = null;
      mainController.cloasedp();
      todoofficelist.clear();
      for (var i in DB.userstable[DB.userstable
              .indexWhere((element) => element['username'] == Home.logininfo)]
          ['office']) {
        try {
          todoofficelist.add(DB.officetable[DB.officetable
                  .indexWhere((element) => element['office_id'] == i)]
              ['officename']);
        } catch (e) {}
      }
      todooffice = todoofficelist[0];
    }

    initialdataforEdit(e) {
      Whattodo.errormsg = null;
      todoid = e['todo_id'];
      todoofficelist.clear();
      for (var i in DB.userstable[DB.userstable
              .indexWhere((element) => element['username'] == Home.logininfo)]
          ['office']) {
        try {
          todoofficelist.add(DB.officetable[DB.officetable
                  .indexWhere((element) => element['office_id'] == i)]
              ['officename']);
        } catch (e) {}
      }
      todooffice = e['todo_office_id'] != null
          ? DB.officetable[DB.officetable.indexWhere(
                  (element) => element['office_id'] == e['todo_office_id'])]
              ['officename']
          : 'مكتب محذوف';
      todoname.text = e['todoname'];
      tododetails.text = e['tododetails'];
      for (var i in Whattodo.todos) {
        i['error'] = null;
      }
    }
  }

// class TodoGet extends StatelessWidget {
//   TodoGet({
//     super.key,
//     this.ctx,
//     this.createbyvis,
//     this.index,
//     this.createby_id,
//     this.createby,
//     this.details,
//     this.todoid,
//     this.createdate,
//     this.editdate,
//     this.editby,
//     this.editvisible,
//     this.ratevis,
//   });
//   static Map resortcomment = {};
//   static List ty = [];
//   var ctx,
//       createbyvis,
//       index,
//       createby_id,
//       todoid,
//       createby,
//       details,
//       createdate,
//       editdate,
//       editby,
//       editvisible,
//       ratevis;
//   @override
//   Widget build(BuildContext context) {
//     MainController mainController = Get.find();
//     List maso = [],
//         maso2 = [],
//         usersId = [],
//         usersC = [],
//         comment = [],
//         commentid = [],
//         commentdate = [];
//     try {
//       for (var i in WhattoDo.mylista[index]['commentdate']) {
//         maso.add(
//             "$i=m=${WhattoDo.mylista[index]['users_id_comment'][WhattoDo.mylista[index]['commentdate'].indexOf(i)]}=m=${WhattoDo.mylista[index]['users_c'][WhattoDo.mylista[index]['commentdate'].indexOf(i)]}=m=${WhattoDo.mylista[index]['comment'][WhattoDo.mylista[index]['commentdate'].indexOf(i)]}=m=${WhattoDo.mylista[index]['comment_id'][WhattoDo.mylista[index]['commentdate'].indexOf(i)]}");
//       }
//     } catch (e) {}
//     maso.sort(
//       (a, b) => a.toString().compareTo(b.toString()),
//     );
//     for (var i in maso) {
//       maso2.add(i.split('=m='));
//     }
//     usersId.clear();
//     usersC.clear();
//     comment.clear();
//     commentid.clear();
//     commentdate.clear();
//     for (var i in maso2) {
//       usersId.add(i[1]);
//       usersC.add(i[2]);
//       comment.add(i[3]);
//       commentdate.add(i[0]);
//       commentid.add(i[4]);
//     }
//     resortcomment.addAll({
//       'users_id_comment': usersId,
//       'users_c': usersC,
//       'comment': comment,
//       'commentdate': commentdate,
//       'comment_id': commentid
//     });
//     double rateavg = 0;
//     if (WhattoDo.mylista[index]['rate'].isNotEmpty) {
//       for (var i in WhattoDo.mylista[index]['rate']) {
//         rateavg += i;
//       }
//     }

//     if (WhattoDo.mylista[index]['rate'].isNotEmpty) {
//       rateavg = rateavg / WhattoDo.mylista[index]['rate'].length;
//     } else {
//       rateavg = 0.0;
//     }
//     try {
//       for (var i in WhattoDo.mylista[index]['rate_widget']) {
//         if (WhattoDo.mylista[index]['rate'][WhattoDo.mylista[index]['users_r']
//                 .indexWhere((e) => e == Home.logininfo)] ==
//             WhattoDo.mylista[index]['rate_widget'].indexOf(i)) {
//           break;
//         }
//         i['icon'] = Icons.star;
//       }
//     } catch (e) {}
//     return GetBuilder<MainController>(
//         init: mainController,
//         builder: (_) => AlertDialog(
//               scrollable: true,
//               content: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(border: Border.all()),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Visibility(
//                               visible: createbyvis,
//                               child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children:
//                                       WhattoDo.easyeditodo(ctx: ctx).map((e) {
//                                     WhattoDo.todoid = todoid;

//                                     return IconButton(
//                                         onPressed: e['action'],
//                                         icon: Icon(
//                                           e['icon'],
//                                           color: e['color'],
//                                         ));
//                                   }).toList()),
//                             ),
//                             Visibility(
//                                 visible: !ratevis,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: 1,
//                                       height: 25,
//                                       color: Colors.black,
//                                     ),
//
//                             const Divider(),
//                             Row(
//                               children: [
//                                 Expanded(child: Text(details.toString())),
//                               ],
//                             ),
//                             const Divider(),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                       'تم إنشاءها بتاريخ ${df.DateFormat("yyyy-MM-dd | HH:mm").format(createdate)} بواسطة ${createby != null ? DB.userstable[DB.userstable.indexWhere((element) => element['username'] == createby)]['fullname'] : "حساب محذوف"}'),
//                                 ),
//                               ],
//                             ),
//                             Visibility(
//                               visible: editvisible,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   editby != null
//                                       ? Expanded(
//                                           child: Text(
//                                               'تم التعديل بتاريخ ${df.DateFormat("yyyy-MM-dd | HH:mm").format(editdate ?? DateTime.now())} بواسطة ${editby != null ? DB.userstable[DB.userstable.indexWhere((element) => element['username'] == editby)]['fullname'] : "حساب محذوف"}'),
//                                         )
//                                       : const SizedBox(),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "معدل التقييم : $rateavg",
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                     "عدد التقييمات: ${WhattoDo.mylista[index]['rate'].length}")
//                               ],
//                             ),
//                             const Divider(),
//                             Visibility(
//                               visible:
//                                   WhattoDo.mylista[index]['comment'].isEmpty
//                                       ? false
//                                       : true,
//                               child: ExpansionTile(
//                                   title: const Text("التعليقات"),
//                                   children: [
//                                     ...resortcomment['commentdate'].map((e) {
//                                       print(resortcomment);
//                                       return Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               border: Border.all()),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Visibility(
//                                                       visible: Home.logininfo ==
//                                                               resortcomment[
//                                                                       'users_c']
//                                                                   [
//                                                                   resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)]
//                                                           ? true
//                                                           : false,
//                                                       child: Row(
//                                                           children: WhattoDo.easyeditodocomment(
//                                                                   commentcontroller: resortcomment[
//                                                                       'comment'][resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)],
//                                                                   ctx: ctx,
//                                                                   commentid: resortcomment[
//                                                                       'comment_id'][resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)])
//                                                               .map((e) {
//                                                         WhattoDo.todoid =
//                                                             todoid;
//                                                         return IconButton(
//                                                             onPressed:
//                                                                 e['action'],
//                                                             icon: Icon(
//                                                               e['icon'],
//                                                               color: e['color'],
//                                                               size: 15,
//                                                             ));
//                                                       }).toList()),
//                                                     ),
//                                                     Text(
//                                                       resortcomment['users_c'][
//                                                                   resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)] !=
//                                                               "null"
//                                                           ? "${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == resortcomment['users_c'][resortcomment['commentdate'].indexOf(e)])]['fullname']}"
//                                                           : "حساب محذوف",
//                                                       softWrap: true,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                   "${resortcomment['comment'][resortcomment['commentdate'].indexOf(e)]}",
//                                                   softWrap: true,
//                                                 ),
//                                                 Text(
//                                                   " ${df.DateFormat("yyyy-MM-dd | HH:mm").format(DateTime.parse(e))}",
//                                                   softWrap: true,
//                                                 ),
//                                                 const Divider(),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     })
//                                   ]),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: textFieldMZ(
//                             maxlines: 2,
//                             error: WhattoDo.mylista[index]['error'],
//                             label: "اكتب تعليق",
//                             controller: WhattoDo.mylista[index]
//                                 ['commentcontroller'],
//                             suffixicon: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Visibility(
//                                     visible: !WhattoDo.mylista[index]
//                                         ['waitsend'],
//                                     child: const CircularProgressIndicator()),
//                                 Visibility(
//                                     visible: WhattoDo.mylista[index]
//                                         ['waitsend'],
//                                     child: IconButton(
//                                         onPressed: () {
//                                           mainController.addcomment(
//                                               index: index,
//                                               userid: DB.userstable[DB
//                                                       .userstable
//                                                       .indexWhere((element) =>
//                                                           element['username'] ==
//                                                           Home.logininfo)]
//                                                   ['user_id'],
//                                               todoid: todoid,
//                                               comment: WhattoDo
//                                                   .mylista[index]
//                                                       ['commentcontroller']
//                                                   .text);
//                                         },
//                                         icon: const Icon(Icons.send))),
//                               ],
//                             )),
//                       ),
//                       const SizedBox(
//                         width: 50,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ));
//   }
}
