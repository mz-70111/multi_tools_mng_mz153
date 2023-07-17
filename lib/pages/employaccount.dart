import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class Employ extends StatelessWidget {
  const Employ({super.key});
  static TextEditingController username = TextEditingController();
  static TextEditingController fullname = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController confirmpassword = TextEditingController();
  static TextEditingController email = TextEditingController();
  static TextEditingController mobile = TextEditingController();
  static bool admin = false;
  static bool enable = true;
  static bool mustchgpass = true;
  static bool addping = false;
  static bool addremind = false;
  static bool pbx = false;
  static bool addtodo = false;
  static List<Map> mylista = [];
  static List<Map> employs = [
    {
      'label': 'اسم المستخدم',
      'controller': username,
      'error': null,
      'icon': Icons.person,
      'obscuretext': false,
      'hint': ''
    },
    {
      'label': 'الاسم الكامل',
      'controller': fullname,
      'error': null,
      'icon': Icons.display_settings,
      'obscuretext': false,
      'hint': ''
    },
    {
      'label': 'كلمة المرور',
      'controller': password,
      'error': null,
      'icon': Icons.visibility_off,
      'obscuretext': true,
      'action': () => mainController.showpassAdduser(),
      'hint': ''
    },
    {
      'label': 'تأكيد كلمة المرور',
      'controller': confirmpassword,
      'error': null,
      'icon': Icons.visibility_off,
      'obscuretext': true,
      'action': () => mainController.showpassAdduser(),
      'hint': ''
    },
    {
      'label': 'الايميل',
      'controller': email,
      'error': null,
      'icon': Icons.email,
      'obscuretext': false,
      'hint': ''
    },
    {
      'label': 'الموبايل',
      'controller': mobile,
      'error': null,
      'icon': Icons.phone,
      'obscuretext': false,
      'hint': ''
    }
  ];
  static List<Map> privilege = [];
  static List permission = ['موظف', 'مشرف'];
  static ScrollController scrollController = ScrollController();
  static String information = '';
  static List<Color> personenablecolor = [];

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    List mainColumn = [
      {
        'label': 'الاسم',
        'visible': true,
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'fullname');
        }
      },
    ];
    List itemskey = ['office', 'user_id', 'fullname', 'enable'];
    List itemResult = [];
    List colors = [];
    Widget itemsWidget() {
      colors.clear();
      if (itemResult[0] != null) {
        for (var i in itemResult[0]) {
          try {
            colors.add(DB.officetable[DB.officetable
                .indexWhere((element) => element['office_id'] == i)]['color']);
          } catch (ee) {
            null;
          }
        }
      }
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ...colors.map((c) =>
                  Container(height: 40, width: 10, color: Color(int.parse(c)))),
              Icon(
                Icons.person,
                color: itemResult[3] == 1 ? Colors.green : Colors.grey,
              ),
              Expanded(child: Text("# ${itemResult[1]}_ ${itemResult[2]}")),
            ],
          ),
        ),
        const Divider(),
      ]);
    }

    Map addFunction = {
      'action': () => adduser(),
      'addlabel': 'إضافة حساب جديد',
    };
    Widget customWidgetofADD() => GetBuilder<MainController>(
          init: mainController,
          builder: (_) => Column(children: [
            Row(
              children: [
                Checkbox(
                    value: Employ.mustchgpass,
                    onChanged: (x) {
                      mainController.checkboxchngpass(x);
                    }),
                const Text("يجب إعادة تعيين كلمة المرور")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: Employ.admin,
                    onChanged: (x) {
                      mainController.checkboxadmin(x);
                    }),
                const Text("صلاحيات مسؤول")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: Employ.addremind,
                    onChanged: (x) {
                      mainController.checkboxaddremind(x);
                    }),
                const Text("إضافة/تعديل تذكير")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: Employ.addping,
                    onChanged: (x) {
                      mainController.checkboxaddping(x);
                    }),
                const Text("إضافة/تعديل ping")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: Employ.pbx,
                    onChanged: (x) {
                      mainController.checkboxpbx(x);
                    }),
                const Text("صلاحيات وصول الى تسجيلات المقسم")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: Employ.addtodo,
                    onChanged: (x) {
                      mainController.checkboxaddtodo(x);
                    }),
                const Text("إضافة/تعديل إجرائية")
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {
                    mainController.addprivilege(
                        scrollController: scrollController);
                  },
                  icon: const Icon(Icons.add)),
              const Text("إضافة الى مكتب"),
            ]),
            Column(
              children: [
                ...privilege
                    .map((e) => Privilege(
                          privilege: e['privilege'],
                          office: e['office'],
                          index: privilege.indexOf(e),
                          selectPermission: (x) => mainController.selectpriv(
                              x, privilege.indexOf(e)),
                          selectOffice: (x) => mainController.selectoffice(
                              x, privilege.indexOf(e)),
                        ))
                    .toList()
              ],
            ),
          ]),
        );
    Widget customWidgetofEdit({ctx}) =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          GetBuilder<MainController>(
            init: mainController,
            builder: (_) => Row(
              children: [
                Switch(
                    value: enable,
                    onChanged: (x) {
                      mainController.switchcase(x: x, item: Employ.enable);
                    }),
                Text(enable == true ? "حساب فعال" : "حساب معطل")
              ],
            ),
          ),
          customWidgetofADD()
        ]);

    return MYPAGE(
        mylista: mylista,
        table: 'users',
        tableId: 'user_id',
        page: Employ,
        searchRange: const ['username', 'fullname'],
        mainColumn: mainColumn,
        items: itemskey,
        itemsResult: itemResult,
        itemsWidget: () => itemsWidget(),
        notifi: const SizedBox(),
        addlabel: addFunction['addlabel'],
        action: addFunction['action'],
        customInitdataforAdd: () => customInitforAdd(),
        customWidgetofADD: customWidgetofADD(),
        textfeildlista: employs,
        scrollController: scrollController,
        mainEditvisible: () => checkifUserisAdmin() == true ? true : false,
        subeditvisible: () => true,
        mainAddvisible: checkifUserisAdmin() == true ? true : false,
        customWidgetofEdit: customWidgetofEdit(ctx: context),
        customInitforEdit: () => customInitforEdit(e: MYPAGE.eE),
        getinfo: () => getinfo(e: MYPAGE.eE),
        actionSave: () => edituserSaveAction(ctx: context, e: MYPAGE.eE),
        actionEdit: () => mainController.showeditpanel(),
        actionDelete: () => deleteuser(ctx: context, e: MYPAGE.eE),
        customeditpanelitem: () => const SizedBox());
  }

  customInitforAdd() {
    MainController mainController = Get.find();
    mustchgpass = true;
    addping = false;
    addremind = false;
    pbx = false;
    admin = false;
    privilege.clear();
    mainController.cloasedp();
  }

  customInitforEdit({e}) {
    MainController mainController = Get.find();
    for (var i in Employ.employs) {
      i['error'] = null;
    }
    privilege.clear();
    mustchgpass = true;
    Employ.enable = e['enable'] == 1 ? true : false;
    Employ.employs[0]['controller'].text = e['username'];
    Employ.employs[1]['controller'].text = e['fullname'];
    Employ.employs[2]['hint'] = 'بدون تغيير';
    Employ.employs[3]['hint'] = 'بدون تغيير';
    Employ.employs[4]['controller'].text = e['email'] ?? '';
    Employ.employs[5]['controller'].text = e['mobile'] ?? '';
    Employ.admin = e['admin'] == 1 ? true : false;
    addping = e['addping'] == 1 ? true : false;
    addremind = e['addremind'] == 1 ? true : false;
    pbx = e['pbx'] == 1 ? true : false;
    if ((!e['privilege'].contains('_') && e['admin'] == 0) ||
        (!e['privilege'].contains('_') &&
            e['admin'] == 1 &&
            e['privilege'].length > 1)) {
      for (var i = 0; i < e['privilege'].length; i++) {
        if (e['privilege'][i] == 'مسؤول') {
          continue;
        } else {
          Employ.privilege.add({
            'privilege': e['privilege'][i],
            'office': DB.officetable[DB.officetable.indexWhere(
                    (element) => element['office_id'] == e['office'][i])]
                ['officename']
          });
        }
      }
    }
    mainController.cloasedp();
  }

  adduser() async {
    MainController mainController = Get.find();

    await mainController.addItemMainController(
        page: Employ,
        listofFeildmz: Employ.employs,
        itemnameController: Employ.username.text,
        scrollcontroller: Employ.scrollController);
  }

  getinfo({e}) {
    List priv = e['privilege'];
    List off = e['office'];
    String p = '';
    for (var i = 0; i < priv.length; i++) {
      p +=
          "\n    * ${priv[i]} ${off[i] == '=' ? '' : off[i] == '_' ? '' : DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == off[i])]['officename']}";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: e['mustchgpass'] == 1 ? true : false,
            child: const SelectableText("يجب إعادة تعيين كلمة المرور")),
        SelectableText("""
المعرف الخاص : ${e['user_id']}
اسم المستخدم : ${e['username']}
الاسم الكامل : ${e['fullname']}
البريد الالكتروني : ${e['email'] ?? ''}
الموبايل : ${e['mobile'] ?? ''}
الصلاحيات :$p"""),
        Visibility(
            visible: e['addremind'] == 1 ? true : false,
            child: const SelectableText("   -إضافة تذكير")),
        Visibility(
            visible: e['addping'] == 1 ? true : false,
            child: const SelectableText("   -إضافة بينغ")),
        Visibility(
            visible: e['addtodo'] == 1 ? true : false,
            child: const SelectableText("   -إضافة إجرائية")),
        Visibility(
            visible: e['pbx'] == 1 ? true : false,
            child: const SelectableText("   -وصول لتسجيلات المقسم")),
        SelectableText(
          "الحساب : ${e['enable'] == 1 ? "فعال" : "معطل"}",
          style:
              TextStyle(color: e['enable'] == 1 ? Colors.green : Colors.grey),
        ),
      ],
    );
  }

  edituserSaveAction({ctx, e}) async {
    MainController mainController = Get.find();

    await mainController.editItemMainController(
        page: Employ, e: MYPAGE.eE, listofFeildmz: Employ.employs);
    updateafteredit(e: e);
  }

  updateafteredit({e}) {
    e['username'] = Employ.employs[0]['controller'].text;
    e['fullname'] = Employ.employs[1]['controller'].text;
    e['email'] = Employ.employs[4]['controller'].text;
    e['mobile'] = Employ.employs[5]['controller'].text;
    e['privilege'].clear();
    e['office'].clear();
    e['admin'] = Employ.admin == true ? 1 : 0;
    e['mustchgpass'] = Employ.mustchgpass == true ? 1 : 0;
    e['addping'] = Employ.addping == true ? 1 : 0;
    e['addtodo'] = Employ.addtodo == true ? 1 : 0;
    e['addremind'] = Employ.addremind == true ? 1 : 0;
    e['pbx'] = Employ.pbx == true ? 1 : 0;
    e['enable'] = Employ.enable == true ? 1 : 0;

    for (var i in Employ.privilege) {
      e['privilege'].add(i['privilege']);
      e['office'].add(DB.officetable[DB.officetable
              .indexWhere((element) => element['officename'] == i['office'])]
          ['office_id']);
    }
    if (Employ.admin == true) {
      e['privilege'].add('مسؤول');
      e['office'].add("=");
    }
    List priv = e['privilege'];
    List off = e['office'];
    // ignore: unused_local_variable
    String p = '';
    for (var i = 0; i < priv.length; i++) {
      p +=
          "\n    * ${priv[i]} ${off[i] == '=' ? '' : off[i] == '_' ? '' : DB.officetable[DB.officetable.indexWhere((element) => element['office_id'] == off[i])]['officename']}";
    }
  }

  deleteuser({e, ctx}) async {
    MainController mainController = Get.find();
    await mainController.deleteItemMainController(ctx: ctx, e: e, page: Employ);
  }
}
