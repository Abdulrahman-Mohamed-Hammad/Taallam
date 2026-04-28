import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:student_app/FireBase/firebase.dart';

import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/data/cubit/cubit-state.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/core/screen/Courses%20Screen/bottom_nav_bar_screen.dart';
import 'package:student_app/core/screen/lessons.dart';
import 'package:student_app/core/screen/settings.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';
import 'package:student_app/main.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentCubit>()..getAllSubjects(true);

    return BlocBuilder<StudentCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: KColors.backgroundCourse,
          bottomNavigationBar: CustomBottomNavBar(cubit: cubit),
          body: cubit.currentIndexNavBAr == 0
              ? CourseBody(cubit: cubit, state: state)
              : Settings(),
        );
      },
    );
  }
}

class CustomContainerBottomNav extends StatelessWidget {
  const CustomContainerBottomNav({
    super.key,
    required this.child,
    required this.color,
    required this.padding,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      padding: EdgeInsets.all(padding),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class CustomSvgIMage extends StatelessWidget {
  const CustomSvgIMage({
    super.key,
    required this.icon,
    required this.size,
    this.color = KColors.primary,
  });
  final String icon;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      height: size,
      width: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class CourseBody extends StatelessWidget {
  const CourseBody({super.key, required this.cubit, required this.state});
  final StudentCubit cubit;
  final AppState state;
  static const List<String> catagores = [
    LocaleKeys.ongoing,
    LocaleKeys.completed,
  ];
  @override
  Widget build(BuildContext context) {
    var responseSubjectList = cubit.responseFirebaseClass.subjectsList;
    return RefreshIndicator(
      onRefresh: () async {
        await cubit.getAllSubjects(true, loadingState: false);
      },
      color: Colors.grey.shade100,
      backgroundColor: KColors.primary,
      displacement: 17,
      child: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                horizontalPadding: 16,
                verticalPadding: 12,
                border: bottomBorder,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.welcome_message.tr(),
                              style: KFonts.regular14,
                            ),
                            const Gap(15),
                            Text(
                              FirebaseHelper.fireauth.currentUser!.displayName!,
                              style: KFonts.black18,
                            ),
                            const Gap(15),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          const CustomCirclePerson(),

                          CircleAvatar(
                            radius: 7,
                            backgroundColor: KColors.white,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: cubit.isOnlineMode
                                  ? Color(0xFF69F0AE)
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  push(context, KRoutes.roadMapCourses);
                },
                child: Container(
                  width: double.infinity,

                  margin: const EdgeInsets.fromLTRB(16, 21, 16, 16),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: KColors.linearGradiunt,
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 20,
                        color: KColors.primaryAlpha20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Stack(
                      children: [
                        const CustomPositionCircleWithSize(
                          radius: 60,
                          top: -45,
                          left: -30,
                        ),
                        const CustomPositionCircleWithSize(
                          radius: 65,
                          bottom: -45,
                          right: 50,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.learning_path.tr(),
                                      style: KFonts.bold17White,
                                    ),
                                    Text(
                                      LocaleKeys.start_learning_journey.tr(),
                                      style: KFonts.regular13White,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Row(
              //     children: [
              //       const Expanded(
              //         child: Text("جميع المقررات", style: KFonts.bold15),
              //       ),
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: 5,
              //           horizontal: 10,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Color(0xFFE0F2F1),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Text(
              //           "${responseSubjectList.length} مواد",
              //           style: KFonts.bold13DarkGray,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.my_courses_Length.tr(
                          args: [responseSubjectList.length.loc(context)],
                        ),
                        style: KFonts.bold15,
                      ),
                    ),
                    Row(
                      spacing: 7,
                      children: List.generate(
                        2,
                        (index) => CustomContainer(
                          onTap: () {
                            if (cubit.subCatagores != index) {
                              cubit.subCatagores = index;
                              cubit.emitInitialState();
                            }
                          },
                          boxShadow: index == cubit.subCatagores
                              ? shadowGreen
                              : null,
                          borderRadius: 24,
                          verticalPadding: 10,
                          horizontalPadding: 16,
                          color: cubit.subCatagores == index
                              ? KColors.primary
                              : const Color(0xFFE0F2F1),
                          child: Text(
                            catagores[index].tr(),
                            style: cubit.subCatagores == index
                                ? KFonts.black13white
                                : KFonts.black13Primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              state is AppLoadingState
                  ? const LoadingWidget()
                  : responseSubjectList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SvgPicture.asset(Kicons.noSubject, width: 165),
                      ),
                    )
                  : ListView.builder(
                      itemCount: responseSubjectList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final subject = responseSubjectList[index];
                        final isCompleted = subject.isCompleted ?? false;
                        final category = cubit.subCatagores;

                        void onTap() =>
                            push(context, KRoutes.lessons, extra: subject);

                        if (category == 0 && !isCompleted) {
                          return Subject(
                            subject: subject,
                            boxShadow: shadowBlack,
                            onTap: onTap,
                          );
                        }

                        if (category == 1 && isCompleted) {
                          return SubjectComplete(
                            subject: subject,
                            onTap: onTap,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCirclePerson extends StatelessWidget {
  const CustomCirclePerson({
    super.key,
    this.width = 50,
    this.height = 50,
    this.iconSize = 27,
    this.icon = Icons.person_rounded,
    this.color,
    this.iconColor,
  });

  final double width;
  final double height;
  final double iconSize;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        gradient: color == null ? KColors.linearGradiunt : null,
        color: color,
        boxShadow: shadowGreen,
      ),
      child: Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
    );
  }
}

class Subject extends StatelessWidget {
  const Subject({
    super.key,
    required this.subject,
    this.bordorColor,
    this.color,
    this.icon,
    this.level,
    this.colorIcon,
    this.chanegCircleColor = false,
    this.boxShadow,
    this.size,
    this.onTap,
  });

  final SubjectModel subject;
  final Color? bordorColor;
  final Color? color;
  final Color? colorIcon;
  final IconData? icon;
  final bool chanegCircleColor;
  final String? level;
  final double? size;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      color: color ?? KColors.white,
      verticalPadding: 16,
      horizontalPadding: 16,
      boxShadow: boxShadow,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      borderRadius: 24,
      width: double.infinity,
      border: Border.all(width: 1, color: bordorColor ?? KColors.bordorColor),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFF0F5F5),
            ),
            child: ImageLoadingFromInternet(subject: subject),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name![context.locale.languageCode]!,
                  style: KFonts.bold15,
                ),
                Text(
                  LocaleKeys.lessons_with_level.tr(
                    args: [
                      subject.lessonsCount!.loc(context),
                      level ?? subject.gelevelArabic(subject.level!),
                    ],
                  ),
                  style: KFonts.regular16.copyWith(
                    fontSize: 14,
                    color: KColors.secondary,
                  ),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),

                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: getFraction(
                          subject.progress,
                          subject.lessonsCount,
                        ),
                        backgroundColor: Colors.blueGrey.shade50,
                        color: KColors.secondary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(
                      "${getPercent(subject.progress, subject.lessonsCount)}%",
                      style: KFonts.black14Primary.copyWith(
                        color: KColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomCirclirContainer(
            icon: icon ?? Icons.arrow_forward_ios_rounded,
            radius: 18,
            sizeIcon: size ?? 12,
            color: chanegCircleColor ? bordorColor : null,
            colorIcon: colorIcon,
          ),
        ],
      ),
    );
  }
}

class ImageLoadingFromInternet extends StatelessWidget {
  const ImageLoadingFromInternet({super.key, required this.subject});

  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      subject.image!,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const LoadingWidget();
      },
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.wifi_off_rounded),
    );
  }
}

int getPercent(num? current, num? total) {
  if (total == null || total <= 0) return 0;

  double result = ((current ?? 0) / total) * 100;

  return result.toInt().clamp(0, 100);
}

double getFraction(num? current, num? total) {
  if (total == null || total <= 0) return 0.0;

  double result = (current ?? 0) / total;

  return result.clamp(0.0, 1.0);
}

class SubjectLocked extends StatelessWidget {
  const SubjectLocked({super.key, required this.subject, required this.cubit});

