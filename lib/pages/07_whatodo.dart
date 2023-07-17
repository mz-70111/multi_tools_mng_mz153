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

class Whattodo extends StatelessWidget {
  Whattodo({super.key});
  DBController dbController = Get.find();
  static TextEditingController todoname = TextEditingController();
  static TextEditingController tododetails = TextEditingController();
  static String? todoofficeNameselected;
  static List todoofficelist = [];
  static List images = [];
  static List<Map> mylista = [], comment = [];
  static TextEditingController commentcontrolleredit = TextEditingController();
  static List imagcode = [];
  static int x = 0;
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
  static ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    List mainColumn = [
      {
        'label': 'الإجرائية',
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'todoname');
        }
      },
    ];
    List itemskey = ['todo_office_id', 'todo_id', 'todoname', 'tododetails'];
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
                    Expanded(
                        child: itemResult[3].length > 10
                            ? Text(
                                "${itemResult[3].toString().substring(0, 10)} ...")
                            : Text(itemResult[3]))
                  ],
                ),
              )),
            ],
          ),
        ),
        const Divider(),
      ]);
    }

    Map addFunction = {
      'action': () => addtodo(),
      'addlabel': 'إضافة إجرائية جديدة',
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
                    value: todoofficeNameselected,
                    items: todoofficelist
                        .map((e) =>
                            DropdownMenuItem(value: "$e", child: Text(e)))
                        .toList(),
                    onChanged: (x) => mainController.chooseofficetodo(x)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    onPressed: () {
                      mainController.addimagetotodo(
                          scrollcontroller: scrollController);
                    },
                    icon: const Icon(Icons.add)),
                const Text("إضافة صورة"),
              ]),
              Column(children: [
                ...Whattodo.images
                    .map((img) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                mainController.deleteimagetodo(
                                    Whattodo.images.indexOf(img));
                              },
                              icon: const Icon(Icons.close),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: img.runtimeType == Image
                                        ? img
                                        : Image.file(img)),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ])
            ]));
    Widget customWidgetofEdit() =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          customWidgetofADD(),
        ]);
    return MYPAGE(
        mylista: mylista,
        table: 'todo',
        tableId: 'todo_id',
        page: Whattodo,
        searchRange: const ['todoname', 'tododetails'],
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
        textfeildlista: todos,
        scrollController: scrollController,
        mainEditvisible: () => (checkifUserisAdmin() == true ||
              (checkifUserisUserinOffice(
                    officeid: MYPAGE.eE['todo_office_id']) ==
                true &&  DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['addtodo'] ==
                    1))
            ? true
            : false,
        subeditvisible: () =>
            (checkifUserisUserinOffice(officeid: MYPAGE.eE['todo_office_id']) ==
                    true && DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['addtodo'] ==
                    1)
                ? true
                : false,
        mainAddvisible: checkifUserisinAnyOffice() == true &&
                DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['addtodo'] ==
                    1
            ? true
            : false,
        getinfo: () {
          return getinfo(
            e: MYPAGE.eE,
            ctx: context,
          );
        },
        actionSave: () => edittodo(e: MYPAGE.eE),
        actionEdit: () => mainController.showeditpanel(),
        actionDelete: () => deletetodo(ctx: context, e: MYPAGE.eE),
        customeditpanelitem: () => const SizedBox());
  }

  getinfo({e, ctx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${e['todo_office_id'] ?? 'مكتب محذوف'}"),
        SelectableText('''
              # ${e['todo_id']} ${e['todoname']}
              ${e['tododetails']}
              '''),
        Column(
          children: [
            ...e['images'].map((i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: mainController.convertimagestodoTodecode(
                                    image: i)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
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
    todoofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisUserinOffice(officeid: i['office_id']) == true ||
          checkifUserisSupervisorinOffice(
                officeid: i['office_id'],
                userid: DB.userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id'],
              ) ==
              true) {
        todoofficelist.add(i['officename']);
      }
    }
    todoofficeNameselected = todoofficelist[0];
    images.clear();
  }

  customInitforEdit({e}) async {
    imagcode.clear();
    for (var i in Whattodo.todos) {
      i['error'] = null;
    }
    todoofficelist.clear();
    for (var i in DB.officetable) {
      if (checkifUserisUserinOffice(officeid: i['office_id']) == true ||
          checkifUserisSupervisorinOffice(
                officeid: i['office_id'],
                userid: DB.userstable[DB.userstable.indexWhere(
                        (element) => element['username'] == Home.logininfo)]
                    ['user_id'],
              ) ==
              true) {
        todoofficelist.add(i['officename']);
      }
    }
    todoofficeNameselected = DB.officetable[DB.officetable.indexWhere(
            (element) => element['office_id'] == e['todo_office_id'])]
        ['officename'];
    Whattodo.todoname.text = e['todoname'];
    Whattodo.tododetails.text = e['tododetails'];
    images.clear();
    for (var i in e['images']) {
      imagcode.add(i);
      images.add(mainController.convertimagestodoTodecode(image: i));
    }
  }

  addtodo() async {
    MainController mainController = Get.find();
    await mainController.addItemMainController(
        page: Whattodo,
        listofFeildmz: Whattodo.todos,
        itemnameController: Whattodo.todoname.text,
        scrollcontroller: Whattodo.scrollController);
  }

  edittodo({e}) async {
    MainController mainController = Get.find();
    await mainController.editItemMainController(
        page: Whattodo, e: MYPAGE.eE, listofFeildmz: Whattodo.todos);
    updateafteredit(e: e);
  }

  updateafteredit({e}) async {
    e['todoname'] = Whattodo.todos[0]['controller'].text;
    e['tododetails'] = Whattodo.todos[1]['controller'].text;
    e['editby_id'] = DB.userstable[DB.userstable
        .indexWhere((y) => y['username'] == Home.logininfo)]['user_id'];
    e['editdate'] = DateTime.now();
    e['images'].clear();
    var y = 0;

    for (var i in images) {
      if (i.runtimeType == Image) {
        e['images'].add(imagcode[y]);
        y++;
      } else {
        e['images'].add(await mainController.convertimagestodoTocode(image: i));
      }
    }
  }

  deletetodo({ctx, e}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(
        ctx: ctx, e: e, page: Whattodo);
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
