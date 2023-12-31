import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:intl/intl.dart' as df;
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/employaccount.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/pages/07_whatodo.dart';
import 'package:users_tasks_mz_153/pages/log.dart';
import 'package:users_tasks_mz_153/pages/officemanagment.dart';
import 'package:users_tasks_mz_153/pages/remind.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 500
              ? 500
              : MediaQuery.of(context).size.width,
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

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.table,
    required this.comment,
    required this.deletecomment,
    required this.editcomment,
    required this.tableId,
    required this.tableIdname,
    required this.userId,
    required this.officeId,
  });
  final String table, tableIdname, userId;
  final int tableId, officeId;
  final List<Map> comment;
  final Function deletecomment;
  final Function editcomment;
  static var Ee;
  static bool wait = false;
  static String? errmsg;
  static TextEditingController commentcontrolleredit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      try {
        return await getcommenttable(
          list: comment,
          table: table,
          tableIdname: tableIdname,
          tableId: tableId,
        );
      } catch (e) {
        null;
      }
    }), builder: (_, snap) {
      List editcommentpanel(ee) => [
            {
              'icon': Icons.delete,
              'action': () {
                Ee = ee;
                return deletecomment();
              }
            },
            {
              'icon': Icons.edit,
              'action': () {
                Ee = ee;
                return editcomment();
              }
            }
          ];
      if (snap.hasData) {
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
                          visible: checkifUserisSame(
                                          userid: e[userId],
                                          usertable: LogIn.allusers) ==
                                      true ||
                                  checkifUserisSupervisorinOffice(
                                          usertable: LogIn.allusers,
                                          userid: LogIn.allusers[LogIn.allusers
                                                  .indexWhere(
                                                      (element) => element['username'] == Home.logininfo)]
                                              ['user_id'],
                                          officeid: officeId) ==
                                      true ||
                                  checkifUserisAdmin(
                                          usertable: LogIn.allusers,
                                          userid:
                                              LogIn.allusers[LogIn.allusers.indexWhere((element) => element['username'] == Home.logininfo)]
                                                  ['user_id']) ==
                                      true
                              ? true
                              : false,
                          child: Row(
                              children: editcommentpanel(e).map((ed) {
                            return Visibility(
                              visible: ed['icon'] == Icons.delete
                                  ? true
                                  : checkifUserisSame(
                                              userid: e[userId],
                                              usertable: LogIn.allusers) ==
                                          true
                                      ? true
                                      : false,
                              child: IconButton(
                                  onPressed: ed['action'],
                                  icon: Icon(
                                    ed['icon'],
                                    size: 15,
                                    color: Colors.grey,
                                  )),
                            );
                          }).toList()),
                        ),
                        Text(
                          e[userId] != null
                              ? "${LogIn.allusers[LogIn.allusers.indexWhere((element) => element['user_id'] == e[userId])]['fullname']}"
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
      } else {
        return const ExpansionTile(
            title: Text("التعليقات"),
            children: [Text("لا يمكن الوصول للمخدم")]);
      }
    });
  }
}

deletecommentT({e, ctx, actiondelete}) {
  Comment.errmsg = null;
  MainController mainController = Get.find();
  showDialog(
      context: ctx,
      builder: (_) {
        return GetBuilder<MainController>(
          init: mainController,
          builder: (_) => AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                const Text("هل أنت متأكد من حذف التعليق"),
                Visibility(
                    visible: Comment.errmsg == null ? false : true,
                    child: Text("${Comment.errmsg}"))
              ],
            ),
            actions: [
              Visibility(
                  visible: !Comment.wait,
                  child: IconButton(
                      onPressed: () async {
                        mainController.deletecomment(
                            actiondeletecomment: () => actiondelete());
                      },
                      icon: const Icon(Icons.delete))),
              Visibility(
                  visible: Comment.wait,
                  child: const SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(),
                  ))
            ],
          ),
        );
      });
}

