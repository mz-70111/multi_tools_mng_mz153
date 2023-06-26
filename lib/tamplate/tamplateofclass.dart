import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:intl/intl.dart' as df;
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class TextFieldMZ extends StatelessWidget {
  const TextFieldMZ(
      {super.key,
      required this.label,
      this.textdirection = TextDirection.rtl,
      this.maxlines = 1,
      this.textEditingController,
      this.obscureText = false,
      required this.onChanged,
      this.suffixIcon,
      this.hint,
      this.error,
      this.readonly = false});
  final String? label, hint, error;
  final TextDirection textdirection;
  final int maxlines;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final Function onChanged;
  final Widget? suffixIcon;
  final bool readonly;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: textdirection,
        child: TextField(
          maxLines: maxlines,
          controller: textEditingController,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          onChanged: (x) => onChanged(x),
          readOnly: readonly,
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              label: Text(label!),
              hintText: hint,
              errorStyle: TextStyle(
                  color: ThemeMZ.mode == 'light'
                      ? Colors.red
                      : Colors.amberAccent),
              labelStyle: ThemeMZ().theme().textTheme.labelMedium,
              border: const OutlineInputBorder(),
              errorText: error,
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeMZ.mode == 'light'
                          ? Colors.red
                          : Colors.amberAccent)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeMZ.mode == 'light'
                          ? Colors.red
                          : Colors.amberAccent)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              floatingLabelAlignment: FloatingLabelAlignment.center),
        ),
      ),
    );
  }
}

class Privilege extends StatelessWidget {
  const Privilege(
      {super.key,
      required this.index,
      required this.office,
      required this.privilege,
      required this.selectOffice,
      required this.selectPermission});
  final int index;
  final String office, privilege;
  final Function selectOffice, selectPermission;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();

    return TweenMZ.translatex(
      duration: 200,
      begin: -100.0,
      end: 0.0,
      child0: GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                        value: office,
                        items: DB.officetable
                            .map((e) => DropdownMenuItem(
                                value: e['officename'],
                                child: Text(e['officename'])))
                            .toList(),
                        onChanged: (x) => selectOffice(x)),
                    DropdownButton(
                        value: privilege,
                        items: Employ.permission
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (x) => selectPermission(x)),
                    IconButton(
                        onPressed: () {
                          mainController.deleteprivilege(index);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class Usersoftasks extends StatelessWidget {
  const Usersoftasks(
      {super.key,
      required this.user,
      required this.selectuser,
      required this.index});
  final String user;
  final Function selectuser;
  final int index;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return TweenMZ.translatex(
      duration: 200,
      begin: -100.0,
      end: 0.0,
      child0: GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(
          children: [
            Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                        value: user,
                        items: Tasks.usersfortasks
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (x) => selectuser(x)),
                    IconButton(
                        onPressed: () {
                          mainController.deleteuserfortask(index);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

showADDEDITINFO({
  required context,
  required begin,
  required end,
  required content,
  required listofFeildmz,
  dialogend,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        dialogend = 0;
        return TweenMZ.translatey(
            begin: begin,
            end: end,
            duration: 300,
            child0: Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  content: content,
                )));
      });
}

class Comment extends StatelessWidget {
  const Comment(
      {super.key,
      required this.table,
      required this.tableid,
      required this.comment,
      required this.deletecomment,
      required this.editcomment,
      required this.e});
  final String table, tableid;
  final List<Map> comment;
  final Function deletecomment;
  final Function editcomment;
  final e;
  @override
  Widget build(BuildContext context) {
    DBController dbController = Get.find();
    return FutureBuilder(future: Future(() async {
      try {
        return await dbController.gettable(
          list: comment,
          tableid: tableid,
          table: table,
        );
      } catch (e) {
        null;
      }
    }), builder: (_, snap) {
      List editcommentpanel = [
        {'icon': Icons.delete, 'action': () => deletecomment()},
        {'icon': Icons.edit, 'action': () => editcomment()}
      ];
      return ExpansionTile(title: const Text("التعليقات"), children: [
        ...comment.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Visibility(
                        visible:
                            checkifUserisSame(userId: e['utc_user_id']) == true
                                ? true
                                : false,
                        child: Row(
                            children: editcommentpanel
                                .map((e) => IconButton(
                                    onPressed: e['action'],
                                    icon: Icon(
                                      e['icon'],
                                      size: 15,
                                      color: Colors.grey,
                                    )))
                                .toList()),
                      ),
                      Text(
                        e['utc_user_id'] != null
                            ? "${DB.userstable[DB.userstable.indexWhere((element) => element['user_id'] == e['utc_user_id'])]['fullname']}"
                            : "حساب محذوف",
                        softWrap: true,
                      ),
                    ],
                  ),
                  Text(
                    "${e['comments']}",
                    softWrap: true,
                  ),
                  Text(
                    " ${df.DateFormat("yyyy-MM-dd | HH:mm").format(e['commentdate'])}",
                    softWrap: true,
                  ),
                ],
              ),
            ),
          );
        })
      ]);
    });
  }
}

