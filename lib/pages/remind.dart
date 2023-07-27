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
  static TextEditingController autoCertificateurl = TextEditingController();
  static TextEditingController timez = TextEditingController(text: '25');

  static String? remindofficeNameselected;
  static List remindofficelist = [];
  static List<Map> mylista = [], comment = [];
  static TextEditingController commentcontrolleredit = TextEditingController();
  static List imagcode = [];
  static int x = 0;
  static bool notifi = true, status = true;
  static int sendalertbefor = 0;
  static List typelist = [
    'مرة واحدة _ يدوي',
    'عدة مرات _ يدوي',
    'تجديد شهادة _ تلقائي',
  ];
  static String typevalue = 'مرة واحدة _ يدوي';
  static List manytimesremindlist = ['أسبوعي', 'شهري'];
  static String manytimesremindgroup = 'أسبوعي';
  static List weekly = [
    {'day': 'الجمعة', 'check': false},
    {'day': 'السبت', 'check': false},
    {'day': 'الأحد', 'check': false},
    {'day': 'الاثنين', 'check': false},
    {'day': 'الثلاثاء', 'check': false},
    {'day': 'الأربعاء', 'check': false},
    {'day': 'الخميس', 'check': false}
  ];
  static List monthly = [
    {'day': 'آخر يوم في الشهر', 'check': false}
  ];
  static DateTime onetimeremid = DateTime.now();
  static DateTime? remiddate;

  static int repeat = 15;
  static List days = [];
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
  static List monthlydays = [];
  static TimeOfDay hourlystartremindvalue = TimeOfDay.now();
  static String monthlydaysvalue = "1";
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
      'status',
      'manytimestype'
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
                  Expanded(
                      child: Text(itemResult[3] == '0'
                          ? 'يدوي مرة واحدة'
                          : itemResult[3] == '1'
                              ? 'يدوي عدة مرات ${itemResult[5] == 1 ? "شهري" : "أسبوعي"}'
                              : 'تلقائي')),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 10,
                          width: 20,
                          color: itemResult[4] == 1 ? Colors.red : Colors.green,
                        ),
                      ),
                      const Expanded(child: SizedBox())
                    ],
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
        builder: (_) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Row(children: [
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
                Visibility(
                    visible: typevalue == typelist[0] ? true : false,
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("تحديد تاريخ التذكير"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            mainController.setreminddate(ctx: context);
                          },
                          child: Text(
                              df.DateFormat('yyyy-MM-dd').format(onetimeremid)))
                    ])),
                Visibility(
                    visible: typevalue == typelist[1] ? true : false,
                    child: Column(
                      children: [
                        Row(children: [
                          Radio(
                              value: manytimesremindlist[0],
                              groupValue: manytimesremindgroup,
                              onChanged: (x) {
                                mainController.choosemanytimesremind(x);
                              }),
                          Text(manytimesremindlist[0]),
                          Radio(
                              value: manytimesremindlist[1],
                              groupValue: manytimesremindgroup,
                              onChanged: (x) {
                                mainController.choosemanytimesremind(x);
                              }),
                          Text(manytimesremindlist[1]),
                        ]),
                        Visibility(
                            visible:
                                manytimesremindgroup == manytimesremindlist[0]
                                    ? true
                                    : false,
                            child: Column(
                              children: weekly
                                  .map((e) => Row(
                                        children: [
                                          Checkbox(
                                              value: e['check'],
                                              onChanged: (x) {
                                                mainController
                                                    .remindweeklycheckbox(
                                                        x: x,
                                                        index:
                                                            weekly.indexOf(e));
                                              }),
                                          Text(e['day']),
                                        ],
                                      ))
                                  .toList(),
                            )),
                        Visibility(
                            visible:
                                manytimesremindgroup == manytimesremindlist[1]
                                    ? true
                                    : false,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Row(
                                    children: [
                                      const Text("أيام التذكير<"),
                                      const Text("إضافة يوم محدد"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButton(
                                            value: monthlydaysvalue,
                                            items: monthlydays
                                                .map((e) => DropdownMenuItem(
                                                    value: "$e",
                                                    child: Text(e)))
                                                .toList(),
                                            onChanged: (x) => mainController
                                                .chooseremindmonthlyvalue(x)),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await mainController
                                                .addmonthlyremindday(
                                                    value: monthlydaysvalue);
                                          },
                                          icon: const Icon(Icons.add))
                                    ],
                                  ),
                                  ...monthly.map((e) => Row(
                                        children: [
                                          Visibility(
                                            visible: e['day'].length > 2
                                                ? false
                                                : true,
                                            child: IconButton(
                                                onPressed: () {
                                                  mainController
                                                      .removemonthlyremindday(
                                                          value: e['day']);
                                                },
                                                icon: const Icon(Icons.delete)),
                                          ),
                                          Checkbox(
                                              value: e['check'],
                                              onChanged: (x) {
                                                mainController
                                                    .remindmonthlycheckbox(
                                                        x: x,
                                                        index:
                                                            monthly.indexOf(e));
                                              }),
                                          Text(e['day']),
                                        ],
                                      )),
                                ]))
                      ],
                    )),
                Visibility(
                    visible: typevalue == typelist[2] ? true : false,
                    child: TextFieldMZ(
                        textdirection: TextDirection.ltr,
                        label: 'عنوان الموقع',
                        textEditingController: autoCertificateurl,
                        onChanged: (x) => null)),
                const Divider(),
                Row(
                  children: [
                    const Text("بدء التذكير عند الساعة"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            mainController.setstartreminddate(ctx: context);
                          },
                          child: Text(
                              "${hourlystartremindvalue.hour}:${hourlystartremindvalue.minute}")),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("تذكير قبل"),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              mainController.sendalertbeforremindadd();
                            },
                            icon: Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              mainController.sendalertbeforremindmin();
                            },
                            icon: Icon(Icons.minimize)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$sendalertbefor"),
                    ),
                    const Text("يوم/أيام"),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("تكرار التذكير كل"),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              mainController.repeatalertbeforremindadd();
                            },
                            icon: Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              mainController.repeatalertbeforremindmin();
                            },
                            icon: Icon(Icons.minimize)),
                      ],
                    ),
                    Text(repeat < 60
                        ? '$repeat دقيقة'
                        : '${(repeat / 60).floor()} ساعة')
                  ],
                ),
              ]);
        });
    Widget customWidgetofEdit() =>
        Column(mainAxisSize: MainAxisSize.min, children: [customWidgetofADD()]);
    monthlydays.clear();
    for (var i = 1; i <= 31; i++) {
      monthlydays.add("$i");
    }
    days.clear();
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
                (checkifUserisUserinOffice(officeid: MYPAGE.eE['remind_office_id']) == true &&
                    DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                            ['addremind'] ==
                        1))
            ? true
            : false,
        subeditvisible: () =>
            (checkifUserisUserinOffice(officeid: MYPAGE.eE['remind_office_id']) == true &&
                    DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]
                            ['addremind'] ==
                        1)
                ? true
                : false,
        mainAddvisible: checkifUserisinAnyOffice() == true &&
                DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['addremind'] == 1
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
        actionDelete: () => deleteremind(ctx: context, e: MYPAGE.eE),
        customeditpanelitem: () => const SizedBox());
  }

  getinfo({e, ctx}) {
    if (Remind.typevalue == Remind.typelist[2]) {
      if (e['reminddate'] == null &&
          e['type'] == '2' &&
          e['autocerturl'] != null) {
        mainController.getreminddate(
            id: e['remind_id'], certsrc: e['autocerturl']);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
            "${DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == e['remind_office_id'])]['officename'] ?? 'مكتب محذوف'}"),
        SelectableText('''
#${e['remind_id']}_> ${e['remindname']}
${e['reminddetails']}
'''),
        e['reminddate'] != null
            ? Text(
                "تاريخ الانتهاء :   ${df.DateFormat('yyyy-MM-dd').format(e['reminddate'])}")
            : const Text("تاريخ الانتهاء غير محدد"),
        Text(
            "نمط التعيين : ${e['type'] == '0' ? 'يدوي مرة واحدة' : e['type'] == '1' ? 'يدوي عدة مرات ${e['manytimestype'] == 0 ? "أسبوعي" : "شهري"}' : 'تلقائي'}"),
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
        Divider(),
        e['type'] == '1'
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("أيام التذكير"),
                ...e['every'].map((v) => Text("> $v"))
              ])
            : e['type'] == '2'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("مصدر الشهادة"), Text(e['autocerturl'])],
                  )
                : SizedBox(),
        Divider(),
        Visibility(
            visible: e['reminddate'] == null ? false : true,
            child: e['reminddate'] != null
                ? Text(e['reminddate'].difference(DateTime.now()).inDays > 0
                    ? "المدة المتبقية  ${e['reminddate'].difference(DateTime.now()).inDays} يوم"
                    : e['reminddate'].difference(DateTime.now()).inDays == 0
                        ? (int.parse("${e['startsendat']}".substring(0, 2)) -
                                    DateTime.now().hour) >=
                                0
                            ? 'المدة المتبقية ${int.parse("${e['startsendat']}".substring(0, 2)) - DateTime.now().hour} ساعة'
                            : 'المدة المتبقية منتهية منذ ${(int.parse("${e['startsendat']}".substring(0, 2)) - DateTime.now().hour) * -1} ساعة'
                        : "المدة المتبقية منتهية منذ  ${e['reminddate'].difference(DateTime.now()).inDays} يوم")
                : const SizedBox()),
        const Divider(),
        Comment(
          comment: comment,
          deletecomment: () => deletecomment(ctx: ctx, e: e),
          editcomment: () => editcomment(ctx: ctx, e: e),
          table: 'users_remind_comments',
          tableIdname: 'urc_remind_id',
          tableId: e['remind_id'],
          officeId: e['remind_office_id'],
          userIdname: 'urc_user_id',
        ),
        WriteComment(e: e, writeComment: () => addcomment(e: MYPAGE.eE))
      ],
    );
  }

  customInitforAdd() {
    Remind.hourlystartremindvalue = TimeOfDay.now();
    sendalertbefor = 0;
    repeat = 15;
    monthly.clear();
    monthly = [
      {'day': 'آخر يوم في الشهر', 'check': false}
    ];
    for (var i in monthly) {
      i['check'] = false;
    }
    for (var i in weekly) {
      i['check'] = false;
    }
    Remind.autoCertificateurl.text = '';
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
            (element) => element['office_id'] == e['remind_office_id'])]
        ['officename'];
    Remind.onetimeremid = e['reminddate'] ?? DateTime.now();
    Remind.remindname.text = e['remindname'];
    Remind.reminddetails.text = e['reminddetails'];
    Remind.sendalertbefor = e['sendalertbefor'];
    Remind.hourlystartremindvalue = TimeOfDay.fromDateTime(DateTime.parse(
        '${DateTime.now().toString().substring(0, 10)} ${e['startsendat'].toString().substring(0, e['startsendat'].toString().indexOf(':')).length == 1 ? '0${e['startsendat']}' : '${e['startsendat']}'}'));
    Remind.autoCertificateurl.text = e['autocerturl'] ?? '';
    Remind.repeat = e['repeat'];
    monthly.clear();
    monthly = [
      {'day': 'آخر يوم في الشهر', 'check': false}
    ];
    for (var i in monthly) {
      i['check'] = false;
    }
    for (var i in weekly) {
      i['check'] = false;
    }
    if (e['type'] == '0') {
      typevalue = typelist[0];
    } else if (e['type'] == '1') {
      typevalue = typelist[1];
      if (e['manytimestype'] == 0) {
        Remind.manytimesremindgroup = Remind.manytimesremindlist[0];
        for (var i in e['every']) {
          switch (i) {
            case 'friday':
              weekly[0]['check'] = true;
              break;
            case 'satarday':
              weekly[1]['check'] = true;
              break;
            case 'sunday':
              weekly[2]['check'] = true;
              break;
            case 'monday':
              weekly[3]['check'] = true;
              break;
            case 'tuesday':
              weekly[4]['check'] = true;
              break;
            case 'wednesday':
              weekly[5]['check'] = true;
              break;
            case 'thursday':
              weekly[6]['check'] = true;
              break;
          }
        }
      } else {
        Remind.manytimesremindgroup = Remind.manytimesremindlist[1];
        for (var i in e['every']) {
          if (i == 'last') {
            monthly[0]['check'] = true;
          } else {
            monthly.add({'day': "$i", 'check': true});
          }
        }
      }
    } else {
      typevalue = typelist[2];
    }
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
    e['remindname'] = Remind.reminds[0]['controller'].text;
    e['reminddetails'] = Remind.reminds[1]['controller'].text;
    e['editby_id'] = DB.userstable[DB.userstable
        .indexWhere((y) => y['username'] == Home.logininfo)]['user_id'];
    e['editdate'] = DateTime.now();
    e['type'] = Remind.typevalue == Remind.typelist[0]
        ? "0"
        : Remind.typevalue == Remind.typelist[1]
            ? "1"
            : "2";
    e['manytimestype'] =
        Remind.manytimesremindgroup == Remind.manytimesremindlist[0] ? 0 : 1;

    e['reminddate'] = Remind.typevalue == Remind.typelist[0]
        ? Remind.onetimeremid
        : Remind.remiddate;
    if (e['type'] == '1') {
      if (e['manytimestype'] == 0) {
        e['every'].clear();
        for (var i in weekly) {
          if (i['check'] == true) {
            e['every'].add(i['day']);
          }
        }
      }
    }
    if (e['type'] == '1') {
      if (e['manytimestype'] == 1) {
        e['every'].clear();
        for (var i in monthly) {
          if (i['check'] == true) {
            e['every'].add(i['day']);
          }
        }
      }
    }
    e['autocerturl'] = Remind.autoCertificateurl.text;
  }

  deleteremind({ctx, e}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Remind);
  }

  addcomment({e}) async {
    MainController mainController = Get.find();
    if (e['commentcontroller'].text.isNotEmpty) {
      await mainController.addcomment(
        e: e,
        addcommentaction: dbController.addcommentremind(
            userid: DB.userstable[DB.userstable.indexWhere(
                (element) => element['username'] == Home.logininfo)]['user_id'],
            remindid: e['remind_id'],
            comment: e['commentcontroller'].text),
      );
    }
  }

  deletecomment({e, ctx, actiondelete}) async {
    await deletecommentT(
        ctx: ctx,
        actiondelete: () async => await dbController.deletecomment(
            table: 'users_remind_comments',
            commentIdname: 'urc_id',
            commentId: Comment.Ee['urc_id'],
            maintableidname: e['remind_id'],
            maintablename: 'remind'));
  }

  editcomment({e, ctx, actionedit}) async {
    commentcontrolleredit.text = Comment.Ee['comments'];
    await editcommentT(
        ctx: ctx,
        controller: commentcontrolleredit,
        actionedit: () async => await dbController.editcomment(
            table: 'users_remind_comments',
            commentIdname: 'urc_id',
            commentId: Comment.Ee['urc_id'],
            maintableidname: e['remind_id'],
            maintablename: 'remind',
            comment: commentcontrolleredit.text));
  }
}