editcommentT({e, ctx, actionedit, controller}) {
  // Comment.errmsg = null;

  MainController mainController = Get.find();
  showDialog(
      context: ctx,
      builder: (_) {
        return GetBuilder<MainController>(
          init: mainController,
          builder: (_) => AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                TextFieldMZ(
                    maxlines: 2,
                    label: "تعديل التعليق",
                    textEditingController: controller,
                    onChanged: (x) {
                      null;
                    }),
                Visibility(
                    visible: Comment.errmsg == null ? false : true,
                    child: Text("${Comment.errmsg}"))
              ],
            ),
            actions: [
              Visibility(
                  visible: !Comment.wait,
                  child: IconButton(
                      onPressed: () async {
                        mainController.editcomment(
                            actioneditcomment: () => actionedit());
                      },
                      icon: const Icon(Icons.save))),
              Visibility(
                  visible: Comment.wait,
                  child: const SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(),
                  ))
            ],
          ),
        );
      });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          TextFieldMZ(
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
              ))
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
      required this.itemsWidget,
      required this.subeditvisible,
      required this.customeditpanelitem,
      this.where = ''});
  final List<Map> mylista;
  final String table, tableId, addlabel, where;
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
      itemsWidget,
      mainEditvisible,
      subeditvisible,
      customeditpanelitem;
  final bool mainAddvisible;
  final ScrollController scrollController;
  //static
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
                              usertable: DB.userstable,
                              list: mylista,
                              tableid: tableId,
                              table: table,
                              where: where);
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

                                if (officetrue.length !=
                                        officelist.length - 2 ||
                                    officetrue.isEmpty) {
                                  selectedOffice = 'مخصص';
                                }
                                if (officetrue.length ==
                                    officelist.length - 2) {
                                  selectedOffice = 'جميع المكاتب';
                                }
                                if (officetrue.length == 1) {
                                  selectedOffice = officetrue[0];
                                }
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              child: DropdownButton(
                                                  value: selectedOffice,
                                                  items: officelist
                                                      .map((e) =>
                                                          DropdownMenuItem(
                                                              value: e,
                                                              child:
                                                                  Text("$e")))
                                                      .toList(),
                                                  onChanged: (x) {
                                                    mainController
                                                        .chooseoffice(x);
                                                    dbController.update();
                                                  }),
                                            ),
                                          ),
                                          Expanded(
                                            child: GetBuilder<ThemeController>(
                                              init: themeController,
                                              builder: (_) => TextFieldMZ(
                                                  suffixIcon: Visibility(
                                                      visible: page == Tasks
                                                          ? true
                                                          : false,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            searchbydate(
                                                                ctx: context);
                                                          },
                                                          icon: const Icon(Icons
                                                              .date_range))),
                                                  label: "بحث",
                                                  onChanged: (word) async {
                                                    await mainController.search(
                                                        word: word,
                                                        list: mylista,
                                                        range: searchRange
                                                            .map((e) => e)
                                                            .toList());
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                                      Visibility(
                                                          visible: page == Logs
                                                              ? false
                                                              : true,
                                                          child: Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        eE = e;
                                                                        infoEditItemWidget(
                                                                            page:
                                                                                page,
                                                                            mainEditvisible: () =>
                                                                                mainEditvisible(),
                                                                            subeditvisible: () =>
                                                                                subeditvisible(),
                                                                            e:
                                                                                e,
                                                                            ctx:
                                                                                context,
                                                                            scrollController:
                                                                                scrollController,
                                                                            customInitforEdit: () =>
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
                                                                            customeditpanelitem: () =>
                                                                                customeditpanelitem());
                                                                      },
                                                                      child:
                                                                          itemsWidget()))),
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

                      //notification
                      //personal panel(logout and chang password)
                      Positioned(left: 0, child: PersonPanel()),
                    ],
                  )),
        ));
  }
}

checkifUserisinAnyOffice({usertable, userid}) {
  bool result = false;
  if (usertable[usertable.indexWhere((element) => element['user_id'] == userid)]
              ['privilege']
          .contains("موظف") ||
      usertable[usertable.indexWhere((element) => element['user_id'] == userid)]
              ['privilege']
          .contains("مشرف")) {
    result = true;
  }
  return result;
}

