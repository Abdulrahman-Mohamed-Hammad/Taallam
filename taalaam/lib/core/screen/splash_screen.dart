import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      if (FirebaseHelper.checkUser() == null) {
        go(context, KRoutes.controllAuth);
        return;
      }
      go(context, KRoutes.courses);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  Kicons.background,
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),

                Lottie.asset(
                  Kicons.ring,
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain,
                ),
                Column(
                  children: [
                    Text(
                      LocaleKeys.app_name.tr(),
                      style: KFonts.black50.copyWith(
                        fontSize: context.locale.languageCode == "en" ? 38 : 50,
                        fontFamily: context.locale.languageCode == "en"
                            ? "Inter"
                            : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      LocaleKeys.sub_app_name.tr(),
                      style: KFonts.regular16lightPrimary.copyWith(
                        fontSize: context.locale.languageCode == "en"
                            ? 14
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