class WriteComment extends StatelessWidget {
  const WriteComment({super.key, required this.e, required this.writeComment});
  final e;
  final Function writeComment;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return GetBuilder<MainController>(
      init: mainController,
      builder: (_) => Column(
        children: [
          const Divider(),
          Row(
            children: [
              Expanded(
                child: TextFieldMZ(
                    onChanged: (x) => null,
                    maxlines: 2,
                    error: e['error'],
                    label: "اكتب تعليق",
                    textEditingController: e['commentcontroller'],
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: !e['waitsend'],
                            child: const CircularProgressIndicator()),
                        Visibility(
                            visible: e['waitsend'],
                            child: IconButton(
                                onPressed: () => writeComment(),
                                icon: const Icon(Icons.send))),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MYPAGE extends StatelessWidget {
  const MYPAGE(
      {super.key,
      required this.mylista,
      required this.table,
      required this.tableId,
      required this.page,
      required this.searchRange,
      required this.mainColumn,
      required this.notifi,
      required this.textfeildlista,
      required this.customWidgetofADD,
      required this.customInitdataforAdd,
      required this.customInitforEdit,
      required this.scrollController,
      required this.mainEditvisible,
      required this.mainAddvisible,
      required this.customWidgetofEdit,
      required this.action,
      required this.addlabel,
      required this.getinfo,
      required this.actionSave,
      required this.actionEdit,
      required this.actionDelete,
      required this.items,
      required this.itemsResult,
      required this.itemsWidget});
  final List<Map> mylista;
  final String table, tableId, addlabel;
  final Type page;
  final List<String> searchRange;
  final List mainColumn, items, itemsResult;
  final Widget notifi;
  final List textfeildlista;
  final Widget customWidgetofADD, customWidgetofEdit;
  final Function customInitdataforAdd,
      customInitforEdit,
      getinfo,
      action,
      actionSave,
      actionEdit,
      actionDelete,
      itemsWidget;
  final bool mainAddvisible, mainEditvisible;
  final ScrollController scrollController;
  //static
  static DateTime sortbydatebegin = DateTime.parse('2022-10-01');
  static DateTime sortbydateend = DateTime.now();
  static String selectedOffice = "جميع المكاتب";
  static double dialogeBegin = 1000;
  static double dialogeEnd = 0;
  static ScrollController mzcontroller = ScrollController();
  static var eE;
  static List officelist = [];
  @override
  Widget build(BuildContext context) {
    DBController dbController = Get.find();
    MainController mainController = Get.find();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: GetBuilder<DBController>(
              init: dbController,
              builder: (_) => Stack(
                    children: [
                      FutureBuilder(future: Future(() async {
                        try {
                          return await dbController.gettable(
                            list: mylista,
                            tableid: tableId,
                            table: table,
                          );
                        } catch (e) {
                          null;
                        }
                      }), builder: (_, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                              ]));
                        } else {
                          if (checkifUserisinAnyOffice() == false &&
                              page == Whattodo) {
                            Future(() => mainController.snakbar(context,
                                'لست عضوا في اي مكتب لا يمكنك اضافة إجرايئات'));
                          } else if (checkifUserisSupervisorinAnyOffice() ==
                                  false &&
                              page == Tasks) {
                            Future(() => mainController.snakbar(context,
                                'لست مشرفا في اي مكتب لا يمكنك اضافة مهام'));
                          }
                          return GetBuilder<MainController>(
                              init: mainController,
                              builder: (_) {
                                List officetrue = [];
                                officetrue.clear();
                                officelist.clear();
                                officelist = ['جميع المكاتب', 'مخصص'];
                                for (var i in DB.officetable) {
                                  officelist.add(i['officename']);
                                }
                                for (var i in Home.searchlist) {
                                  if (i.keys.toList().first == 'office_id' &&
                                      i['check'] == true) {
                                    officetrue.add(i['officename']);
                                  }
                                }

                                if (officetrue.length > 1 &&
                                    officetrue.length !=
                                        officelist.length - 2) {
                                  selectedOffice = 'مخصص';
                                }
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                          height:
                                              AppBar().preferredSize.height),
                                      Row(
                                        children: [
                                          Visibility(
                                              visible: DB.officetable.isNotEmpty
                                                  ? true
                                                  : false,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  child: DropdownButton(
                                                      value: selectedOffice,
                                                      items: officelist
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                  value: e,
                                                                  child: Text(
                                                                      "$e")))
                                                          .toList(),
                                                      onChanged: (x) {
                                                        mainController
                                                            .chooseoffice(x);
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
                                                      range: searchRange
                                                          .map((e) => e)
                                                          .toList());
                                                }),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                          visible:
                                              page == Tasks || page == Whattodo,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all()),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                            "بحث بحسب التاريخ"),
                                                        TextButton.icon(
                                                          onPressed: () {
                                                            mainController
                                                                .choosedate(
                                                                    ctx:
                                                                        context,
                                                                    beginorend:
                                                                        'begin');
                                                          },
                                                          icon: const Icon(
                                                              Icons.date_range),
                                                          label: Text(
                                                            "من ${df.DateFormat('yyyy-MM-dd').format(sortbydatebegin)}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ),
                                                        TextButton.icon(
                                                            onPressed: () {
                                                              mainController
                                                                  .choosedate(
                                                                      ctx:
                                                                          context,
                                                                      beginorend:
                                                                          'end');
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .date_range),
                                                            label: Text(
                                                              "إلى ${df.DateFormat('yyyy-MM-dd').format(sortbydateend)}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ))
                                                      ])))),
                                      Row(children: [
                                        ...mainColumn
                                            .map((e) => Expanded(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed:
                                                              e['action'],
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
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...mylista.map((e) {
                                                  itemsResult.clear();
                                                  for (var i in items) {
                                                    itemsResult.add(e[i]);
                                                  }
                                                  return Visibility(
                                                    visible: e['visible'],
                                                    child: Row(children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            eE = e;
                                                            infoEditItemWidget(
                                                              page: page,
                                                              mainEditvisible:
                                                                  mainEditvisible,
                                                              e: e,
                                                              ctx: context,
                                                              scrollController:
                                                                  scrollController,
                                                              customInitforEdit:
                                                                  () =>
                                                                      customInitforEdit(),
                                                              textfeildlista:
                                                                  textfeildlista,
                                                              customWidgetofEdit:
                                                                  customWidgetofEdit,
                                                              getinfo: () =>
                                                                  getinfo(),
                                                              actionSave: () =>
                                                                  actionSave(),
                                                              actionEdit: () =>
                                                                  actionEdit(),
                                                              actionDelete: () =>
                                                                  actionDelete(),
                                                            );
                                                          },
                                                          icon: const Icon(Icons
                                                              .info_outline)),
                                                      Expanded(
                                                          child: itemsWidget()),
                                                    ]),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                              });
                        }
                      }),
                      Visibility(
                          visible: mainAddvisible,
                          child: Positioned(
                              left: 0,
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    addItemWidget(
                                        ctx: context,
                                        textfeildlista: textfeildlista,
                                        addlabel: addlabel,
                                        action: () => action(),
                                        customWidgetofADD: customWidgetofADD,
                                        customInitdataforAdd: () =>
                                            customInitdataforAdd(),
                                        scrollController: scrollController);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50)))),
                                  child: const Icon(Icons.add),
                                ),
                              ))),
                      Positioned(top: 0, right: 0, child: UserName()),

                      //moretools
                      Positioned(bottom: 0, left: 0, child: MoreTools()),
                      //notification
                      Positioned(left: 0, child: Notificationm()),
                      //personal panel(logout and chang password)
                      Positioned(left: 0, child: PersonPanel()),
                    ],
                  )),
        ));
  }
}

