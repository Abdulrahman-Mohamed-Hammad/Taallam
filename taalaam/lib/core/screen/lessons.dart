import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lottie/lottie.dart';
import 'package:student_app/core/Constant/constant_color.dart';
import 'package:student_app/core/Constant/constant_font.dart';
import 'package:student_app/core/Constant/constant_icons.dart';
import 'package:student_app/core/Hive/hive_helper.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/data/cubit/cubit-state.dart';
import 'package:student_app/core/data/cubit/cubit.dart';
import 'package:student_app/core/go_router.dart';
import 'package:student_app/core/screen/Courses%20Screen/courses.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';
import 'package:student_app/main.dart';
import 'package:video_player/video_player.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key, required this.subject});

  final SubjectModel subject;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentCubit>();
    if (subject.lessons == null) {
      cubit.getAlllessons(subject);
    }

    return Scaffold(
      backgroundColor: KColors.backgroundCourse,
      body: BlocBuilder<StudentCubit, AppState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                horizontalPadding: 16,
                border: const Border(
                  bottom: BorderSide(color: KColors.bordorColor, width: 1),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Row(
                      spacing: 12,
                      children: [
                        CustomCirclirContainer(
                          icon: Icons.arrow_back_ios_new_rounded,
                          radius: 20,
                          sizeIcon: 18,
                          onTap: () => pop(context),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.lessons_title.tr(),
                                style: KFonts.bold20,
                              ),
                              Text(
                                subject.name![context.locale.languageCode]!,
                                style: KFonts.regular13Secoundry,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final lessons = subject.lessons!;

                            cubit.set.addAll(
                              List.generate(lessons.length, (i) => i).where(
                                (i) =>
                                    HiveHelper.getisDownloaded(
                                      lessons[i].id!,
                                    ) ==
                                    null,
                              ),
                            );
                            cubit.downloadVideo(
                              subject.lessons![cubit.set.first],
                              subject: subject,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.download_rounded,
                                  color: KColors.primary,
                                  size: 20,
                                ),
                                const Gap(5),
                                Text(
                                  LocaleKeys.download_all.tr(),
                                  style: KFonts.bold13DarkGray,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              state is AppLoadingState
                  ? const LoadingWidget()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            child: Text(
                              LocaleKeys.lessons_progress.tr(
                                args: [
                                  (subject.lessons?.length ?? 0).loc(context),
                                  subject.progress!.loc(context),
                                ],
                              ),
                              style: KFonts.bold15Secoundry,
                            ),
                          ),

                          ListView.builder(
                            itemCount: subject.lessons?.length ?? 0,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CustomContainer(
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),

                                horizontalPadding: 16,
                                verticalPadding: 20,
                                borderRadius: 20,
                                color: subject.lessons![index].isCompleted
                                    ? KColors.containerComplete
                                    : KColors.white,
                                border: Border.all(
                                  color: subject.lessons![index].isCompleted
                                      ? KColors.borderComplete
                                      : KColors.bordorColor,
                                  width: 1,
                                ),
                                onTap: () => push(
                                  context,
                                  KRoutes.showLesson,
                                  extra: [subject.lessons![index], subject],
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    CustomContainer(
                                      width: 50,
                                      height: 50,
                                      borderRadius: 24,
                                      color: subject.lessons![index].isCompleted
                                          ? KColors.darkGreen.withValues(
                                              alpha: 0.1,
                                            )
                                          : Color(0xFFF0F5F5),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: KFonts.bold15Secoundry
                                              .copyWith(
                                                color:
                                                    subject
                                                        .lessons![index]
                                                        .isCompleted
                                                    ? KColors.darkGreen
                                                    : KColors.secondary,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subject
                                                .lessons![index]
                                                .name![context
                                                .locale
                                                .languageCode]!,
                                            style: KFonts.bold15.copyWith(
                                              fontSize: 16,
                                            ),
                                          ),

                                          Builder(
                                            builder: (context) {
                                              final lesson =
                                                  subject.lessons![index];
                                              final isDownloaded =
                                                  HiveHelper.getisDownloaded(
                                                    lesson.id!,
                                                  ) ??
                                                  false;
                                              final completed =
                                                  lesson.isCompleted;

                                              final String
                                              text = switch (isDownloaded) {
                                                true =>
                                                  completed
                                                      ? LocaleKeys
                                                            .completed_downloaded
                                                            .tr()
                                                      : LocaleKeys
                                                            .not_completed_downloaded
                                                            .tr(),
                                                false =>
                                                  completed
                                                      ? LocaleKeys
                                                            .completed_not_downloaded
                                                            .tr()
                                                      : LocaleKeys
                                                            .not_completed_not_downloaded
                                                            .tr(),
                                              };

                                              return Text(
                                                text,
                                                style:
                                                    KFonts.regular13Secoundry,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap:
                                          HiveHelper.getisDownloaded(
                                                subject.lessons![index].id!,
                                              ) ==
                                              null
                                          ? () {
                                              if (cubit.set.isNotEmpty) {
                                                cubit.set.add(index);
                                                cubit.emitInitialState();
                                                return;
                                              }
                                              cubit.downloadVideo(
                                                subject.lessons![index],
                                                indexDownload: index,
                                                subject: subject,
                                              );
                                            }
                                          : null,
                                      child: (cubit.set.contains(index))
                                          ? CustomCirclerIndicatorDownloaded(
                                              cubit: cubit,
                                              check: cubit.set.first != index
                                                  ? false
                                                  : true,
                                            )
                                          : HiveHelper.getisDownloaded(
                                                  subject.lessons![index].id!,
                                                ) ==
                                                null
                                          ? const CustomCirclirContainer(
                                              icon: Icons.download_rounded,
                                              radius: 20,
                                              sizeIcon: 24,
                                              color: Color(0xFFF0F5F5),
                                              colorIcon: KColors.secondary,
                                            )
                                          : const Icon(
                                              Icons.check_rounded,
                                              size: 24,
                                              color: KColors.darkGreen,
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class CustomCirclerIndicatorDownloaded extends StatelessWidget {
  const CustomCirclerIndicatorDownloaded({
    super.key,
    required this.cubit,
    required this.check,
  });
  final StudentCubit cubit;
  final bool check;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: cubit.responseFirebaseClass.progressNotifier,
      builder: (context, value, child) => Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            color: KColors.primary,
            strokeWidth: 2,
            backgroundColor: KColors.primaryAlpha20,
            value: check ? value : 0,
          ),
          if (check)
            Text("${(value * 100).toInt()}", style: KFonts.black14Primary),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size, this.jsonIcon});
  final double? size;
  final String? jsonIcon;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Lottie.asset(
          jsonIcon ?? Kicons.greenloadingBook,
          width: size ?? 60,
          height: size ?? 60,
        ),
      ),
    );
  }
}

class ShowLessonScreen extends StatefulWidget {
  const ShowLessonScreen({
    super.key,
    required this.lesson,
    required this.indexSubject,
  });

  final LessonsModel lesson;
  final SubjectModel indexSubject;

  @override
  State<ShowLessonScreen> createState() => _ShowLessonScreenState();
}

class _ShowLessonScreenState extends State<ShowLessonScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<StudentCubit>();
    return Scaffold(
      floatingActionButton: currentPage != 2
          ? GestureDetector(
              onTap: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: KColors.primary,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: KColors.white,
                  size: 22,
                ),
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(
                child: DescriptionLesson(lesson: widget.lesson),
              ),
              SingleChildScrollView(
                child: Example(
                  lesson: widget.lesson,
                  onOptionSelected: (value) {
                    if (value) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
              VideoAndPractice(
                lesson: widget.lesson,
                subject: widget.indexSubject,
                cubit: cubit,
                onOptionSelected: (value) {
                  if (value) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionLesson extends StatelessWidget {
  const DescriptionLesson({super.key, required this.lesson});

  final LessonsModel lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),

        const Gap(5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: PopButtonPage(
                color: KColors.secondary,
                onTap: () => pop(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  LocaleKeys.lesson_title.tr(),
                  style: KFonts.regular18.copyWith(color: KColors.secondary),
                ),
              ),
            ),
            const Gap(45),
          ],
        ),
        Center(
          child: Text(
            lesson.name![context.locale.languageCode]!,
            style: KFonts.bold20.copyWith(color: KColors.primary),
          ),
        ),
        const Gap(20),
        Text(
          LocaleKeys.lesson_description.tr(),
          style: KFonts.regular18.copyWith(color: KColors.secondary),
        ),
        const Gap(5),
        Text(
          lesson.description![context.locale.languageCode]!,
          style: KFonts.medium16.copyWith(color: Colors.black, fontSize: 18),
          softWrap: true,
        ),
        const Gap(80),
      ],
    );
  }
}

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.lesson,
    required this.onOptionSelected,
  });
  final LessonsModel lesson;
  final Function(bool) onOptionSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PopButtonPage(onOptionSelected: onOptionSelected),
            Text(
              LocaleKeys.illustrative_example.tr(),
              style: KFonts.regular18.copyWith(color: KColors.primary),
            ),
          ],
        ),
        const Gap(5),
        Text(
          lesson.examples![context.locale.languageCode]!,
          style: KFonts.medium16.copyWith(color: Colors.black, fontSize: 18),
          softWrap: true,
        ),
        const Gap(80),
      ],
    );
  }
}