checkifUserisUserinOffice({officeid, usertable, userid}) {
  bool result = false;
  for (var j in usertable) {
    for (var l = 0; l < j['office'].length; l++) {
      if (j['office'][l] == officeid &&
          j['privilege'][l] == 'موظف' &&
          usertable[usertable.indexWhere(
                  (element) => element['user_id'] == userid)]['user_id'] ==
              j['user_id']) {
        result = true;
      }
    }
  }
  return result;
}

checkifUserisSame({userid, usertable}) {
  bool result = false;
  if (usertable[usertable.indexWhere(
          (element) => element['username'] == Home.logininfo)]['user_id'] ==
      userid) {
    result = true;
  }
  return result;
}

checkifUserisSupervisorinAnyOffice({userid, usertable}) {
  bool result = false;
  if (usertable[usertable.indexWhere((element) => element['user_id'] == userid)]
          ['privilege']
      .contains("مشرف")) {
    result = true;
  } else {
    result = false;
  }
  return result;
}

checkifUserisSupervisorinOffice({officeid, userid, usertable}) {
  bool result = false;
  for (var j in usertable) {
    for (var l = 0; l < j['office'].length; l++) {
      if (j['office'][l] == officeid &&
          j['privilege'][l] == 'مشرف' &&
          userid == j['user_id']) {
        result = true;
      }
    }
  }
  return result;
}

checkifUserisAdmin({userid, usertable}) {
  bool result = false;
  if (usertable[usertable.indexWhere((element) => element['user_id'] == userid)]
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
  static bool firstpage = true;
  static String? errormsg;
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Visibility(
                    visible: editpanelvisible,
                    child: Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: editpanel))),
                Visibility(
                    visible: !editpanelvisible,
                    child: Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                              visible: !firstpage,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () =>
                                          mainController.firstbackpage(),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                      )),
                                  addpanel,
                                ],
                              )),
                          Visibility(
                            visible: firstpage,
                            child: IconButton(
                                onPressed: () {
                                  mainController.firstbackpage();
                                },
                                icon: Transform.rotate(
                                  angle: 180 * pi / 180,
                                  child: const Icon(
                                    Icons.arrow_back,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ))),
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
            const Divider(),
            Visibility(
              visible: addeditvisible,
              child: Visibility(
                visible: firstpage,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...textFeildmzlista.map((e) => TextFieldMZ(
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
                              )),
                        ]),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: addeditvisible,
                child: Visibility(
                    visible: !firstpage,
                    child: Expanded(
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: customWidget)))),
            Visibility(
                visible: !addeditvisible,
                child: Visibility(
                    visible: firstpage,
                    child: Expanded(
                        child: SingleChildScrollView(child: getinfo())))),
          ]),
        ),
      ),
    );
  }
}

//addpanel
class AddPanel extends StatelessWidget {
  const AddPanel({super.key, required this.action, required this.addlabel});
  final Function action;
  final String addlabel;
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
                child: const SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    color: Colors.grey,
                  ),
                ))
          ],
        ),
      ]),
    );
  }
}