checkifUserisinAnyOffice() {
  bool result = false;
  if (DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['privilege']
          .contains("موظف") ||
      DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['privilege']
          .contains("مشرف")) {
    result = true;
  }
  return result;
}

checkifUserisUserinOffice({officeid}) {
  bool result = false;
  for (var j in DB.userstable) {
    for (var l = 0; l < j['office'].length; l++) {
      if (j['office'][l] == officeid && j['privilege'][l] == 'موظف') {
        result = true;
      }
    }
  }
  return result;
}

checkifUserisSame({userId}) {
  bool result = false;
  if (DB.userstable[DB.userstable
              .indexWhere((element) => element['username'] == Home.logininfo)]
          ['user_id'] ==
      userId) {
    result = true;
  }
  return result;
}

checkifUserisSupervisorinAnyOffice() {
  bool result = false;
  if (DB.userstable[DB.userstable
              .indexWhere((element) => element['username'] == Home.logininfo)]
          ['privilege']
      .contains("مشرف")) {
    result = true;
  } else {
    result = false;
  }
  return result;
}

checkifUserisSupervisorinOffice({officeid}) {
  bool result = false;
  for (var j in DB.userstable) {
    for (var l = 0; l < j['office'].length; l++) {
      if (j['office'][l] == officeid && j['privilege'][l] == 'مشرف') {
        result = true;
      }
    }
  }
  return result;
}

