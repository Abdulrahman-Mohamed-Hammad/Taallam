import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          horizontalPadding: 16,
          verticalPadding: 12,
          border: bottomBorder,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.settings_title.tr(), style: KFonts.black30),
                const Gap(12),
                Text(
                  LocaleKeys.customize_account.tr(),
                  style: KFonts.regular14,
                ),
                const Gap(7),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomContainer(
                width: double.infinity,
                verticalPadding: 34,
                horizontalPadding: 16,
                borderRadius: 24,
                border: Border.all(width: 1, color: KColors.bordorColor),
                margin: const EdgeInsets.only(top: 21, bottom: 16),
                boxShadow: shadowBlack,
                child: Row(
                  spacing: 15,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        const CustomCirclePerson(
                          height: 65,
                          width: 65,
                          iconSize: 40,
                        ),

                        CircleAvatar(
                          backgroundColor: KColors.primary,
                          radius: 12,
                          child: const CustomCirclePerson(
                            height: 22,
                            width: 22,
                            iconSize: 12,
                            color: KColors.white,
                            icon: Icons.edit_square,
                            iconColor: KColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FirebaseHelper.fireauth.currentUser!.displayName!,
                            style: KFonts.black18,
                          ),
                          Text(
                            FirebaseHelper.fireauth.currentUser!.email!,
                            style: KFonts.regular14,
                          ),
                        ],
                      ),
                    ),
                    CustomCirclirContainer(
                      icon: Icons.arrow_forward_ios_rounded,
                      radius: 18,
                      sizeIcon: 12,
                      color: KColors.primaryAlpha20,
                      colorIcon: KColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.general.tr(), style: KFonts.black13Secoundry),

              CustomContainer(
                width: double.infinity,
                verticalPadding: 16,
                horizontalPadding: 16,
                borderRadius: 24,
                border: Border.all(width: 1, color: KColors.bordorColor),
                margin: const EdgeInsets.only(top: 21, bottom: 16),
                boxShadow: shadowBlack,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 7,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.english_language.tr(),
                            style: KFonts.bold15,
                          ),
                          Text(
                            LocaleKeys.currently_disabled.tr(),
                            style: KFonts.regular13Secoundry,
                          ),
                        ],
                      ),
                    ),
                    ToggleButton(cubit: context.read<StudentCubit>()),
                  ],
                ),
              ),
              Text(
                LocaleKeys.account_section.tr(),
                style: KFonts.black13Secoundry,
              ),
              CustomContainer(
                onTap: () async {
                  await FirebaseHelper.logout();
                  go(context, KRoutes.controllAuth);
                },
                width: double.infinity,
                verticalPadding: 16,
                horizontalPadding: 16,
                borderRadius: 24,
                border: Border.all(width: 1, color: KColors.bordorColor),
                margin: const EdgeInsets.only(top: 21, bottom: 16),
                boxShadow: shadowBlack,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 7,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.sign_out.tr(),
                            style: KFonts.bold15.copyWith(
                              color: Color(0XFFC62828),
                            ),
                          ),
                          Text(
                            LocaleKeys.logout_current_account.tr(),
                            style: KFonts.regular13Secoundry,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: KColors.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key, required this.cubit});
  final StudentCubit cubit;
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool isSwitched;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched = context.locale.languageCode == 'ar' ? false : true,
      onChanged: (val) async {
        setState(() {
          isSwitched = val;
        });
        await context.setLocale(val ? Locale('en') : Locale('ar'));
        widget.cubit.emitInitialState();
      },
      activeColor: Colors.white,
      activeTrackColor: KColors.primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Color(0xFFDDDDEE),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
