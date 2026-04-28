import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';

import 'package:student_app/core/Hive/hive_helper.dart';
import 'package:student_app/core/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late double width;
late double height;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseHelper.googleSignIn.initialize();
  await FirebaseFirestore.instance.clearPersistence();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  await HiveHelper.initilizeHive();
  await HiveHelper.openAllboxs();

  HiveHelper.initilizeDefualtCasheManger();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => EasyLocalization(
        supportedLocales: [Locale('ar'), Locale('en')],
         fallbackLocale: context.locale,
        saveLocale: true,
        path: "assets/translation",
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade50,
        fontFamily: context.locale.languageCode == 'ar' ? 'Cairo' : 'Inter',
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: border(KColors.bordorColor, width: 1),
          enabledBorder: border(KColors.bordorColor, width: 1),
          filled: true,
          fillColor: KColors.white,
          focusedBorder: border(KColors.primary, width: 1),
          errorBorder: border(KColors.borderError),
          focusedErrorBorder: border(KColors.borderError, width: 1),
          disabledBorder: border(KColors.bordorColor),

          errorStyle: KFonts.bold13DarkGray.copyWith(
            color: KColors.error,
            fontSize: 10,
          ),
        ),
      ),
      locale: context.locale,

      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            (MediaQuery.of(context).size.width / 390).clamp(0.8, 1.3),
          ),
          boldText: false,
        ),
        child: child!,
        //Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
      routerConfig: KRoutes.routes,
    );
  }
}
