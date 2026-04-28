import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/data/cubit/cubit-state.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/go_router.dart';

import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/core/screen/lessons.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';

class RoadMapCourses extends StatelessWidget {
  const RoadMapCourses({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<StudentCubit>()
      ..getAllSubjects(false, roadMapCourse: true);
    List<List<SubjectModel>> levels;

    final responseSubjectListRoadMap =
        cubit.responseFirebaseClass.subjectsListRoadMap;
    return Scaffold(
      backgroundColor: KColors.background,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: BlocBuilder<StudentCubit, AppState>(
            builder: (context, state) {
              levels = cubit.responseFirebaseClass.splitresponseTolevel();
              double progress =
                  responseSubjectListRoadMap.isEmpty || state is AppLoadingState
                  ? 0.0
                  : responseSubjectListRoadMap
                            .where((e) => e.isCompleted == true)
                            .length /
                        responseSubjectListRoadMap.length;

              return Column(
                children: [
                  CustomContainer(
                    horizontalPadding: 16,
                    border: const Border(
                      bottom: BorderSide(
                        color: KColors.primaryAlpha20,
                        width: 1,
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.learning_path.tr(),
                                    style: KFonts.bold20,
                                  ),
                                  Text(
                                    LocaleKeys.roadmap_courses_sorted_by_level
                                        .tr(),
                                    style: KFonts.regular13Secoundry,
                                  ),
                                ],
                              ),
                            ),
                            CustomCirclirContainer(
                              icon: Icons.close_rounded,
                              radius: 20,
                              sizeIcon: 18,
                              onTap: () {
                                pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomContainer(
                    verticalPadding: 14,
                    horizontalPadding: 16,
                    border: const Border(
                      bottom: BorderSide(color: KColors.bordorColor, width: 1),
                    ),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                LocaleKeys.roadmap_overall_progress.tr(),
                                style: KFonts.bold14Secoundery,
                              ),
                            ),
                            Text(
                              " % ${(progress * 100).loc(context)}",
                              style: KFonts.black14Primary,
                            ),
                          ],
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeInOutCubic,
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: KColors.primaryAlpha20,
                              color: KColors.primary,
                              minHeight: 7,
                              borderRadius: BorderRadius.circular(3),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  state is AppLoadingState
                      ? const LoadingWidget()
                      : Column(
                          children: [
                            if (levels[0].isNotEmpty)
                              CoursesRoadMapBodyScreen(
                                levels: LevelsMOdel(
                                  level: LocaleKeys.beginner_level.tr(),
                                  subjects: levels[0],
                                  color: KColors.darkGreen,
                                  backgroundColor: KColors.lightGreen,
                                ),
                                cubit: cubit,
                              ),
                            if (levels[1].isNotEmpty)
                              CoursesRoadMapBodyScreen(
                                levels: LevelsMOdel(
                                  level: LocaleKeys.intermediate_level.tr(),
                                  subjects: levels[1],
                                  color: KColors.darkblue,
                                  backgroundColor: KColors.lightblue,
                                ),
                                cubit: cubit,
                              ),
                            if (levels[2].isNotEmpty)
                              CoursesRoadMapBodyScreen(
                                levels: LevelsMOdel(
                                  level: LocaleKeys.advanced_level.tr(),
                                  subjects: levels[2],
                                  color: KColors.darkred,
                                  backgroundColor: KColors.lightred,
                                ),
                                cubit: cubit,
                              ),
                            const Gap(20),
                          ],
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LevelsMOdel {
  Color backgroundColor;
  Color color;
  String level;

  List<SubjectModel> subjects;

  LevelsMOdel({
    required this.backgroundColor,
    required this.color,
    required this.level,
    required this.subjects,
  });
}

class CoursesRoadMapBodyScreen extends StatelessWidget {
  const CoursesRoadMapBodyScreen({
    super.key,
    required this.levels,
    required this.cubit,
  });
  final LevelsMOdel levels;
  final StudentCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Leveles(
          text: LocaleKeys.completed_out_of.tr(
            args: [
              levels.subjects
                  .where((s) => s.isCompleted == true)
                  .length
                  .loc(context),
              levels.subjects.length.loc(context),
            ],
          ),
          level: levels.level,
          color: levels.color,
          backgroundColor: levels.backgroundColor,
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: levels.subjects.length,
          itemBuilder: (context, index) {
            if (levels.subjects[index].lock!) {
              return SubjectLocked(
                subject: levels.subjects[index],
                cubit: cubit,
              );
            }
            if (levels.subjects[index].isCompleted!) {
              return SubjectComplete(
                subject: levels.subjects[index],
                onTap: () {
                  push(context, KRoutes.lessons, extra: levels.subjects[index]);
                },
              );
            }
            return Subject(
              onTap: () {
                push(context, KRoutes.lessons, extra: levels.subjects[index]);
              },
              subject: levels.subjects[index],
              bordorColor: KColors.primary,
              level: LocaleKeys.ongoing_roadMap.tr(),
              boxShadow: [
                BoxShadow(
                  color: KColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: KColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class Leveles extends StatelessWidget {
  const Leveles({
    super.key,
    required this.level,
    required this.color,
    required this.backgroundColor,
    required this.text,
  });
  final String level;
  final Color color;
  final Color backgroundColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 10,
        children: [
          CustomContainer(
            horizontalPadding: 10,
            verticalPadding: 6,
            borderRadius: 20,
            color: backgroundColor,
            child: Text(
              level,
              style: KFonts.black14Primary.copyWith(color: color),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 0.4, color: KColors.secondary),
          ),
          Text(text, style: KFonts.bold14Secoundery.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}