checkifUserisAdmin() {
  bool result = false;
  if (DB.userstable[DB.userstable
              .indexWhere((element) => element['username'] == Home.logininfo)]
          ['admin'] ==
      1) {
    result = true;
  } else {
    result = false;
  }
  return result;
}

getcolorofoffice({page, e}) {
  List colors = [];
  colors.clear();
  if (page == Employ) {
    try {
      for (var i in e['office']) {
        colors.add(DB.officetable[DB.officetable
            .indexWhere((element) => element['office_id'] == i)]['color']);
      }
    } catch (e) {
      null;
    }
  } else if (page == Office) {
    colors.add(e['color']);
  } else if (page == Tasks) {
    colors.add(DB.officetable[DB.officetable.indexWhere(
        (element) => element['office_id'] == e['task_office_id'])]['color']);
  }
  return colors;
}

class ADDEDITINFOItem extends StatelessWidget {
  const ADDEDITINFOItem({
    super.key,
    required this.textFeildmzlista,
    required this.customWidget,
    this.editpanel = const SizedBox(),
    this.addpanel = const SizedBox(),
    required this.getinfo,
    required this.editpanelvisible,
    required this.scrollController,
  });
  final List<Map> textFeildmzlista;
  final Widget customWidget, editpanel, addpanel;
  final Function getinfo;
  final ScrollController scrollController;
  final bool editpanelvisible;
  static bool addeditvisible = true;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Visibility(
                  visible: editpanelvisible,
                  child: Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: editpanel,
                  ))),
              Visibility(
                  visible: !editpanelvisible,
                  child: Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: addpanel,
                  ))),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ...textFeildmzlista
                    .map((e) => Visibility(
                          visible: addeditvisible,
                          child: GetBuilder<MainController>(
                            init: mainController,
                            builder: (_) => TextFieldMZ(
                              onChanged: (x) => null,
                              label: e['label'],
                              textEditingController: e['controller'],
                              error: e['error'],
                              obscureText: e['obscuretext'],
                              hint: e['hint'],
                              textdirection: e['td'] ?? TextDirection.rtl,
                              maxlines: e['maxlines'] ?? 1,
                              suffixIcon: IconButton(
                                  onPressed: e['action'],
                                  icon: Icon(e['icon'])),
                            ),
                          ),
                        ))
                    .toList(),
                Visibility(visible: addeditvisible, child: customWidget),
                Visibility(visible: !addeditvisible, child: getinfo()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

//addpanel
class AddPanel extends StatelessWidget {
  const AddPanel({super.key, required this.action, required this.addlabel});
  final Function action;
  final String addlabel;
  static String? errormsg;
  static bool wait = false;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return GetBuilder<MainController>(
      init: mainController,
      builder: (_) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !wait,
              child: TextButton.icon(
                  onPressed: () => action(),
                  icon: const Icon(Icons.add),
                  label: Text(addlabel)),
            ),
            Visibility(
                visible: wait,
                child: const Expanded(
                  child: LinearProgressIndicator(
                    color: Colors.grey,
                  ),
                ))
          ],
        ),
        Visibility(
          visible: errormsg == null ? false : true,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              errormsg ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
      ]),
    );
  }
}

