import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:intl/intl.dart' as df;

class Logs extends StatelessWidget {
  const Logs({super.key});
  static List<Map> mylista = [];
  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find();
    List<Map> logss = [];
    List itemskey = ['log_id', 'content', 'logdate'];
    List itemResult = [];
    List colors = [];
    List mainColumn = [
      {
        'label': 'السجل',
        'visible': true,
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'logcontent');
        }
      },
      {
        'label': 'تاريخ السجل',
        'visible': true,
        'icon': Icons.sort,
        'action': () {
          mainController.sort(table: mylista, sortby: 'logdate');
        }
      },
    ];

    Widget itemsWidget() {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Text("# ${itemResult[0]}_ ${itemResult[1]}")),
              Expanded(
                  child: Text(
                      "# ${df.DateFormat('yyyy-MM-dd').format(itemResult[2])}")),
            ],
          ),
        ),
        Divider(),
      ]);
    }

    return MYPAGE(
        mylista: mylista,
        table: 'logs',
        tableId: 'log_id',
        page: Logs,
        searchRange: ['content'],
        mainColumn: mainColumn,
        notifi: const SizedBox(),
        textfeildlista: logss,
        customWidgetofADD: const SizedBox(),
        customInitdataforAdd: () {},
        customInitforEdit: () {},
        scrollController: ScrollController(),
        mainEditvisible: () => true,
        mainAddvisible: true,
        customWidgetofEdit: const SizedBox(),
        action: () {},
        addlabel: '',
        getinfo: () {},
        actionSave: () {},
        actionEdit: () {},
        actionDelete: () {},
        items: itemskey,
        itemsResult: itemResult,
        itemsWidget: () => itemsWidget(),
        subeditvisible: () => true,
        customeditpanelitem: () => const SizedBox());
  }
}