  final SubjectModel subject;
  final StudentCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: Color(0xFFF5FAFA),
      verticalPadding: 16,
      horizontalPadding: 16,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      borderRadius: 24,
      width: double.infinity,
      border: Border.all(width: 1, color: Color(0xFFF0F5F5)),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey.shade50,
            ),
            child: Image.asset(Kicons.lockPNG),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name![context.locale.languageCode]!,
                  style: KFonts.bold15.copyWith(color: Color(0xFF7A8A89)),
                ),
                Text(
                  LocaleKeys.complete_first.tr(
                    args: [
                      cubit.responseFirebaseClass.getNameByID(
                        subject.id!,
                        context.locale.languageCode,
                      ),
                    ],
                  ),
                  style: KFonts.regular16.copyWith(
                    fontSize: 14,
                    color: Color(0xFFAEC0C7),
                  ),
                ),

                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0,
                        backgroundColor: Colors.blueGrey.shade50,
                        color: Colors.blueGrey.shade500,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(
                      "0%",
                      style: KFonts.black14Primary.copyWith(
                        color: Color(0xFFAEC0C7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CustomCirclirContainer(
            icon: Icons.lock_clock_outlined,
            radius: 18,
            sizeIcon: 24,
            color: Color(0xFFF0F5F5),
            colorIcon: Color(0xFFDBE0E0),
          ),
        ],
      ),
    );
  }
}

