// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:users_tasks_mz_153/controllers/databaseController.dart';
// import 'package:users_tasks_mz_153/controllers/mainController.dart';
// import 'package:users_tasks_mz_153/controllers/themeController.dart';
// import 'package:users_tasks_mz_153/db/database.dart';
// import 'package:users_tasks_mz_153/pages/02_home.dart';
// import 'package:users_tasks_mz_153/tamplate/appbar.dart';
// import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
// import 'package:intl/intl.dart' as df;
// import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

// MainController mainController = Get.find();

// // ignore: must_be_immutable
// class SchedueldTasks extends StatelessWidget {
//   SchedueldTasks({super.key});
//   ThemeController themeController = Get.find();
//   DBController dbController = Get.find();
//   static List erroreitc = [null, null, false];
//   static TextEditingController todoname = TextEditingController();
//   static TextEditingController tododetails = TextEditingController();
//   static List<Map> maso = [];
//   static bool addvis = false;
//   static bool addwaitvis = false, addoredit = true;
//   static double addvis_end = 0.0;
//   static double addvis_begin = -200.0;
//   static double addvis_beginx = 200.0;
//   static IconData addicon = Icons.add;
//   static double addicon_begin_r = 0.0 * pi / 180;
//   static double addicon_end_r = 0.0 * pi / 180;
//   static List? customUserstable;
//   static ScrollController mzcontroller = ScrollController();
//   static List<Map> mylista = [];
//   static String errormsg = '';
//   static late int todoid;
//   static int closebs = 0;
//   static bool createbyvis = false;
//   static String officelistvalue = 'مخصص';
//   static List temp = [];
//   static List<Map> todos = [
//     {
//       'label': 'اسم الإجرائية',
//       'controller': todoname,
//       'error': null,
//       'icon': Icons.whatshot,
//       'obscuretext': false,
//       'hint': '',
//       'td': TextDirection.rtl
//     },
//     {
//       'label': 'تفاصيل',
//       'controller': tododetails,
//       'error': null,
//       'icon': Icons.details,
//       'obscuretext': false,
//       'hint': '',
//       'td': TextDirection.rtl,
//       'maxlines': 3
//     },
//   ];
//   static List easyeditodo({index, ctx}) => [
//         {
//           'icon': Icons.delete,
//           'action': () async {
//             Get.back();
//           },
//           'color': Colors.redAccent
//         },
//         {
//           'icon': Icons.edit,
//           'action': () async {
//             Get.back();
//           },
//           'color': Colors.indigoAccent
//         }
//       ];
//   static List easyeditodocomment({ctx, commentid, commentcontroller}) => [
//         {
//           'icon': Icons.delete,
//           'action': () async {
//             await mainController.deletecommenttodo(
//                 ctx: ctx, commintid: commentid);
//           },
//           'color': Colors.grey
//         },
//         {
//           'icon': Icons.edit,
//           'action': () async {
//             await mainController.editcommenttodo(
//                 controller: commentcontroller, ctx: ctx, id: commentid);
//           },
//           'color': Colors.grey
//         }
//       ];
//   static bool emplyvis = false;
//   static bool commentvisible = false;

