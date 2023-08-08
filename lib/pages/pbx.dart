import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class PBX extends StatelessWidget {
  const PBX({super.key});
  static TextEditingController mainfolderpath = TextEditingController();
  static TextEditingController distfolderpath = TextEditingController();
  static TextEditingController searchfolderpath = TextEditingController();
  static TextEditingController typefolderpath = TextEditingController();
  static bool waitsearch = false;
  static List searchtype = ['رقم التحويلة', 'رقم المتصل'];
  static String searchvalue = 'رقم التحويلة';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : MediaQuery.of(context).size.width,
                    child: ExpansionTile(
                      title: Text("بحث في التسجيلات"),
                      children: [
                        Row(
                          children: [
                            Text("بحث بحسب"),
                            GetBuilder<MainController>(
                              init: mainController,
                              builder: (_) => DropdownButton(
                                  value: searchvalue,
                                  items: searchtype
                                      .map((e) => DropdownMenuItem(
                                          value: "$e", child: Text("$e")))
                                      .toList(),
                                  onChanged: (x) {
                                    mainController.choosesearchvalue(x);
                                  }),
                            ),
                            Expanded(
                                child: TextFieldMZ(
                                    textEditingController: typefolderpath,
                                    label: '',
                                    onChanged: (x) => null))
                          ],
                        ),
                        TextFieldMZ(
                            textdirection: TextDirection.ltr,
                            textEditingController: searchfolderpath,
                            label: 'مجلد البحث',
                            onChanged: (x) => null,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  getpath2();
                                },
                                icon: Icon(Icons.folder))),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  searchcmd(
                                      username: 'muoaz.horani',
                                      password: 'mh77@0111');
                                },
                                icon: Icon(Icons.search)),
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width > 500
                    ? 500
                    : MediaQuery.of(context).size.width,
                child: Divider(
                  thickness: 10,
                  height: 10,
                ),
              ),
              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 500
                      ? 500
                      : MediaQuery.of(context).size.width,
                  child: ExpansionTile(
                    title: Text("فرز التسجيلات"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFieldMZ(
                          textdirection: TextDirection.ltr,
                          textEditingController: mainfolderpath,
                          label: 'المجلد الأساسي',
                          onChanged: (x) => null,
                          suffixIcon: IconButton(
                              onPressed: () async {
                                await getpath0();
                              },
                              icon: Icon(Icons.folder_open)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFieldMZ(
                          textdirection: TextDirection.ltr,
                          textEditingController: distfolderpath,
                          label: 'الوجهة',
                          onChanged: (x) => null,
                          suffixIcon: IconButton(
                              onPressed: () async {
                                await getpath1();
                              },
                              icon: Icon(Icons.folder_open)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getpath0() async {
    if (Platform.isWindows) {
      final String? directoryPath = await getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        mainfolderpath.text = directoryPath;
      }
    } else {
      final String? directoryPath =
          await FilePicker.platform.getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        mainfolderpath.text = directoryPath;
      }
    }
  }

  getpath1() async {
    if (Platform.isWindows) {
      final String? directoryPath = await getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        distfolderpath.text = directoryPath;
      }
    } else {
      final String? directoryPath =
          await FilePicker.platform.getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        distfolderpath.text = directoryPath;
      }
    }
  }

  getpath2() async {
    if (Platform.isWindows) {
      final String? directoryPath = await getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        searchfolderpath.text = directoryPath;
      }
    } else {
      final String? directoryPath =
          await FilePicker.platform.getDirectoryPath();
      if (directoryPath == null) {
        return;
      } else {
        searchfolderpath.text = directoryPath;
      }
    }
  }

  searchcmd({username, password}) async {
    var connent = await Process.run('Powershell.exe', [
      '''
net use /delete \\\\192.168.30.15
net use \\\\192.168.30.15 /user:$username@social.takamol.local $password
'''
    ]);
    if (connent.stdout.contains('successfully')) {
      print(connent.stdout);
      searchfolderpath.text.replaceAll('\\', "\\\\");
      print(searchfolderpath.text);
      var result = await Process.run('Powershell.exe', [
        '''
Get-ChildItem -Path \\\\192.168.30.15\\pbx_record\\PBX_REC\\autorecords\\*-475-* -Recurse |select Name'''
      ]);
      print(result.stdout);
    } else {
      print('error');
    }
  }
}
