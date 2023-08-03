import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/06_tasks.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class Office extends StatelessWidget {
  const Office({super.key});

  static TextEditingController officename = TextEditingController();
  static TextEditingController chatid = TextEditingController();
  static bool notifi = false;
  static List colorpicklist = [
    {'size': 30.0, 'color': Colors.black},
    {'size': 30.0, 'color': Colors.amberAccent},
    {'size': 30.0, 'color': Colors.blueAccent},
    {'size': 30.0, 'color': Colors.blueGrey},
    {'size': 30.0, 'color': Colors.brown},
    {'size': 30.0, 'color': Colors.cyanAccent},
    {'size': 30.0, 'color': Colors.deepOrangeAccent},
    {'size': 30.0, 'color': Colors.deepPurpleAccent},
    {'size': 30.0, 'color': Colors.greenAccent},
    {'size': 30.0, 'color': Colors.indigoAccent},
    {'size': 30.0, 'color': Colors.limeAccent},
    {'size': 30.0, 'color': Colors.orangeAccent},
    {'size': 30.0, 'color': Colors.purpleAccent},
    {'size': 30.0, 'color': Colors.redAccent},
    {'size': 30.0, 'color': Colors.tealAccent},
  ];
  static List<Map> mylista = [];
  static List temp = [];
  static List<Map> offices = [
    {
      'label': 'اسم المكتب',
      'controller': officename,
      'error': null,
      'icon': Icons.work,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.rtl
    },
    {
      'label': 'chat id',
      'controller': chatid,
      'error': null,
      'icon': Icons.api,
      'obscuretext': false,
      'hint': '',
      'td': TextDirection.ltr
    },
  ];
  static Color selectcolor = colorpicklist[0]['color'];
  static List customWidgetofEdit({ctx, pickcolor}) => [];
  static ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    List mainColumn = [
      {
        'label': 'اسم المكتب',
        'visible': true,
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'officename');
        }
      },
    ];
    List itemskey = ['color', 'office_id', 'officename'];
    List itemResult = [];
    List colors = [];
    Widget itemsWidget() {
      colors.clear();
      colors.add(itemResult[0]);
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...colors.map((c) =>
                  Container(height: 40, width: 10, color: Color(int.parse(c)))),
              Expanded(child: Text("# ${itemResult[1]}_ ${itemResult[2]}")),
            ],
          ),
        ),
        Divider(),
      ]);
    }

    Map addFunction = {
      'action': () => addoffice(),
      'addlabel': 'إضافة مكتب جديد',
    };
    Widget customWidgetofADD({ctx, pickcolor}) => GetBuilder<MainController>(
        init: mainController,
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Switch(
                      value: notifi,
                      onChanged: (x) {
                        mainController.changeofficeNotifi(x);
                      }),
                  const Expanded(child: Text('تفعيل اشعارات التلغرام'))
                ],
              ),
              Row(children: [
                const Expanded(child: Text("تخصيص لون للمكتب")),
                ElevatedButton(
                  onPressed: pickcolor,
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(selectcolor)),
                  child: const SizedBox(),
                )
              ]),
            ]));
    Widget customWidgetofEdit({ctx, pickcolor}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [customWidgetofADD(ctx: ctx, pickcolor: pickcolor)]);

    return MYPAGE(
      mylista: mylista,
      table: 'office',
      tableId: 'office_id',
      where: DB.userstable[DB.userstable.indexWhere(
                      (element) => element['username'] == Home.logininfo)]
                  ['admin'] ==
              1
          ? ''
          : 'join users_office on uf_office_id=office_id join users on uf_user_id=user_id where user_id=${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['user_id']}',
      page: Office,
      searchRange: const ['officename'],
      mainColumn: mainColumn,
      items: itemskey,
      itemsResult: itemResult,
      itemsWidget: () => itemsWidget(),
      notifi: const SizedBox(),
      addlabel: addFunction['addlabel'],
      action: addFunction['action'],
      customInitdataforAdd: () => customInitforAdd(),
      customWidgetofADD: customWidgetofADD(
          ctx: context, pickcolor: () => pickcolor(ctx: context)),
      textfeildlista: offices,
      scrollController: scrollController,
      mainEditvisible: () => checkifUserisAdmin(
                  usertable: DB.userstable,
                  userid: DB.userstable[DB.userstable.indexWhere(
                          (element) => element['username'] == Home.logininfo)]
                      ['user_id']) ==
              true
          ? true
          : false,
      subeditvisible: () => true,
      mainAddvisible: checkifUserisAdmin(
                  usertable: DB.userstable,
                  userid: DB.userstable[DB.userstable.indexWhere(
                          (element) => element['username'] == Home.logininfo)]
                      ['user_id']) ==
              true
          ? true
          : false,
      customWidgetofEdit: customWidgetofEdit(
          ctx: context, pickcolor: () => pickcolor(ctx: context)),
      customInitforEdit: () => customInitforEdit(e: MYPAGE.eE),
      getinfo: () => getinfo(e: MYPAGE.eE, ctx: context),
      actionSave: () => editOfficeSaveAction(e: MYPAGE.eE),
      actionEdit: () => mainController.showeditpanel(),
      actionDelete: () => deleteOffice(ctx: context, e: MYPAGE.eE),
      customeditpanelitem: () => Visibility(
        visible: (checkifUserisAdmin(
                        usertable: DB.userstable,
                        userid: DB.userstable[DB.userstable.indexWhere(
                                (element) =>
                                    element['username'] == Home.logininfo)]
                            ['user_id']) ==
                    true ||
                checkifUserisSupervisorinOffice(
                        officeid: MYPAGE.eE['office_id'],
                        userid: DB.userstable[DB.userstable.indexWhere((element) =>
                            element['username'] == Home.logininfo)]['user_id'],
                        usertable: DB.userstable) ==
                    true)
            ? true
            : false,
        child: Row(
          children: [
            Text("إرسال المهام تلقائيا"),
            Text(MYPAGE.eE['autosendtasks'] == 1 ? "تفعيل" : "إيقاف"),
            Switch(
                value: MYPAGE.eE['autosendtasks'] == 1 ? true : false,
                onChanged: (x) {
                  mainController.autosendtasknotifichg(x: x, e: MYPAGE.eE);
                }),
          ],
        ),
      ),
    );
  }

  pickcolor({ctx}) {
    MainController mainController = Get.find();

    for (var i in colorpicklist) {
      i['size'] = 30.0;
    }
    showDialog(
        context: ctx,
        builder: (_) {
          return GetBuilder<MainController>(
            init: mainController,
            builder: (_) => AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: colorpicklist
                      .sublist(0, colorpicklist.length ~/ 3)
                      .map((e) => MouseRegion(
                            onHover: (event) =>
                                mainController.changeonhoverOfficecolor(
                                    colorpicklist.indexOf(e)),
                            onExit: (event) =>
                                mainController.changeonExitOfficecolor(
                                    colorpicklist.indexOf(e)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => mainController
                                    .selectOfficecolor(e['color']),
                                child: Container(
                                  height: e['size'],
                                  width: e['size'],
                                  color: e['color'],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Row(
                  children: colorpicklist
                      .sublist(
                          colorpicklist.length ~/ 3,
                          (colorpicklist.length ~/ 3) +
                              (colorpicklist.length ~/ 3))
                      .map((e) => MouseRegion(
                            onHover: (event) =>
                                mainController.changeonhoverOfficecolor(
                                    colorpicklist.indexOf(e)),
                            onExit: (event) =>
                                mainController.changeonExitOfficecolor(
                                    colorpicklist.indexOf(e)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => mainController
                                    .selectOfficecolor(e['color']),
                                child: Container(
                                  height: e['size'],
                                  width: e['size'],
                                  color: e['color'],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Row(
                  children: colorpicklist
                      .sublist((colorpicklist.length ~/ 3) +
                          (colorpicklist.length ~/ 3))
                      .map((e) => MouseRegion(
                            onHover: (event) =>
                                mainController.changeonhoverOfficecolor(
                                    colorpicklist.indexOf(e)),
                            onExit: (event) =>
                                mainController.changeonExitOfficecolor(
                                    colorpicklist.indexOf(e)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => mainController
                                    .selectOfficecolor(e['color']),
                                child: Container(
                                  height: e['size'],
                                  width: e['size'],
                                  color: e['color'],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            )),
          );
        });
  }

  customInitforAdd() {
    notifi = false;
  }

  customInitforEdit({e}) {
    MainController mainController = Get.find();
    for (var i in Office.offices) {
      i['error'] = null;
    }
    Office.selectcolor = colorpicklist[0]['color'];
    Office.notifi = e['notifi'] == 0 ? false : true;
    Office.offices[0]['controller'].text = e['officename'];
    Office.offices[1]['controller'].text = e['chatid'];
    Office.selectcolor = Color(int.parse(e['color']));
    mainController.cloasedp();
  }

  addoffice() async {
    MainController mainController = Get.find();
    await mainController.addItemMainController(
        page: Office,
        listofFeildmz: Office.offices,
        itemnameController: Office.officename.text,
        scrollcontroller: Office.scrollController);
  }

  getinfo({e, ctx}) {
    List supervisor = [];
    List users = [];
    supervisor.clear();
    users.clear();
    for (var i in DB.userstable) {
      for (var j = 0; j < i['office'].length; j++) {
        if (i['office'][j] == e['office_id'] && i['privilege'][j] == 'مشرف') {
          supervisor.add("_#${i['user_id']}_ ${i['fullname']}");
        } else if (i['office'][j] == e['office_id'] &&
            i['privilege'][j] == 'موظف') {
          users.add("_#${i['user_id']}_ ${i['fullname']}");
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 30,
              width: 10,
              color: Color(int.parse(e['color'])),
            ),
            Text("# ${e['office_id']}_${e['officename']}"),
          ],
        ),
        SelectableText("chatID: ${e['chatid']}"),
        Text("الاشعارات :${e['notifi'] == 1 ? "مفعلة" : "غير مفعلة"}"),
        TextButton.icon(
          onPressed: () {
            gettaskinfoOffice(e: e, ctx: ctx);
          },
          icon: const Icon(Icons.task_outlined),
          label: Text('مهمات موظفي المكتب'),
        ),
        Text("عدد موظفي المكتب ${users.length}"),
        supervisor.isEmpty
            ? const Text('مشرف المكتب _ لايوجد')
            : Column(children: [
                ...supervisor.map((e) => Text("مشرف المكتب: $e")).toList()
              ]),
        users.isEmpty
            ? const Text('موظفوا المكتب _ لايوجد')
            : Column(children: [
                const Text("موظفوا المكتب"),
                ...users.map((c) => Text(" $c")).toList()
              ]),
      ],
    );
  }

  editOfficeSaveAction({e}) async {
    MainController mainController = Get.find();

    await mainController.editItemMainController(
        page: Office, e: MYPAGE.eE, listofFeildmz: Office.offices);
    updateafteredit(e: e);
  }

  updateafteredit({e}) {
    e['officename'] = Office.offices[0]['controller'].text;
    e['chatid'] = Office.offices[1]['controller'].text;
    e['notifi'] = Office.notifi == true ? 1 : 0;
    e['color'] = Office.selectcolor.toString().contains("Material")
        ? Office.selectcolor.toString().substring(
            Office.selectcolor.toString().indexOf('value: Color(') + 13,
            Office.selectcolor.toString().length - 2)
        : Office.selectcolor.toString().substring(
            Office.selectcolor.toString().indexOf('Color(') + 6,
            Office.selectcolor.toString().length - 1);
  }

  deleteOffice({e, ctx}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Office);
  }

  gettaskinfoOffice({ctx, e}) {
    List usershavenotask = [];
    String mymsg = '';
    for (var i in e['users'] ?? []) {
      if (checkifUserisSupervisorinOffice(
            usertable: DB.userstable,
            officeid: e['office_id'],
            userid: i,
          ) ==
          false) {
        if (!usershavenotask.contains(DB.userstable[DB.userstable
            .indexWhere((element) => element['user_id'] == i)]['fullname'])) {
          usershavenotask.add(DB.userstable[DB.userstable
              .indexWhere((element) => element['user_id'] == i)]['fullname']);
        }
      }
    }
    mymsg += 'مهمات ${e['officename']}\n';
    for (var j in DB.tasktable) {
      if (j['notifi'] == 1 && j['task_office_id'] == e['office_id']) {
        mymsg += """
${Tasks.mymsgTask(e: j)}
""";
      }

      try {
        for (var l in j['userstask_name']) {
          if (j['notifi'] == 1 && j['task_office_id'] == e['office_id']) {
            usershavenotask.removeWhere((element) => element == l);
          }
        }
      } catch (e) {
        null;
      }
    }

    for (var iii in usershavenotask) {
      mymsg += '$iii ليس لديه مهمة حاليا \n';
    }

    showDialog(
        context: ctx,
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,
              content: SelectableText(mymsg),
              actions: [
                Visibility(
                  visible: checkifUserisSupervisorinOffice(
                    usertable: DB.userstable,
                    officeid: e['office_id'],
                    userid: DB.userstable[DB.userstable.indexWhere(
                            (element) => element['username'] == Home.logininfo)]
                        ['user_id'],
                  )
                      ? true
                      : false,
                  child: TextButton.icon(
                      label: Text("إرسال اشعار الى ${e['officename']}"),
                      onPressed: () async {
                        mymsg +=
                            'قام بإرسال الإشعار ${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == Home.logininfo)]['fullname']}';
                        Tasks.sendtask(msg: mymsg, chatid: e['chatid']);
                      },
                      icon: const Icon(Icons.send)),
                )
              ],
            ),
          );
        });
  }
}