class SubjectComplete extends StatelessWidget {
  const SubjectComplete({super.key, required this.subject, this.onTap});
  final VoidCallback? onTap;
  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      color: KColors.containerComplete,
      verticalPadding: 16,
      horizontalPadding: 16,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      borderRadius: 24,
      width: double.infinity,
      boxShadow: shadowBlack,
      border: Border.all(width: 1, color: KColors.borderComplete),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: KColors.borderComplete.withValues(alpha: 0.3),
            ),
            child: ImageLoadingFromInternet(subject: subject),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name![context.locale.languageCode]!,
                  style: KFonts.bold15,
                ),
                Text(
                  LocaleKeys.lessons_with_levelCompleted.tr(
                    args: [
                      subject.lessonsCount.toString(),
                      LocaleKeys.completed_count.tr(),
                    ],
                  ),
                  style: KFonts.regular16.copyWith(
                    fontSize: 14,
                    color: KColors.darkGreen,
                  ),
                ),

                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 1,
                        backgroundColor: Colors.blueGrey.shade50,
                        color: Color(0xFF43A047),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(
                      "100%",
                      style: KFonts.black14Primary.copyWith(
                        color: Color(0xFF43A047),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CustomCirclirContainer(
            icon: Icons.check_rounded,
            radius: 18,
            sizeIcon: 12,
            color: KColors.borderComplete,
            colorIcon: Color(0xFF43A047),
          ),
        ],
      ),
    );
  }
}

class CustomCirclirContainer extends StatelessWidget {
  const CustomCirclirContainer({
    super.key,
    required this.radius,
    required this.sizeIcon,
    required this.icon,
    this.onTap,
    this.color,
    this.colorIcon,
  });
  final double radius;
  final double sizeIcon;
  final IconData icon;
  final Color? color;
  final Color? colorIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color ?? KColors.primaryAlpha20,
        child: Icon(icon, size: sizeIcon, color: colorIcon ?? KColors.primary),
      ),
    );
  }
}

class CustomPositionCircleWithSize extends StatelessWidget {
  const CustomPositionCircleWithSize({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.radius,
  });
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: KColors.whiteAlpha15,
      ),
    );
  }
}

class ClickableContainer extends StatelessWidget {
  const ClickableContainer({
    super.key,
    required this.title,
    this.onTap,
    this.widget,
    this.horizontalPadding = 16,
    this.verticalPadding = 32,
  });
  final String title;
  final VoidCallback? onTap;
  final Widget? widget;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomContainer(
          // horizontalPadding: 16,
          // verticalPadding: 32,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          borderRadius: 16,
          width: double.infinity,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: KColors.primary.withValues(alpha: 0.08),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: KColors.primary.withValues(alpha: 0.06),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300, width: 0.4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: KFonts.bold20.copyWith(color: Colors.black),
                ),
              ),
              if (widget != null) widget!,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.border,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.borderRadius = 0,
    this.color = Colors.white,
    this.boxShadow,
    this.makeSplachFactory = true,
    this.margin,
    this.onTap,
    this.useGradiunt = false,
  });
  final double? height;
  final double? width;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final Color color;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool makeSplachFactory;
  final bool useGradiunt;
  final Widget child;

  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashFactory: makeSplachFactory
            ? InkSplash.splashFactory
            : NoSplash.splashFactory,
        highlightColor: makeSplachFactory ? null : Colors.transparent,
        onTap: onTap,
        child: Ink(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: color,
            border: border,
            boxShadow: boxShadow,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: useGradiunt ? KColors.linearGradiunt : null,
          ),

          child: child,
        ),
      ),
    );
  }
}

Timer checkInternetConnection(Future Function() method) {
  return Timer.periodic(const Duration(seconds: 5), (timer) async {
    await method();
  });
}

extension LocalizedNumber on num {
  String loc(BuildContext context) {
    final str = toString();
    if (context.locale.languageCode != 'ar') return str;
    return str.replaceAllMapped(
      RegExp(r'[0-9]'),
      (m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) + 0x0660 - 48),
    );
  }
}
