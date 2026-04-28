import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:gap/gap.dart';
import 'dart:async'; // <--- This is the one you need
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Auth/data/cubit/cubit_auth.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class VerficationScreen extends StatefulWidget {
  const VerficationScreen({super.key, required this.cubit});
  final AuthCubit cubit;

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    // 1. Start the "Listener" as soon as the screen opens
    _startVerificationListener();
  }

  void _startVerificationListener() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseHelper.fireauth.currentUser?.reload();

      // 3. Check the status
      final user = FirebaseHelper.fireauth.currentUser;
      if (user != null && user.emailVerified) {
        timer.cancel();
        go(context, KRoutes.courses, extra: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.white,
      body: Stack(
        children: [
          PositionedDirectional(
            start: 40,
            child: Lottie.asset(Kicons.backgroundCircle),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                CustomContainer(
                  horizontalPadding: 16,
                  verticalPadding: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(20),
                        CustomContainer(
                          width: 85,
                          height: 85,
                          color: KColors.primaryAlpha20,
                          border: Border.all(
                            color: KColors.bordorGreen,
                            width: 1,
                          ),
                          borderRadius: 24,
                          child: Icon(
                            Icons.mail_outline_rounded,
                            color: KColors.primary,
                            size: 40,
                          ),
                        ),
                        const Gap(20),
                        Text(
                          LocaleKeys.check_email_title.tr(),
                          style: KFonts.bold18,
                        ),
                        const Gap(10),
                        Text(
                          LocaleKeys.verification_sent.tr(),
                          style: KFonts.medium16.copyWith(
                            color: KColors.secondary,
                          ),
                        ),
                        const Gap(30),
                        Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: CustomContainer(
                            color: KColors.primaryAlpha20,
                            horizontalPadding: 16,
                            verticalPadding: 8,
                            border: Border.all(
                              color: KColors.bordorGreen,
                              width: 1,
                            ),
                            borderRadius: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: KColors.primary,
                                  size: 20,
                                ),
                                Text(
                                  widget.cubit.emailController.text,
                                  style: KFonts.bold18.copyWith(
                                    color: KColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(25),
                        CustomContainer(
                          width: double.infinity,
                          horizontalPadding: 16,
                          verticalPadding: 16,
                          color: KColors.primaryAlpha20,
                          border: Border.all(
                            color: KColors.bordorGreen,
                            width: 1,
                          ),
                          borderRadius: 24,
                          child: Column(
                            spacing: 10,
                            children: [
                              Text(
                                LocaleKeys.step_1.tr(),
                                style: KFonts.medium16.copyWith(
                                  fontSize: 14,
                                  color: KColors.darkGray,
                                ),
                              ),
                              const Divider(color: KColors.bordorGreen),
                              Text(
                                LocaleKeys.step_2.tr(),
                                style: KFonts.medium16.copyWith(
                                  fontSize: 14,
                                  color: KColors.darkGray,
                                ),
                              ),
                              const Divider(color: KColors.bordorGreen),

                              Text(
                                LocaleKeys.step_3.tr(),
                                style: KFonts.medium16.copyWith(
                                  fontSize: 14,
                                  color: KColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.did_not_receive_email.tr(),
                              style: KFonts.medium16.copyWith(
                                fontSize: 13,
                                color: KColors.secondary,
                              ),
                            ),
                            ResendEmail(cubit: widget.cubit),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResendEmail extends StatefulWidget {
  const ResendEmail({super.key, required this.cubit});
  final AuthCubit cubit;
  @override
  State<ResendEmail> createState() => _ResendEmailState();
}

class _ResendEmailState extends State<ResendEmail> {
  Timer? _timer;
  int _start = 59;
  bool _isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    void startTimer() {
      setState(() {
        _isButtonDisabled = true;
        _start = 59;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      });
    }

    return InkWell(
      onTap: !_isButtonDisabled
          ? () async {
              startTimer();
              await widget.cubit.sendVerificationEmail();
            }
          : null,
      child: Text(
        !_isButtonDisabled ? LocaleKeys.resend_email.tr() : _start.toString(),
        style: KFonts.medium16.copyWith(fontSize: 13, color: KColors.primary),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // ضروري جداً لتجنب تسريب الذاكرة (Memory Leak)
    super.dispose();
  }
}