initialdataforAdd({textfeildlista, customInitdataforAdd}) {
  for (var i in textfeildlista) {
    ADDEDITINFOItem.firstpage = true;
    i['controller'].text = '';
    i['error'] = null;
  }
  ADDEDITINFOItem.errormsg = null;
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
    scrollController}) async {
  try {
    await DB().customquery(query: 'select * from users where user_id=1');
    MainController mainController = Get.find();
    initialdataforAdd(
        textfeildlista: textfeildlista,
        customInitdataforAdd: customInitdataforAdd);
    showBottomSheet(
        context: ctx,
        builder: (_) {
          return GetBuilder<MainController>(
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
          );
        });
  } catch (e) {
    return showDialog(
        context: ctx,
        builder: (_) {
          return const AlertDialog(
            content: Text(
              "لا يمكن الوصول للمخدم",
              textAlign: TextAlign.center,
            ),
          );
        });
  }
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
      required this.page,
      required this.subeditvisible,
      required this.customeditpanelitem});
  final Function actionDelete, actionEdit, actionSave, customeditpanelitem;
  final e;
  static bool wait = false, savevisible = false;
  final page;
  final Function mainEditvisible, subeditvisible;

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    List edititems() => [
          {
            'n': 3,
            'visible1': ADDEDITINFOItem.firstpage,
            'visible0': subeditvisible(),
            'visible': savevisible,
            'icon': Icons.arrow_back,
            'action': () => mainController.firstbackpage(),
          },
          {
            'n': 4,
            'visible1': !ADDEDITINFOItem.firstpage,
            'visible0': subeditvisible(),
            'visible': savevisible,
            'icon': Icons.arrow_back,
            'action': () => mainController.firstbackpage(),
          },
          {
            'n': 1,
            'visible1': true,
            'visible0': subeditvisible(),
            'visible': !savevisible,
            'icon': Icons.edit,
            'action': () => actionEdit(),
            'color': Colors.indigoAccent
          },
          {
            'n': 2,
            'visible1': !ADDEDITINFOItem.firstpage,
            'visible0': subeditvisible(),
            'visible': savevisible,
            'icon': Icons.save,
            'action': () => actionSave(),
            'color': Colors.indigoAccent
          },
          {
            'n': 0,
            'visible1': true,
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
        ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customeditpanelitem(),
        Visibility(
          visible: mainEditvisible(),
          child: Column(
            children: [
              Visibility(
                visible: !wait,
                child: Row(children: [
                  ...edititems().map((e) => Visibility(
                        visible: e['visible1'],
                        child: Visibility(
                          visible: e['visible0'],
                          child: Visibility(
                            visible: e['visible'],
                            child: e['n'] == 3
                                ? Transform.rotate(
                                    angle: 180 * pi / 180,
                                    child: IconButton(
                                        onPressed: e['action'],
                                        icon: Icon(
                                          e['icon'],
                                          color: e['color'],
                                        )),
                                  )
                                : IconButton(
                                    onPressed: e['action'],
                                    icon: Icon(
                                      e['icon'],
                                      color: e['color'],
                                    )),
                          ),
                        ),
                      )),
                ]),
              ),
              Visibility(
                  visible: wait,
                  child: const SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

initialdataforEdit({customInitdataforEdit, textfeildlista}) {
  for (var i in textfeildlista) {
    ADDEDITINFOItem.firstpage = true;
    i['controller'].text = '';
    i['error'] = null;
  }
  ADDEDITINFOItem.errormsg = null;
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
    page,
    subeditvisible,
    customeditpanelitem}) async {
  try {
    await DB().customquery(query: 'select * from users where user_id=1');
    MainController mainController = Get.find();
    initialdataforEdit(
        customInitdataforEdit: customInitforEdit,
        textfeildlista: textfeildlista);
    showBottomSheet(
        context: ctx,
        builder: (_) {
          return GetBuilder<MainController>(
              init: mainController,
              builder: (_) => ADDEDITINFOItem(
                    editpanel: Editpanel(
                        subeditvisible: subeditvisible,
                        mainEditvisible: mainEditvisible,
                        actionDelete: actionDelete,
                        actionEdit: actionEdit,
                        actionSave: actionSave,
                        customeditpanelitem: customeditpanelitem,
                        e: e,
                        page: page),
                    editpanelvisible: true,
                    scrollController: scrollController,
                    textFeildmzlista: textfeildlista,
                    customWidget: customWidgetofEdit,
                    getinfo: getinfo,
                  ));
        });
  } catch (e) {
    return showDialog(
        context: ctx,
        builder: (_) {
          return const AlertDialog(
            content: Text(
              "لا يمكن الوصول للمخدم",
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}

getprivileges() {
  List priv = DB.userstable[DB.userstable
          .indexWhere((element) => element['username'] == Home.logininfo)]
      ['privilege'];
  List off = DB.userstable[DB.userstable
          .indexWhere((element) => element['username'] == Home.logininfo)]
      ['office'];
  String p = '';
  for (var i = 0; i < priv.length; i++) {
    p +=
        "\n    * ${priv[i]} ${off[i] == '=' ? '' : off[i] == '_' ? '' : DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == off[i])]['officename']}";
  }
  DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['addping'] ==
          1
      ? p += "\n -إضافة بينغ"
      : null;
  DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['pbx'] ==
          1
      ? p += "\n -وصول لتسجيلات المقسم"
      : null;
  DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['addtodo'] ==
          1
      ? p += "\n -إضافة إجرائية"
      : null;
  DB.userstable[DB.userstable.indexWhere(
                  (element) => element['username'] == Home.logininfo)]
              ['addremind'] ==
          1
      ? p += "\n -إضافة تذكير"
      : null;
  return p;
}

List infoList = [];
showinfo({ctx}) {
  MainController mainController = Get.find();
  String? errormsg;
  mainController.cloasedp();
  infoList.clear();
  infoList = [
    [
      'اسم المستخدم',
      TextEditingController(
          text: DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['username']),
      true,
      null
    ],
    [
      'الاسم الكامل',
      TextEditingController(
          text: DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['fullname']),
      false,
      null
    ],
    [
      'الايميل',
      TextEditingController(
          text: DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['email']),
      false,
      null
    ],
    [
      'الموبايل',
      TextEditingController(
          text: DB.userstable[DB.userstable.indexWhere(
              (element) => element['username'] == Home.logininfo)]['mobile']),
      false,
      null
    ],
  ];
  DBController dbController = Get.find();
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
                                infoList[1][3] = null;
                                wait = true;
                                errormsg = null;
                                mainController.update();
                                if (infoList[1][1].text.isEmpty) {
                                  infoList[1][3] = 'لايمكن ان يكون الاسم فارغا';
                                  wait = false;
                                } else {
                                  try {
                                    await dbController.updatepersonalinfo(
                                        fullname: infoList[1][1].text,
                                        email: infoList[2][1].text,
                                        mobile: infoList[3][1].text,
                                        id: DB.userstable[DB.userstable
                                            .indexWhere((element) =>
                                                element['username'] ==
                                                Home.logininfo)]['user_id']);
                                    DB.userstable[DB.userstable.indexWhere(
                                            (element) =>
                                                element['username'] ==
                                                Home.logininfo)]['fullname'] =
                                        infoList[1][1].text;
                                    DB.userstable[DB.userstable.indexWhere(
                                            (element) =>
                                                element['username'] ==
                                                Home.logininfo)]['email'] =
                                        infoList[2][1].text;
                                    DB.userstable[DB.userstable.indexWhere(
                                            (element) =>
                                                element['username'] ==
                                                Home.logininfo)]['mobile'] =
                                        infoList[3][1].text;

                                    Get.back();
                                  } catch (e) {
                                    errormsg = 'لا يمكن الوصول للمخدم';
                                    mainController.update();
                                  }
                                  wait = false;
                                  mainController.update();
                                }
                              },
                              icon: const Icon(Icons.save)),
                        ),
                        Visibility(
                            visible: wait,
                            child: const SizedBox(
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
                          error: e[3],
                        )),
                    Text("${getprivileges()}")
                  ]),
            ),
          ),
        );
      });
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

getcommenttable({list, table, tableIdname, tableId}) async {
  var desctable = await DB().customquery(query: 'desc $table;');
  var selecttable = await DB()
      .customquery(query: 'select * from $table where $tableIdname=$tableId;');
  var y = 0, x = 0;
  list.clear();
  for (var i in selecttable) {
    list.add({});
    y = 0;
    for (var j in desctable) {
      list[x].addAll({j[0]: i[y]});
      y++;
    }
    x++;
  }
  return list;
}