initialdataforAdd({textfeildlista, customInitdataforAdd}) {
  for (var i in textfeildlista) {
    i['controller'].text = '';
    i['error'] = null;
  }
  AddPanel.errormsg = null;
  ADDEDITINFOItem.addeditvisible = true;
  customInitdataforAdd();
  MainController().cloasedp();
}

addItemWidget(
    {ctx,
    textfeildlista,
    addlabel,
    action,
    required Widget customWidgetofADD,
    customInitdataforAdd,
    scrollController}) {
  MainController mainController = Get.find();
  initialdataforAdd(
      textfeildlista: textfeildlista,
      customInitdataforAdd: customInitdataforAdd);
  showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          content: GetBuilder<MainController>(
            init: mainController,
            builder: (_) => ADDEDITINFOItem(
              getinfo: () => const SizedBox(),
              addpanel: AddPanel(
                addlabel: addlabel,
                action: action,
              ),
              editpanelvisible: false,
              textFeildmzlista: textfeildlista,
              customWidget: customWidgetofADD,
              scrollController: scrollController,
            ),
          ),
        );
      });
}

//editpanel
class Editpanel extends StatelessWidget {
  const Editpanel(
      {super.key,
      required this.actionDelete,
      required this.actionEdit,
      required this.actionSave,
      required this.e,
      required this.mainEditvisible,
      required this.page});
  final Function actionDelete, actionEdit, actionSave;
  final e;
  static String? errormsg;
  static bool wait = false, savevisible = false;
  final page;
  final bool mainEditvisible;
  @override
  Widget build(BuildContext context) {
    List edititems() => [
          {
            'visible0': page == Employ
                ? e['username'] == Home.logininfo
                    ? false
                    : true
                : true,
            'visible': !savevisible,
            'icon': Icons.delete,
            'action': () => actionDelete(),
            'color': Colors.redAccent
          },
          {
            'visible0': true,
            'visible': !savevisible,
            'icon': Icons.edit,
            'action': () => actionEdit(),
            'color': Colors.indigoAccent
          },
          {
            'visible0': true,
            'visible': savevisible,
            'icon': Icons.save,
            'action': () => actionSave(),
            'color': Colors.indigoAccent
          }
        ];
    return Visibility(
      visible: mainEditvisible,
      child: Row(
        children: [
          Visibility(
            visible: !wait,
            child: Column(
              children: [
                Row(
                    children: edititems()
                        .map((e) => Visibility(
                              visible: e['visible0'],
                              child: Visibility(
                                visible: e['visible'],
                                child: IconButton(
                                    onPressed: e['action'],
                                    icon: Icon(
                                      e['icon'],
                                      color: e['color'],
                                    )),
                              ),
                            ))
                        .toList()),
                Visibility(
                  visible: errormsg == null ? false : true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      errormsg ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: wait,
              child: const Expanded(
                child: LinearProgressIndicator(
                  color: Colors.grey,
                ),
              ))
        ],
      ),
    );
  }
}

initialdataforEdit({customInitdataforEdit, textfeildlista}) {
  for (var i in textfeildlista) {
    i['controller'].text = '';
    i['error'] = null;
  }
  Editpanel.errormsg = null;
  Editpanel.savevisible = false;
  ADDEDITINFOItem.addeditvisible = false;
  customInitdataforEdit();
  MainController().cloasedp();
}

infoEditItemWidget(
    {e,
    ctx,
    scrollController,
    customInitforEdit,
    textfeildlista,
    customWidgetofEdit,
    getinfo,
    actionDelete,
    actionSave,
    actionEdit,
    mainEditvisible,
    savevisible0,
    editvisible0,
    deletevisible0,
    page}) {
  MainController mainController = Get.find();
  initialdataforEdit(
      customInitdataforEdit: customInitforEdit, textfeildlista: textfeildlista);
  showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          content: GetBuilder<MainController>(
            init: mainController,
            builder: (_) => ADDEDITINFOItem(
              editpanel: Editpanel(
                  mainEditvisible: mainEditvisible,
                  actionDelete: actionDelete,
                  actionEdit: actionEdit,
                  actionSave: actionSave,
                  e: e,
                  page: page),
              editpanelvisible: true,
              scrollController: scrollController,
              textFeildmzlista: textfeildlista,
              customWidget: customWidgetofEdit,
              getinfo: getinfo,
            ),
          ),
        );
      });
}

