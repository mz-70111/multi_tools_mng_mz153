import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

class Remind extends StatelessWidget {
  Remind({super.key});
  DBController dbController = Get.find();
  static TextEditingController remindname = TextEditingController();
  static TextEditingController reminddetails = TextEditingController();
  static String? remindofficeNameselected;
  static List remindofficelist = [];
  static List<Map> mylista = [], comment = [];
  static TextEditingController commentcontrolleredit = TextEditingController();
  static List imagcode = [];
  static int x = 0;
  static bool notifi = true, status = true;
  static List typelist = [
    'مرة واحدة _ يدوي',
    'عدة مرات _ يدوي',
    'تجديد شهادة _ تلقائي',
  ];
  static String typevalue = 'مرة واحدة _ يدوي';
  static double repeat = 1;
  static List<Map> reminds = [
    {
      'label': 'عنوان التذكير',
      'controller': remindname,
      'error': null,
      'icon': Icons.work,
      'obscuretext': false,
      'hint': '',
    },
    {
      'label': 'التفاصيل',
      'controller': reminddetails,
      'error': null,
      'icon': Icons.details,
      'obscuretext': false,
      'hint': '',
      'maxlines': 4
    },
  ];
  static ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    List mainColumn = [
      {
        'label': 'عنوان التذكير',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'remindname');
        }
      },
      {
        'label': 'نوع التذكير',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'type');
        }
      },
      {
        'label': 'حالة التذكير',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'status');
        }
      },
    ];
    List itemskey = [
      'remind_office_id',
      'remind_id',
      'remindname',
      'type',
      'status'
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
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            ...colors.map((c) =>
                Container(height: 50, width: 10, color: Color(int.parse(c)))),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "# ${itemResult[1]}_ ${itemResult[2]}",
                    style: const TextStyle(fontSize: 13),
                  )),
                  Expanded(child: Text(itemResult[3])),
                  Expanded(
                      child: Container(
                    height: 20,
                    color: itemResult[4] == 1 ? Colors.red : Colors.green,
                  ))
                ],
              ),
            )),
          ]),
        ),
        const Divider(),
      ]);
    }

    Map addFunction = {
      'action': () => addremind(),
      'addlabel': 'إضافة تذكير جديد',
    };
    Widget customWidgetofADD() => GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("اختيار مكتب"),
                ),
                DropdownButton(
                    value: remindofficeNameselected,
                    items: remindofficelist
                        .map((e) =>
                            DropdownMenuItem(value: "$e", child: Text(e)))
                        .toList(),
                    onChanged: (x) => mainController.chooseofficeremind(x)),
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("تحديد نوع التذكير"),
                ),
                DropdownButton(
                    value: typevalue,
                    items: typelist
                        .map((e) =>
                            DropdownMenuItem(value: "$e", child: Text(e)))
                        .toList(),
                    onChanged: (x) => mainController.chooseremindtype(x)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("تكرار إرسال التذكير كل"),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Slider(
                            min: 1,
                            max: 4 * 24,
                            divisions: 4 * 24,
                            value: repeat,
                            onChanged: (x) {
                              mainController.chooseremindrepeat(x);
                            })),
                    Text(repeat * 15 < 60
                        ? '${(repeat * 15).floor()} دقيقة'
                        : '${(repeat * 15 / 60).floor()} ساعة')
                  ],
                ),
              ]),
            ]));
    Widget customWidgetofEdit() =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          customWidgetofADD(),
        ]);
    return MYPAGE(
        mylista: mylista,
        table: 'remind',
        tableId: 'remind_id',
        page: Remind,
        searchRange: const ['remindname', 'reminddetails'],
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
        textfeildlista: reminds,
        scrollController: scrollController,
        mainEditvisible: () => (checkifUserisAdmin() == true ||
                checkifUserisSupervisorinOffice(
                      officeid: MYPAGE.eE['remind_office_id'],
                      userid: DB.userstable[DB.userstable.indexWhere(
                              (element) =>
                                  element['username'] == Home.logininfo)]
                          ['user_id'],
                    ) ==
                    true ||
                checkifUserisSame(userId: MYPAGE.eE['createby_id']) == true)
            ? true
            : false,
        subeditvisible: () => checkifUserisSupervisorinOffice(
                        userid: DB.userstable[DB.userstable.indexWhere(
                                (element) => element['username'] == Home.logininfo)]
                            ['user_id'],
                        officeid: MYPAGE.eE['remind_office_id']) ==
                    true ||
                checkifUserisSame(userId: MYPAGE.eE['createby_id']) == true
            ? true
            : false,
        mainAddvisible: checkifUserisinAnyOffice() == true &&
                DB.userstable[DB.userstable
                        .indexWhere((element) => element['username'] == Home.logininfo)]['addremind'] ==
                    1
            ? true
            : false,
        getinfo: () {
          return getinfo(
            e: MYPAGE.eE,
            ctx: context,
          );
        },
        actionSave: () => editremind(e: MYPAGE.eE),
        actionEdit: () => mainController.showeditpanel(),
        actionDelete: () => deletetodo(ctx: context, e: MYPAGE.eE),
        customeditpanelitem: () => const SizedBox());
  }

  getinfo({e, ctx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${e['remind_office_id'] ?? 'مكتب محذوف'}"),
        SelectableText('''
              # ${e['remind_id']} ${e['remindname']}
              ${e['reminddetails']}
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
        const Divider(),
        Comment(
          comment: comment,
          deletecomment: () => deletecomment(ctx: ctx, e: e),
          editcomment: () => editcomment(ctx: ctx, e: e),
          table: 'users_todo_comments',
          tableIdname: 'utdc_todo_id',
          tableId: e['todo_id'],
          officeId: e['todo_office_id'],
          userIdname: 'utdc_user_id',
        ),
        WriteComment(e: e, writeComment: () => addcomment(e: MYPAGE.eE))
      ],
    );
  }

  customInitforAdd() {
    remindofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisUserinOffice(officeid: i['office_id']) == true ||
          checkifUserisSupervisorinOffice(
                officeid: i['office_id'],
                userid: DB.userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id'],
              ) ==
              true) {
        remindofficelist.add(i['officename']);
      }
    }
    remindofficeNameselected = remindofficelist[0];
  }

  customInitforEdit({e}) async {
    for (var i in Remind.reminds) {
      i['error'] = null;
    }
    remindofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisUserinOffice(officeid: i['office_id']) == true ||
          checkifUserisSupervisorinOffice(
                officeid: i['office_id'],
                userid: DB.userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id'],
              ) ==
              true) {
        remindofficelist.add(i['officename']);
      }
    }
    remindofficeNameselected = DB.officetable[DB.officetable.indexWhere(
            (element) => element['office_id'] == e['todo_office_id'])]
        ['officename'];
    Remind.remindname.text = e['remindname'];
    Remind.reminddetails.text = e['reminddetails'];
  }

  addremind() async {
    MainController mainController = Get.find();
    await mainController.addItemMainController(
        page: Remind,
        listofFeildmz: Remind.reminds,
        itemnameController: Remind.remindname.text,
        scrollcontroller: Remind.scrollController);
  }

  editremind({e}) async {
    MainController mainController = Get.find();
    await mainController.editItemMainController(
        page: Remind, e: MYPAGE.eE, listofFeildmz: Remind.reminds);
    updateafteredit(e: e);
  }

  updateafteredit({e}) async {
    e['todoname'] = Remind.reminds[0]['controller'].text;
    e['tododetails'] = Remind.reminds[1]['controller'].text;
    e['editby_id'] = DB.userstable[DB.userstable
        .indexWhere((y) => y['username'] == Home.logininfo)]['user_id'];
    e['editdate'] = DateTime.now();
    e['images'].clear();
  }

  deletetodo({ctx, e}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Remind);
  }

  addcomment({e}) async {
    MainController mainController = Get.find();
    if (e['commentcontroller'].text.isNotEmpty) {
      await mainController.addcomment(
        e: e,
        addcommentaction: dbController.addcommenttodo(
            userid: DB.userstable[DB.userstable.indexWhere(
                (element) => element['username'] == Home.logininfo)]['user_id'],
            todoid: e['todo_id'],
            comment: e['commentcontroller'].text),
      );
    }
  }

  deletecomment({e, ctx, actiondelete}) async {
    await deletecommentT(
        ctx: ctx,
        actiondelete: () async => await dbController.deletecomment(
            table: 'users_todo_comments',
            commentIdname: 'utdc_id',
            commentId: Comment.Ee['utdc_id'],
            maintableidname: e['todo_id'],
            maintablename: 'todo'));
  }

  editcomment({e, ctx, actionedit}) async {
    commentcontrolleredit.text = Comment.Ee['comments'];
    await editcommentT(
        ctx: ctx,
        controller: commentcontrolleredit,
        actionedit: () async => await dbController.editcomment(
            table: 'users_todo_comments',
            commentIdname: 'utdc_id',
            commentId: Comment.Ee['utdc_id'],
            maintableidname: e['todo_id'],
            maintablename: 'todo',
            comment: commentcontrolleredit.text));
  }
}
