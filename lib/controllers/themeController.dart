import 'dart:math';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';

ThemeController themeController = Get.find();

class ThemeController extends GetxController {
  @override
  void onInit() async {
    LogIn.Pref = await setPref();
    ThemeMZ.mode = await getmode() ?? 'light';
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    update();
  }

  double iconmodeEndrotate = 360 * pi / 180;
  changemode() async {
    iconmodeEndrotate =
        iconmodeEndrotate == 360 * pi / 180 ? 0 : 360 * pi / 180;
    ThemeMZ.mode = ThemeMZ.mode == 'light' ? 'dark' : 'light';
    MainController().cloasedp();
    await removemode();
    await setmode(mode: ThemeMZ.mode);
    update();
  }

  setPref() async {
    return await SharedPreferences.getInstance();
  }

  setmode({required String mode}) async {
    await LogIn.Pref.setString("modm", mode);
  }

  removemode() async {
    await LogIn.Pref.remove('modm');
  }

  getmode() {
    try {
      return LogIn.Pref.getString("modm");
    } catch (e) {}
  }

  PersonPanelclose() {
    PersonPanel.dropend = -500;
    update();
  }
}
