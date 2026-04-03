
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mxcome/com/mxcome/app/IConstant.dart';
import 'package:mxcome/com/mxcome/app/config/LanguageConfig.dart';
import 'package:mxcome/com/mxcome/app/ui/IndexPage.dart';
import 'package:mxcome/com/mxcome/app/ui/LanguagePage.dart';

import 'com/mxcome/app/ui/shop/event/LanguageEvent.dart';
import 'com/mxcome/app/ui/shop/utils/EventBusUtil.dart';
import 'com/mxcome/app/utils/AppUtils.dart';
import 'com/mxcome/app/widget/CustomAnimation.dart';
import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initFirebase();
  initLanguage();
  configLoading();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,//这里替换你选择的颜色
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = true
    ..customAnimation = CustomAnimation();
}

initFirebase() async {
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);
  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }
}

initLanguage() async {
  LanguagePage.language = await AppUtils.getLanguage();
}

// bool isFlutterLocalNotificationsInitialized = false;
//
// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

class MyApp extends StatelessWidget {
  var theme = ThemeData(
      fontFamily: 'Roboto',
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      dividerTheme: const DividerThemeData(color: IConstant.line_color),
      textSelectionTheme: const TextSelectionThemeData(selectionColor: Colors.black26, cursorColor: Colors.black26, selectionHandleColor: Colors.black26),
      colorScheme: const ColorScheme.light(
          primary: IConstant.white_color,
          onPrimary: IConstant.title_color,
          secondary: IConstant.main_color,
          onSecondary: IConstant.white_color));

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 667),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (ctx, child) => MaterialApp(
          title: LanguageConfig.get(LanguageConfigKeys.app_name),
          localeResolutionCallback: (locale, supportedLocales) {
            String code = (locale?.languageCode ?? "TH").toUpperCase().substring(0, 2);
            switch (code) {
              case "ZH":
                LanguagePage.language = LanguageType.ZH;
                EventBusUtil.getInstance().emit(LanguageEvent());
                break;
              case "TH":
                LanguagePage.language = LanguageType.TH;
                EventBusUtil.getInstance().emit(LanguageEvent());
                break;
              default:
                LanguagePage.language = LanguageType.EN;
                EventBusUtil.getInstance().emit(LanguageEvent());
                break;
            }
          },
          theme: theme,
          darkTheme: theme,
          home: IndexPage(),
          builder: EasyLoading.init(),
        ));
  }
}
