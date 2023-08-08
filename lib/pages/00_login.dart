import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/pages/splash.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class LogIn extends StatelessWidget {
  static String appversion = 'v_1.0.1';
  static String? getversion;
  static bool constatus = false;
  const LogIn({super.key});
  static String office_ids = '';

  static List<Map> allusers = [];
  static List<String> autologin = getlogin() ?? [];
  static TextEditingController username = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController newpassword = TextEditingController();
  static TextEditingController confirmnewpassword = TextEditingController();
  static late SharedPreferences Pref;
  static String errorMSglogin = '';
  static bool obscuretext = true;
  static IconData iconpassvis = Icons.visibility_off;
  static bool loginwait = false, oldpassvisible = true;
  static bool usernamereadonly = false;
  @override
  Widget build(BuildContext context) {
    List tak = ['T', 'A', 'K', 'A', 'M', 'O', 'L'];
    DBController dbController = Get.find();
    MainController mainController = Get.find();
    List logininfo() => [
          {
            'visible': true,
            'label': 'اسم المستخدم',
            'controller': username,
            'obscuretext': false,
            'icon': Icons.person,
            'action': null,
            'readonly': usernamereadonly,
          },
          {
            'visible': oldpassvisible,
            'label': 'كلمة المرور',
            'controller': password,
            'obscuretext': obscuretext,
            'icon': iconpassvis,
            'action': () => mainController.passvis(),
            'readonly': false,
          },
          {
            'visible': !oldpassvisible,
            'label': 'كلمة المرور الجديدة',
            'controller': newpassword,
            'obscuretext': obscuretext,
            'icon': iconpassvis,
            'action': () => mainController.passvis(),
            'readonly': false,
          },
          {
            'visible': !oldpassvisible,
            'label': 'تأكيد كلمة المرور',
            'controller': confirmnewpassword,
            'obscuretext': obscuretext,
            'icon': iconpassvis,
            'action': () => mainController.passvis(),
            'readonly': false,
          }
        ];
    List loginaction({wait, action}) => [
          {
            'visible0': oldpassvisible,
            'visible': !wait,
            'label': 'دخول',
            'icon': Icons.login_rounded,
            'action': () => mainController.checklogin()
          },
          {
            'visible0': !oldpassvisible,
            'visible': !wait,
            'label': 'تأكيد',
            'icon': Icons.login_rounded,
            'action': () => mainController.mustchgpass()
          },
          {
            'visible0': true,
            'visible': wait,
            'label': '',
            'icon':
                const SizedBox(width: 100, child: LinearProgressIndicator()),
          },
        ];
    return Builder(builder: (context) {
      return GetBuilder<DBController>(
          init: dbController,
          builder: (_) {
            LogIn.errorMSglogin = '';
            return FutureBuilder(future: Future(() async {
              try {
                await Future.delayed(Duration(seconds: 2));
                await dbController.gettable(
                    list: DB.userstable,
                    usertable: DB.userstable,
                    table: 'users',
                    type: 'all');
                await mainController.getappverion();
                await mainController.getreminddate();
                await mainController.getalluserstable();
                await mainController.autosendnotifitasks();
                await mainController.autosendnotifiremind();
              } catch (e) {}
            }), builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Splash();
              } else if (LogIn.constatus == true) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: GetBuilder<MainController>(
                    init: mainController,
                    builder: (_) => Scaffold(
                        body: Center(
                      child: LogIn.getversion != LogIn.appversion
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '''
            النسخة الحالية من التطبيق لم تعد معتمدة
            قم بتحديث التطبيق
            ''',
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                    child: Icon(Icons.download),
                                    onTap: () async {
                                      await mainController.url_launch(
                                          url:
                                              'https://github.com/mz-70111/multi_tools_mng_mz153');
                                    },
                                  )
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: MediaQuery.of(context)
                                                    .size
                                                    .width <
                                                500
                                            ? MediaQuery.of(context).size.width
                                            : 500,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'lib\\assets\\images\\takamollogo.png',
                                                      height: 75,
                                                      width: 75,
                                                    ),
                                                    Row(
                                                      children: [
                                                        ...tak.map((e) =>
                                                            TweenMZ.transperant(
                                                                duration:
                                                                    tak.indexOf(
                                                                            e) *
                                                                        500,
                                                                child0:
                                                                    Text("$e")))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'تسجيل الدخول',
                                                style: ThemeMZ()
                                                    .theme()
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const Divider(),
                                              ...logininfo()
                                                  .map(
                                                    (e) => Visibility(
                                                      visible: e['visible'],
                                                      child: TextFieldMZ(
                                                        readonly: e['readonly'],
                                                        onChanged: (x) => null,
                                                        obscureText:
                                                            e['obscuretext'],
                                                        suffixIcon: IconButton(
                                                            onPressed:
                                                                loginwait ==
                                                                        false
                                                                    ? e[
                                                                        'action']
                                                                    : null,
                                                            icon: Icon(
                                                                e['icon'])),
                                                        label: e['label'],
                                                        textEditingController:
                                                            e['controller'],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              Visibility(
                                                  visible: errorMSglogin.isEmpty
                                                      ? false
                                                      : true,
                                                  child: Text(errorMSglogin)),
                                              const Divider(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: loginaction(
                                                        wait: loginwait)
                                                    .map((e) => e['label']
                                                            .isEmpty
                                                        ? Visibility(
                                                            visible:
                                                                e['visible0'],
                                                            child: Visibility(
                                                                visible: e[
                                                                    'visible'],
                                                                child: e['icon']
                                                                    as Widget),
                                                          )
                                                        : Visibility(
                                                            visible:
                                                                e['visible0'],
                                                            child: Visibility(
                                                              visible:
                                                                  e['visible'],
                                                              child: TextButton
                                                                  .icon(
                                                                onPressed:
                                                                    e['action'],
                                                                icon: Icon(
                                                                    e['icon']),
                                                                label: Text(
                                                                    e['label']),
                                                              ),
                                                            ),
                                                          ))
                                                    .toList(),
                                              ),
                                            ])),
                                  ),
                                ),
                              ),
                            ),
                    )),
                  ),
                );
              } else {
                return Scaffold(
                  body: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text("لا يمكن الوصول للمخدم"),
                    TextButton(
                        onPressed: () async {
                          dbController.update();
                        },
                        child: const Icon(Icons.refresh))
                  ])),
                );
              }
            });
          });
    });
  }

  static removelogin() async {
    LogIn.loginwait = false;
    Future(() async => await mainController.loginlogoutlog(0));
    Get.offNamed('/login');
    Home.searchvis = false;
    LogIn.obscuretext = true;
    LogIn.iconpassvis = Icons.visibility_off;
    LogIn.usernamereadonly = false;
    LogIn.oldpassvisible = true;
    MYPAGE.selectedOffice = 'جميع المكاتب';
    await LogIn.Pref.remove('login');
    LogIn.username.text = '';
    LogIn.password.text = '';
    LogIn.errorMSglogin = '';
    LogIn.newpassword.text = '';
    LogIn.confirmnewpassword.text = '';
    mainController.update();
  }
}