//   List dbtodotableAction = [
//     {
//       'label': 'اسم الإجرائية',
//       'action': () {
//         mainController.sort(table: mylista, sortby: 'todoname');
//       }
//     },
//   ];
//   static bool selectall = false;
//   static bool deletewait = false;
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: GetBuilder<DBController>(
//         init: dbController,
//         builder: (_) => Scaffold(
//           body: Stack(
//             children: [
//               FutureBuilder(future: Future(() async {
//                 try {
//                   return await dbController.gettable(
//                     list: mylista,
//                     tableid: 'todo_id',
//                     table: 'todo',
//                   );
//                 } catch (e) {}
//               }), builder: (_, snap) {
//                 if (snap.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (!snap.hasData) {
//                   return Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text("لا يمكن الوصول للمخدم"),
//                         TextButton(
//                             onPressed: () {
//                               dbController.update();
//                             },
//                             child: const Icon(Icons.refresh))
//                       ],
//                     ),
//                   );
//                 } else {
//                   return GetBuilder<MainController>(
//                     init: mainController,
//                     builder: (_) => GetBuilder<DBController>(
//                       init: dbController,
//                       builder: (_) {
//                         if (DB.todotable.isEmpty) {
//                           return const Center(
//                             child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                       "لا يوجد اي مهمة مجدولة للتذكير مضافة الى الآن")
//                                 ]),
//                           );
//                         } else {
//                           List chechallvaluetrue = [];
//                           List officelist = ['جميع النتائج', 'مخصص'];
//                           for (var i in DB.officetable) {
//                             officelist.add(i['officename']);
//                           }
//                           chechallvaluetrue.clear();
//                           temp.clear();
//                           for (var j in Home.searchlist) {
//                             if (j['check'] == true) {
//                               chechallvaluetrue.add('1');
//                               if (j.keys.toList().first == 'office_id') {
//                                 temp.add(j['officename']);
//                               }
//                             }
//                           }
//                           if (chechallvaluetrue.length ==
//                               Home.searchlist.length) {
//                             officelistvalue = 'جميع النتائج';
//                           } else if (temp.length == 1) {
//                             officelistvalue = temp[0];
//                           } else {
//                             officelistvalue = 'مخصص';
//                           }
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Visibility(
//                                       visible: DB.officetable.isNotEmpty
//                                           ? true
//                                           : false,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Card(
//                                           child: DropdownButton(
//                                               value: officelistvalue,
//                                               items: officelist
//                                                   .map((e) => DropdownMenuItem(
//                                                       value: e,
//                                                       child: Text("$e")))
//                                                   .toList(),
//                                               onChanged: (x) {
//                                                 mainController.chooseoffice(x);
//                                                 dbController.update();
//                                               }),
//                                         ),
//                                       )),
//                                   Expanded(
//                                     child: Textfieldmz(
//                                         label: "بحث",
//                                         onchanged: (word) {
//                                           mainController.search(
//                                               word: word,
//                                               list: mylista,
//                                               range: [
//                                                 'todo_id',
//                                                 'todoname',
//                                                 'tododetails',
//                                                 'tododate',
//                                                 'createby',
//                                                 'comment'
//                                               ]);
//                                         }),
//                                   ),
//                                 ],
//                               ),
//                               Row(children: [
//                                 ...dbtodotableAction
//                                     .map((e) => Expanded(
//                                           child: Row(
//                                             children: [
//                                               IconButton(
//                                                   onPressed: e['action'],
//                                                   icon: const Icon(Icons.sort)),
//                                               Text(
//                                                 e['label'],
//                                               ),
//                                             ],
//                                           ),
//                                         ))
//                                     .toList(),
//                               ]),
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   child: GetBuilder<MainController>(
//                                     init: mainController,
//                                     builder: (_) => Column(
//                                       children: mylista.map((e) {
//                                         return Visibility(
//                                           visible: e['visible'],
//                                           child: Card(
//                                             child: ExpansionTile(
//                                               title: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Text(
//                                                       "# ${e['todo_id']} _ ${e['todoname']}",
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               children: [
//                                                 todo_get(
//                                                   createdate:
//                                                       e['todocreatedate'],
//                                                   editdate: e['todoeditdate'],
//                                                   editby: e['editby'],
//                                                   details: e['tododetails'],
//                                                   createby: e['createby'],
//                                                   createby_id: e['createby_id'],
//                                                   todoid: e['todo_id'],
//                                                   editvisible:
//                                                       e['todoeditdate'] == null
//                                                           ? false
//                                                           : true,
//                                                   index: mylista.indexOf(e),
//                                                   createbyvis: (e['createby'] ==
//                                                               Home.logininfo ||
//                                                           DB.userstable[DB
//                                                                   .userstable
//                                                                   .indexWhere((element) =>
//                                                                       element[
//                                                                           'username'] ==
//                                                                       Home.logininfo)]['admin'] ==
//                                                               1)
//                                                       ? true
//                                                       : false,
//                                                   ctx: context,
//                                                   ratevis: e['createby'] ==
//                                                           Home.logininfo
//                                                       ? true
//                                                       : false,
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 }
//               }),
//               GetBuilder<MainController>(
//                   init: mainController,
//                   builder: (_) => GetBuilder<ThemeController>(
//                         init: themeController,
//                         builder: (_) => Stack(children: [
//                           Visibility(
//                             visible: addvis,
//                             child: Container(
//                               width: double.infinity,
//                               height: double.infinity,
//                               color: Colors.black.withOpacity(0.8),
//                             ),
//                           ),
//                           addedit(
//                             addvis: addvis,
//                             addvis_beginx: addvis_beginx,
//                             addvis_end: addvis_end,
//                             mzcontroller: mzcontroller,
//                             todods: todos,
//                             errormsg: errormsg,
//                             addvis_begin: addvis_begin,
//                             addwaitvis: addwaitvis,
//                             addicon_end_r: addicon_end_r,
//                             addicon: addicon,
//                             addoredit: addoredit,
//                           ),
//                         ]),
//                       )),
//               Positioned(left: 0, child: Notificationm()),
//               GetBuilder<MainController>(
//                   init: mainController,
//                   builder: (_) => Positioned(left: 0, child: PersonPanel())),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class addedit extends StatelessWidget {
//   const addedit(
//       {super.key,
//       required this.addvis,
//       required this.addvis_beginx,
//       required this.addvis_end,
//       required this.mzcontroller,
//       required this.todods,
//       required this.errormsg,
//       required this.addvis_begin,
//       required this.addwaitvis,
//       required this.addicon_end_r,
//       required this.addicon,
//       required this.addoredit});

//   final bool addvis;
//   final double addvis_beginx;
//   final double addvis_end;
//   final ScrollController mzcontroller;
//   final List<Map> todods;
//   final String errormsg;
//   final double addvis_begin;
//   final bool addwaitvis, addoredit;
//   final double addicon_end_r;
//   final IconData addicon;

//   @override
//   Widget build(BuildContext context) {
//     MainController mainController = Get.find();
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Expanded(
//           child: Visibility(
//             visible: addvis,
//             child: TweenMZ.translatey(
//               begin: addvis_beginx,
//               end: addvis_end,
//               duration: 200,
//               child0: AlertDialog(
//                 content: SingleChildScrollView(
//                   child: Column(children: [
//                     ...todods
//                         .map((e) => Textfieldmz(
//                             label: e['label'],
//                             controller: e['controller'],
//                             error: e['error'],
//                             obscuretext: e['obscuretext'],
//                             hint: e['hint'],
//                             td: e['td'],
//                             maxlines: e['maxlines'],
//                             suffixicon: IconButton(
//                                 onPressed: e['action'], icon: Icon(e['icon']))))
//                         .toList(),
//                     Text(
//                       SchedueldTasks.errormsg,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.redAccent),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Visibility(
//                 visible: addvis,
//                 child: TweenMZ.translatex(
//                   duration: 300,
//                   begin: addvis_begin,
//                   end: addvis_end,
//                   child0: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Visibility(
//                             visible: !addwaitvis,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Visibility(
//                                   visible: addoredit,
//                                   child: TextButton.icon(
//                                       onPressed: () async {},
//                                       icon: const Icon(Icons.add),
//                                       label: const Text(
//                                         "إضافة إجرائية جديدة",
//                                       )),
//                                 ),
//                                 Visibility(
//                                   visible: !addoredit,
//                                   child: TextButton.icon(
//                                       onPressed: () async {},
//                                       icon: const Icon(Icons.add),
//                                       label: const Text(
//                                         "حفظ التعديلات",
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Visibility(
//                               visible: addwaitvis,
//                               child: const CircularProgressIndicator())
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             TweenMZ.rotate(
//               begin: 0.0 * pi / 180,
//               end: addicon_end_r,
//               duration: 200,
//               child0: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: const CircleBorder(eccentricity: 0.5),
//                   ),
//                   child: TweenMZ.rotate(
//                       begin: 0.0 * pi / 180,
//                       end: addicon_end_r == 45.0 * pi / 180
//                           ? -45.0 * pi / 180
//                           : 0.0 * pi / 180,
//                       duration: 400,
//                       child0: Icon(addicon)),
//                   onPressed: () {},
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class todo_get extends StatelessWidget {
//   todo_get({
//     super.key,
//     this.ctx,
//     this.createbyvis,
//     this.index,
//     this.createby_id,
//     this.createby,
//     this.details,
//     this.todoid,
//     this.createdate,
//     this.editdate,
//     this.editby,
//     this.editvisible,
//     this.ratevis,
//   });
//   static Map resortcomment = {};
//   static List ty = [];
//   var ctx,
//       createbyvis,
//       index,
//       createby_id,
//       todoid,
//       createby,
//       details,
//       createdate,
//       editdate,
//       editby,
//       editvisible,
//       ratevis;
//   @override
//   Widget build(BuildContext context) {
//     MainController mainController = Get.find();
//     List maso = [],
//         maso2 = [],
//         usersId = [],
//         usersC = [],
//         comment = [],
//         commentid = [],
//         commentdate = [];
//     try {
//       for (var i in SchedueldTasks.mylista[index]['commentdate']) {
//         maso.add(
//             "$i=m=${SchedueldTasks.mylista[index]['users_id_comment'][SchedueldTasks.mylista[index]['commentdate'].indexOf(i)]}=m=${SchedueldTasks.mylista[index]['users_c'][SchedueldTasks.mylista[index]['commentdate'].indexOf(i)]}=m=${SchedueldTasks.mylista[index]['comment'][SchedueldTasks.mylista[index]['commentdate'].indexOf(i)]}=m=${SchedueldTasks.mylista[index]['comment_id'][SchedueldTasks.mylista[index]['commentdate'].indexOf(i)]}");
//       }
//     } catch (e) {}
//     maso.sort(
//       (a, b) => a.toString().compareTo(b.toString()),
//     );
//     for (var i in maso) {
//       maso2.add(i.split('=m='));
//     }
//     usersId.clear();
//     usersC.clear();
//     comment.clear();
//     commentid.clear();
//     commentdate.clear();
//     for (var i in maso2) {
//       usersId.add(i[1]);
//       usersC.add(i[2]);
//       comment.add(i[3]);
//       commentdate.add(i[0]);
//       commentid.add(i[4]);
//     }
//     resortcomment.addAll({
//       'users_id_comment': usersId,
//       'users_c': usersC,
//       'comment': comment,
//       'commentdate': commentdate,
//       'comment_id': commentid
//     });
//     double rateavg = 0;
//     if (SchedueldTasks.mylista[index]['rate'].isNotEmpty) {
//       for (var i in SchedueldTasks.mylista[index]['rate']) {
//         rateavg += i;
//       }
//     }

//     if (SchedueldTasks.mylista[index]['rate'].isNotEmpty) {
//       rateavg = rateavg / SchedueldTasks.mylista[index]['rate'].length;
//     } else {
//       rateavg = 0.0;
//     }
//     try {
//       for (var i in SchedueldTasks.mylista[index]['rate_widget']) {
//         if (SchedueldTasks.mylista[index]['rate'][SchedueldTasks.mylista[index]
//                     ['users_r']
//                 .indexWhere((e) => e == Home.logininfo)] ==
//             SchedueldTasks.mylista[index]['rate_widget'].indexOf(i)) {
//           break;
//         }
//         i['icon'] = Icons.star;
//       }
//     } catch (e) {}
//     return GetBuilder<MainController>(
//         init: mainController,
//         builder: (_) => AlertDialog(
//               scrollable: true,
//               content: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(border: Border.all()),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Visibility(
//                               visible: createbyvis,
//                               child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: SchedueldTasks.easyeditodo(
//                                           ctx: ctx, index: index)
//                                       .map((e) {
//                                     SchedueldTasks.todoid = todoid;

//                                     return IconButton(
//                                         onPressed: e['action'],
//                                         icon: Icon(
//                                           e['icon'],
//                                           color: e['color'],
//                                         ));
//                                   }).toList()),
//                             ),
//                             Visibility(
//                                 visible: !ratevis,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: 1,
//                                       height: 25,
//                                       color: Colors.black,
//                                     ),
//                                     Row(
//                                       children: [
//                                         const Text(" تقييم "),
//                                         ...SchedueldTasks.mylista[index]
//                                                 ['rate_widget']
//                                             .map((r) => IconButton(
//                                                 onPressed: () {
//                                                   mainController.rate(
//                                                     index,
//                                                     SchedueldTasks
//                                                         .mylista[index]
//                                                             ['rate_widget']
//                                                         .indexOf(r),
//                                                     DB.userstable[DB.userstable
//                                                             .indexWhere((element) =>
//                                                                 element[
//                                                                     'username'] ==
//                                                                 Home.logininfo)]
//                                                         ['user_id'],
//                                                     todoid,
//                                                   );
//                                                 },
//                                                 icon: Icon(r['icon'])))
//                                       ],
//                                     ),
//                                   ],
//                                 )),
//                             const Divider(),
//                             Row(
//                               children: [
//                                 Expanded(child: Text(details.toString())),
//                               ],
//                             ),
//                             const Divider(),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                       'تم إنشاءها بتاريخ ${df.DateFormat("yyyy-MM-dd | HH:mm").format(createdate)} بواسطة ${createby != null ? DB.userstable[DB.userstable.indexWhere((element) => element['username'] == createby)]['fullname'] : "حساب محذوف"}'),
//                                 ),
//                               ],
//                             ),
//                             Visibility(
//                               visible: editvisible,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   editby != null
//                                       ? Expanded(
//                                           child: Text(
//                                               'تم التعديل بتاريخ ${df.DateFormat("yyyy-MM-dd | HH:mm").format(editdate ?? DateTime.now())} بواسطة ${editby != null ? DB.userstable[DB.userstable.indexWhere((element) => element['username'] == editby)]['fullname'] : "حساب محذوف"}'),
//                                         )
//                                       : const SizedBox(),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "معدل التقييم : $rateavg",
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                     "عدد التقييمات: ${SchedueldTasks.mylista[index]['rate'].length}")
//                               ],
//                             ),
//                             const Divider(),
//                             Visibility(
//                               visible: SchedueldTasks
//                                       .mylista[index]['comment'].isEmpty
//                                   ? false
//                                   : true,
//                               child: ExpansionTile(
//                                   title: const Text("التعليقات"),
//                                   children: [
//                                     ...resortcomment['commentdate'].map((e) {
//                                       print(resortcomment);
//                                       return Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               border: Border.all()),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Visibility(
//                                                       visible: Home.logininfo ==
//                                                               resortcomment[
//                                                                       'users_c']
//                                                                   [
//                                                                   resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)]
//                                                           ? true
//                                                           : false,
//                                                       child: Row(
//                                                           children: SchedueldTasks.easyeditodocomment(
//                                                                   commentcontroller: resortcomment[
//                                                                       'comment'][resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)],
//                                                                   ctx: ctx,
//                                                                   commentid: resortcomment[
//                                                                       'comment_id'][resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)])
//                                                               .map((e) {
//                                                         SchedueldTasks.todoid =
//                                                             todoid;
//                                                         return IconButton(
//                                                             onPressed:
//                                                                 e['action'],
//                                                             icon: Icon(
//                                                               e['icon'],
//                                                               color: e['color'],
//                                                               size: 15,
//                                                             ));
//                                                       }).toList()),
//                                                     ),
//                                                     Text(
//                                                       resortcomment['users_c'][
//                                                                   resortcomment[
//                                                                           'commentdate']
//                                                                       .indexOf(
//                                                                           e)] !=
//                                                               "null"
//                                                           ? "${DB.userstable[DB.userstable.indexWhere((element) => element['username'] == resortcomment['users_c'][resortcomment['commentdate'].indexOf(e)])]['fullname']}"
//                                                           : "حساب محذوف",
//                                                       softWrap: true,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                   "${resortcomment['comment'][resortcomment['commentdate'].indexOf(e)]}",
//                                                   softWrap: true,
//                                                 ),
//                                                 Text(
//                                                   " ${df.DateFormat("yyyy-MM-dd | HH:mm").format(DateTime.parse(e))}",
//                                                   softWrap: true,
//                                                 ),
//                                                 const Divider(),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     })
//                                   ]),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Textfieldmz(
//                             maxlines: 2,
//                             error: SchedueldTasks.mylista[index]['error'],
//                             label: "اكتب تعليق",
//                             controller: SchedueldTasks.mylista[index]
//                                 ['commentcontroller'],
//                             suffixicon: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Visibility(
//                                     visible: !SchedueldTasks.mylista[index]
//                                         ['waitsend'],
//                                     child: const CircularProgressIndicator()),
//                                 Visibility(
//                                     visible: SchedueldTasks.mylista[index]
//                                         ['waitsend'],
//                                     child: IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(Icons.send))),
//                               ],
//                             )),
//                       ),
//                       const SizedBox(
//                         width: 50,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ));
//   }
// }
