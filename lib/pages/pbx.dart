import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class PBX extends StatelessWidget {
  const PBX({super.key});
  static bool selectallsearchpbx = false;
  static TextEditingController mainfolderpath = TextEditingController();
  static TextEditingController distfolderpath = TextEditingController();
  static TextEditingController searchfolderpath = TextEditingController();
  static TextEditingController typefolderpath = TextEditingController();
  static String? savedfilepath;
  static bool waitsearch = false;
  static List searchtype = ['رقم التحويلة', 'رقم المتصل'];
  static String searchvalue = 'رقم التحويلة';
  static String? errormsg;
  static List? searchresult;
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const Center(child: Text("هذه المنصة مخصصة لإصدار windows فقط"));
    } else {
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
                              Text("أدخل كلمة مفتاحية للبحث "),
                              Expanded(
                                  child: TextFieldMZ(
                                      textdirection: TextDirection.ltr,
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
                          GetBuilder<MainController>(
                            init: mainController,
                            builder: (_) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Visibility(
                                          visible:
                                              errormsg == null ? false : true,
                                          child: Expanded(
                                              child: Text("$errormsg"))),
                                      Visibility(
                                          visible: waitsearch,
                                          child: SizedBox(
                                            width: 100,
                                            child: LinearProgressIndicator(),
                                          )),
                                      Visibility(
                                        visible: !waitsearch,
                                        child: IconButton(
                                            onPressed: () {
                                              mainController.searchcmd();
                                            },
                                            icon: Icon(Icons.search)),
                                      ),
                                    ],
                                  ),
                                  searchresult != null
                                      ? searchresult!.isEmpty
                                          ? Text("لم يتم العثور على أي نتائج")
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                        value:
                                                            selectallsearchpbx,
                                                        onChanged: (x) {
                                                          mainController
                                                              .checkboxpbxsearchall(
                                                                  x);
                                                        }),
                                                    Visibility(
                                                      visible:
                                                          selectallsearchpbx ==
                                                                  true
                                                              ? true
                                                              : false,
                                                      child: IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                              Icons.download)),
                                                    ),
                                                    Text("تحديد الكل"),
                                                  ],
                                                ),
                                                ...searchresult!.map((e) => Row(
                                                      children: [
                                                        Checkbox(
                                                            value: e['check'],
                                                            onChanged: (x) {
                                                              mainController
                                                                  .checkboxpbxsearch(
                                                                      x: x,
                                                                      index: searchresult!
                                                                          .indexOf(
                                                                              e));
                                                            }),
                                                        Visibility(
                                                          visible:
                                                              selectallsearchpbx ==
                                                                      true
                                                                  ? false
                                                                  : e['check'] ==
                                                                          true
                                                                      ? true
                                                                      : false,
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await savefile();
                                                              },
                                                              icon: Icon(Icons
                                                                  .download)),
                                                        ),
                                                        Text("${e['path']}"),
                                                      ],
                                                    ))
                                              ],
                                            )
                                      : SizedBox()
                                ],
                              ),
                            ),
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
  }

  getpath0() async {
    if (Platform.isWindows) {
      final String? directoryPath = await getDirectoryPath();
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

  savefile() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) {
      return;
    } else {
      savedfilepath = directoryPath;
    }
    if (savedfilepath != null) {
      await Process.run('Powershell.exe', [
        '''
net use \\\\192.168.30.15 /user:muoaz.horani@social.takamol.local mh77@0111
'''
      ]);
      for (var i in searchresult!) {
        if (i['check'] == true) {
          await Process.run('Powershell.exe', [
            '''
Copy-Item "${searchfolderpath.text}\\${i['path']}" -Destination "$savedfilepath"
'''
          ]);
        }
      }
    }
  }
}