class UserName extends StatelessWidget {
  const UserName({super.key});
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.indigoAccent),
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.elliptical(10, 20))),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GetBuilder<MainController>(
                init: mainController,
                builder: (_) => Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showinfo(ctx: context);
                            },
                            icon: const Icon(Icons.info)),
                        Text(
                          DB.userstable[DB.userstable.indexWhere((element) =>
                                  element['username'] == Home.logininfo)]
                              ['fullname'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 300,
          height: 10,
          color: Colors.indigoAccent,
        ),
      ],
    );
  }

  static var userindex = DB.userstable
      .indexWhere((element) => element['username'] == Home.logininfo);
  getprivileges() {
    List priv = DB.userstable[userindex]['privilege'];
    List off = DB.userstable[userindex]['office'];
    String p = '';
    for (var i = 0; i < priv.length; i++) {
      p +=
          "\n    * ${priv[i]} ${off[i] == '=' ? '' : off[i] == '_' ? '' : DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == off[i])]['officename']}";
    }
    return p;
  }

  static List infoList = [
    [
      'اسم المستخدم',
      TextEditingController(text: DB.userstable[userindex]['username']),
      true
    ],
    [
      'الاسم الكامل',
      TextEditingController(text: DB.userstable[userindex]['fullname']),
      false
    ],
    [
      'الايميل',
      TextEditingController(text: DB.userstable[userindex]['email']),
      false
    ],
    [
      'الموبايل',
      TextEditingController(text: DB.userstable[userindex]['mobile']),
      false
    ],
  ];
  showinfo({ctx}) {
    UserName.infoList.clear();

    infoList = [
      [
        'اسم المستخدم',
        TextEditingController(text: DB.userstable[userindex]['username']),
        true
      ],
      [
        'الاسم الكامل',
        TextEditingController(text: DB.userstable[userindex]['fullname']),
        false
      ],
      [
        'الايميل',
        TextEditingController(text: DB.userstable[userindex]['email']),
        false
      ],
      [
        'الموبايل',
        TextEditingController(text: DB.userstable[userindex]['mobile']),
        false
      ],
    ];
    MainController mainController = Get.find();
    DBController dbController = Get.find();
    String? errormsg;
    bool wait = false;
    showDialog(
        context: ctx,
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,
              content: GetBuilder<MainController>(
                init: mainController,
                builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: !wait,
                            child: IconButton(
                                onPressed: () async {
                                  wait = true;
                                  errormsg = '';
                                  mainController.update();
                                  try {
                                    await dbController.updatepersonalinfo(
                                        fullname: infoList[1][1].text ?? '_',
                                        email: infoList[2][1].text,
                                        mobile: infoList[3][1].text,
                                        id: DB.userstable[userindex]
                                            ['user_id']);
                                    DB.userstable[userindex]['fullname'] =
                                        infoList[1][1].text;
                                    DB.userstable[userindex]['email'] =
                                        infoList[2][1].text;
                                    DB.userstable[userindex]['mobile'] =
                                        infoList[3][1].text;
                                    Get.back();
                                  } catch (e) {
                                    errormsg = 'لا يمكن الوصول للمخدم';
                                    mainController.update();
                                  }
                                  wait = false;
                                  mainController.update();
                                },
                                icon: const Icon(Icons.save)),
                          ),
                          Visibility(
                              visible: wait,
                              child: SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(),
                              )),
                          Visibility(
                              visible: errormsg == null ? false : true,
                              child: Text("$errormsg")),
                        ],
                      ),
                      ...infoList.map((e) => TextFieldMZ(
                            label: "${e[0]}",
                            textEditingController: e[1],
                            onChanged: (x) => null,
                            readonly: e[2],
                          ))
                    ]),
              ),
            ),
          );
        });
  }
}

