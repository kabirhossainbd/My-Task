import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:my_task/controller/localization_controller.dart';
import 'package:my_task/controller/theme_controller.dart';
import 'package:my_task/services/local_string.dart';
import 'package:my_task/src/config/routes/route_helper.dart';
import 'package:my_task/src/config/themes/dark_theme.dart';
import 'package:my_task/src/config/themes/light_theme.dart';
import 'package:my_task/src/config/themes/m_theme_util.dart';
import 'package:my_task/src/utils/constants/m_strings.dart';
import 'src/locator.dart' as di;

late Size mq;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeUtil.allScreenTheme();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDUBL8_VbBkxJmkrL_LU-yoRlYTD2KVXS8',
        appId: '1:812816795263:android:cf4d37ef9fc71a2cbce14a',
        messagingSenderId: '812816795263',
        projectId: 'socail-work',
      storageBucket: "socail-work.appspot.com",
    )
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
  await di.init();
  Map<String, Map<String, String>> localString = await di.init();
  runApp( MyApp(localString: localString,));
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final Map<String, Map<String, String>> localString;
  const MyApp({Key? key, required this.localString}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetBuilder<ThemeController>(builder: (theme) {
      return GetBuilder<LocalizationController>(builder: (local) {
        return GetMaterialApp(
          locale: local.locale,
         // locale: Get.deviceLocale,
          translations: LocaleString(localString: widget.localString),
          fallbackLocale: const Locale('en', 'US'),
          title: MyStrings.appName,
          initialRoute: MyRouteHelper.splashScreen,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 500),
          getPages: MyRouteHelper.routes,
          navigatorKey: Get.key,
          theme: theme.darkTheme ? dark : light,
          debugShowCheckedModeBanner: false,
        );
      });
    });
  }


}