class PopButtonPage extends StatelessWidget {
  const PopButtonPage({
    super.key,
    this.onOptionSelected,
    this.color = KColors.primary,
    this.onTap,
  });

  final Function(bool p1)? onOptionSelected;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios_outlined, color: color, size: 20),
      onPressed: () {
        onTap?.call(); // ✅ always runs
        onOptionSelected?.call(true); // ✅ always runs if not null
      },
    );
  }
}

class VideoAndPractice extends StatefulWidget {
  const VideoAndPractice({
    super.key,
    required this.lesson,
    required this.onOptionSelected,
    required this.cubit,
    required this.subject,
  });
  final LessonsModel lesson;
  final SubjectModel subject;
  final Function(bool) onOptionSelected;
  final StudentCubit cubit;
  @override
  State<VideoAndPractice> createState() => _VideoAndPracticeState();
}

class _VideoAndPracticeState extends State<VideoAndPractice> {
  int? choice;
  int currentIndex = 0;
  List<bool> Answers = [];
  final _videoKey = GlobalKey<VideoShowState>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PopButtonPage(
            onOptionSelected: widget.onOptionSelected,
            onTap: () {
              log('state: ${_videoKey.currentState}'); // check if null
              _videoKey.currentState?.pause();
            },
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoShow(
                key: _videoKey,
                videoUrl: widget.lesson.videoUrl!,
              ),
            ),
          ),
          const Gap(20),

          Expanded(
            flex: 6,
            child: CustomContainer(
              borderRadius: 16,
              verticalPadding: 2,
              horizontalPadding: 2,
              width: double.infinity,
              height: 420,
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

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  currentIndex < widget.lesson.practes!.length
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              LocaleKeys.lesson_exercises.tr(),
                              style: KFonts.regular18.copyWith(
                                color: KColors.secondary,
                                fontSize: context.locale.countryCode == "ar"
                                    ? 18
                                    : 16,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(height: 10),

                  currentIndex < widget.lesson.practes!.length
                      ? Expanded(
                          flex: 12,
                          child: Practies(
                            lesson: widget.lesson,
                            indexPractes: currentIndex,
                            onOptionSelected: (value) {
                              if (choice != value) {
                                setState(() {
                                  choice = value;
                                });
                              }
                            },
                          ),
                        )
                      : BlocBuilder<StudentCubit, AppState>(
                          builder: (context, state) {
                            if (state is AppLoadingState) {
                              return Expanded(
                                child: Center(child: const LoadingWidget()),
                              );
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(),
                                      Text(
                                        LocaleKeys.correct_wrong_answers.tr(),
                                        style: KFonts.bold20.copyWith(
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                                      ...List.generate(Answers.length, (
                                        indexList,
                                      ) {
                                        if (!Answers[indexList]) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${(indexList + 1)} ) ${widget.lesson.practes![indexList].questionText![context.locale.languageCode]!}",
                                                style: KFonts.semiBold20
                                                    .copyWith(fontSize: 18),
                                              ),
                                              const Gap(5),

                                              Text(
                                                "${widget.lesson.practes![indexList].stepAnswer![context.locale.languageCode]}",
                                                style: KFonts.regular16
                                                    .copyWith(
                                                      color: KColors.secondary,
                                                    ),
                                              ),
                                              const Gap(10),
                                            ],
                                          );
                                        }
                                        return SizedBox();
                                      }),
                                      const Gap(10),
                                      Text(
                                        LocaleKeys.result_percentage.tr(
                                          args: [
                                            (Answers.where(
                                                      (e) => e == true,
                                                    ).length /
                                                    Answers.length *
                                                    100)
                                                .floor()
                                                .toString(),
                                          ],
                                        ),
                                        style: KFonts.bold20.copyWith(
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          const Gap(10),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                if (currentIndex < widget.lesson.practes!.length) {
                  if (choice != null) {
                    if (widget.lesson.practes![currentIndex].correctAnswer! ==
                        widget
                            .lesson
                            .practes![currentIndex]
                            .choices![choice!]) {
                      Answers.add(true);
                    } else {
                      Answers.add(false);
                    }
                    setState(() {
                      currentIndex++;
                      choice = null;
                    });
                    if (!widget.lesson.isCompleted &&
                        currentIndex == widget.lesson.practes!.length &&
                        (Answers.where((e) => e == true).length /
                                    Answers.length *
                                    100)
                                .floor() >=
                            66) {
                      await widget.cubit.updateIsCompletedAndProgress(
                        widget.subject,

                        widget.lesson,
                        true,
                      );
                    }
                  }
                  return;
                }
                pop(context);
              },
              child: CustomContainer(
                height: 60,
                color: Colors.white,
                borderRadius: 16,
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
                child: Center(
                  child: Text(
                    currentIndex < widget.lesson.practes!.length
                        ? LocaleKeys.next_question.tr(
                            args: [
                              (currentIndex + 1).loc(context),
                              widget.lesson.practes!.length.loc(context),
                            ],
                          )
                        : LocaleKeys.lessons_list.tr(),
                    style: KFonts.semiBold20.copyWith(
                      fontSize: 18,
                      color: KColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Practies extends StatefulWidget {
  const Practies({
    super.key,
    required this.lesson,
    required this.indexPractes,
    required this.onOptionSelected,
  });

  final LessonsModel lesson;
  final int indexPractes;
  final Function(int) onOptionSelected;
  @override
  State<Practies> createState() => _PractiesState();
}

class _PractiesState extends State<Practies> {
  int currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    widget
                        .lesson
                        .practes![widget.indexPractes]
                        .questionText![context.locale.languageCode]!,
                    style: KFonts.bold20.copyWith(
                      fontSize: context.locale.countryCode == "ar" ? 18 : 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(5),
          ...List.generate(
            4,
            (index) => Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (currentIndex != index) {
                      setState(() {
                        currentIndex = index;
                      });
                      widget.onOptionSelected(index);
                    }
                  },
                  child: CustomContainer(
                    height: 60,
                    horizontalPadding: 16,
                    borderRadius: 16,
                    color: currentIndex == index
                        ? KColors.primaryAlpha20
                        : Colors.grey.shade100,
                    width: double.infinity,
                    border: Border.all(
                      color: currentIndex == index
                          ? KColors.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        widget
                            .lesson
                            .practes![widget.indexPractes]
                            .choices![index]
                            .toString(),
                        style: KFonts.regular18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Gap(5),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant Practies oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.indexPractes != widget.indexPractes) {
      setState(() {
        currentIndex = -1;
      });
    }
  }
}

class VideoShow extends StatefulWidget {
  const VideoShow({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<VideoShow> createState() => VideoShowState();
}

class VideoShowState extends State<VideoShow>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void pause() => _videoController.pause();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _chewieController != null
        ? Chewie(controller: _chewieController!)
        : Container(
            color: Colors.black,
            child: Center(child: CircularProgressIndicator()),
          );
  }

  void _initVideoPlayer() async {
    final cachedFile = await HiveHelper.cacheManager.getFileFromCache(
      widget.videoUrl,
    );
    if (cachedFile == null) {
      if (await HiveHelper.checkInternet()) {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      }
    } else {
      _videoController = VideoPlayerController.file(cachedFile.file);
    }

    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,

      materialProgressColors: ChewieProgressColors(
        handleColor: KColors.primary,
        playedColor: KColors.primary,
        bufferedColor: KColors.secondary,
      ),
    );

    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