//editcommentpanel
class EditPanelComment extends StatelessWidget {
  const EditPanelComment(
      {super.key,
      required this.actiondeleteComment,
      required this.actioneditComment,
      required this.commentOwner});
  final Function actiondeleteComment;
  final Function actioneditComment;
  final String commentOwner;
  @override
  Widget build(BuildContext context) {
    List editcommentitems() => [
          {
            'visible': true,
            'icon': Icons.delete,
            'action': () => actiondeleteComment(),
            'color': Colors.grey
          },
          {
            'visible': DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['fullname'] ==
                    commentOwner
                ? true
                : false,
            'icon': Icons.edit,
            'action': () => actioneditComment(),
            'color': Colors.grey
          }
        ];
    return Row(
      children: editcommentitems()
          .map((c) => Visibility(
              visible: c['visible'],
              child: IconButton(
                  onPressed: c['action'],
                  icon: Icon(
                    c['icon'],
                    color: c['color'],
                  ))))
          .toList(),
    );
  }
}

//login
codepassword({required String word}) {
  String code = 'muoaz153';
  String aftercoded = '';
  for (var i = 0; i < word.length; i++) {
    inloop:
    for (var j = 0; j < code.length; j++) {
      if (j == code.length - 1) break inloop;
      aftercoded +=
          String.fromCharCode(word.codeUnitAt(i) + code.codeUnitAt(j));
      if (i == word.length - 1) {
        break inloop;
      } else {
        i++;
      }
    }
  }
  return aftercoded;
}

setlogin({required String username, required String password}) async {
  await LogIn.Pref.setStringList('login', [username, password]);
}

getlogin() {
  return LogIn.Pref.getStringList('login');
}

getofficeUsers({required List list, officeid}) async {
  var t = await DB().customquery(
      query:
          'select uf_user_id from users_office where uf_office_id=$officeid');
  list.clear();
  for (var j in t) {
    list.add(DB.userstable[DB.userstable
        .indexWhere((element) => element['user_id'] == j[0])]['fullname']);
  }
  return list;
}
