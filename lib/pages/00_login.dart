import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.width
                        : 500,
                    child: GetBuilder<MainController>(
                      init: mainController,
                      builder: (_) =>
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          'تسجيل الدخول',
                          style: ThemeMZ().theme().textTheme.labelMedium,
                        ),
                        const Divider(),
                        ...logininfo()
                            .map(
                              (e) => Visibility(
                                visible: e['visible'],
                                child: TextFieldMZ(
                                  readonly: e['readonly'],
                                  onChanged: (x) => null,
                                  obscureText: e['obscuretext'],
                                  suffixIcon: IconButton(
                                      onPressed: e['action'],
                                      icon: Icon(e['icon'])),
                                  label: e['label'],
                                  textEditingController: e['controller'],
                                ),
                              ),
                            )
                            .toList(),
                        GetBuilder<MainController>(
                            init: mainController,
                            builder: (_) => Visibility(
                                visible: errorMSglogin.isEmpty ? false : true,
                                child: Text(errorMSglogin))),
                        const Divider(),
                        GetBuilder<MainController>(
                          init: mainController,
                          builder: (_) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: loginaction(wait: loginwait)
                                .map((e) => e['label'].isEmpty
                                    ? Visibility(
                                        visible: e['visible0'],
                                        child: Visibility(
                                            visible: e['visible'],
                                            child: e['icon'] as Widget),
                                      )
                                    : Visibility(
                                        visible: e['visible0'],
                                        child: Visibility(
                                          visible: e['visible'],
                                          child: TextButton.icon(
                                            onPressed: e['action'],
                                            icon: Icon(e['icon']),
                                            label: Text(e['label']),
                                          ),
                                        ),
                                      ))
                                .toList(),
                          ),
                        ),
                      ]),
                    )),
              ),
            ),
          ),
        ),
      )),
    );
  }

  static removelogin() async {
    LogIn.errorMSglogin = '';
    username.text = '';
    password.text = '';
    newpassword.text = '';
    confirmnewpassword.text = '';
    await MainController().navbar(0);
    Home.searchvis = false;
    LogIn.obscuretext = true;
    LogIn.iconpassvis = Icons.visibility_off;
    LogIn.usernamereadonly = false;
    LogIn.oldpassvisible = true;

    await LogIn.Pref.remove('login');
  }
}
