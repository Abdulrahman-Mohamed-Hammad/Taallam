import 'dart:async';

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';

import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Hive/hive_helper.dart';

import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/data/cubit/cubit-state.dart';

enum Screen { courses, lessons, showLesson }

class StudentCubit extends Cubit<AppState> {
  StudentCubit({SubjectModel? subject}) : super(AppInitialState());
  Screen screen = Screen.courses;
  final responseFirebaseClass = ResponseFireBase();

  bool isOnlineMode = true;
  Set set = {};
  int currentIndexNavBAr = 0;
  int subCatagores = 0;
  void changeBottomNav(int index) {
    currentIndexNavBAr = index;
    emit(AppChangeState());
  }

  void emitInitialState() {
    emit(AppInitialState());
  }

  Future<void> getAllSubjects(
    bool where, {
    bool loadingState = true,
    bool checkChangeState = true,
    bool roadMapCourse = false,
  }) async {
    if (loadingState) emit(AppLoadingState());
    var response = await FirebaseHelper.getCollection(
      FirebaseHelper.getCollectionPath(CollectionPath.subjects),
      where,
    );

    if (response == null) {
      responseFirebaseClass.subjectsList = HiveHelper.getAllSubjects();
      log("zzzzzzzzzzzzzzzzzzzzzzzzzz");
      log(responseFirebaseClass.subjectsList.toString());

      isOnlineMode = false;
      emit(AppChangeState());
      return;
    }
    if (response.isEmpty) {
      emit(AppErrorState("No subjects available"));
      return;
    }

    final list = await Future.wait(
      response.map((map) async {
        final subject = SubjectModel.fromJson(map);
        await FirebaseHelper.progressSubject(subject, subject.lock!);
        return subject;
      }),
    );

    if (roadMapCourse) {
      responseFirebaseClass.subjectsListRoadMap = list;
    } else {
      responseFirebaseClass.subjectsList = list;
    }

    isOnlineMode = true;
    if (checkChangeState) emit(AppChangeState());
  }

  Future<void> updateIsCompletedAndProgress(
    SubjectModel subject,

    LessonsModel lesson,
    bool isCompleted, [
    bool check = true,
  ]) async {
    if (check) emit(AppLoadingState());

    var response = await FirebaseHelper.updateLessonStatusAndSubject(
      FirebaseHelper.getCollectionPath(CollectionPath.subjects),
      subject.id!,
      FirebaseHelper.getCollectionPath(CollectionPath.lessons),
      lesson.id!,
      isCompleted,
      (subject.progress as int) + 1,
      subject.lessonsCount!,
      subject.next!,
    );

    if (response != null) {
      lesson.isCompleted = isCompleted;
      subject.progress = (subject.progress as int) + 1;
      subject.isCompleted = (subject.progress as int) == subject.lessonsCount;
      await HiveHelper.addSubject(subject.id!, subject);
      await getAllSubjects(true, loadingState: false, checkChangeState: false);
      emit(AppChangeState());
    }
  }

  Future<void> getAlllessons(SubjectModel subject, [bool check = true]) async {
    if (check) emit(AppLoadingState());

    var response = await Future.wait([
      FirebaseHelper.getSubCollection(
        FirebaseHelper.getCollectionPath(CollectionPath.subjects),
        subject.id!,
        FirebaseHelper.getCollectionPath(CollectionPath.lessons),
      ),
      FirebaseHelper.getCollectionGroup(
        FirebaseHelper.getCollectionPath(CollectionPath.practes),
      ),
    ]);

    // var response = await FirebaseHelper.getSubCollection(
    //   FirebaseHelper.getCollectionPath(CollectionPath.subjects),
    //   subject.id!,
    //   FirebaseHelper.getCollectionPath(CollectionPath.lessons),
    // );

    if (response[0] == null) {
      responseFirebaseClass.subjectsList = HiveHelper.getAllSubjects();
      emit(AppChangeState());
      return;
    }

    subject.lessons = await Future.wait(
      response[0]!.map((map) async {
        final lesson = LessonsModel.fromJson(map);
        lesson.practes = response[1]!
            .where((p) => p['id'] == lesson.id)
            .map((map) => PractesModel.fromJson(map))
            .toList();
        await FirebaseHelper.progressLesson(subject, lesson);
        return lesson;
      }),
    );

    // subject.lessons = response
    //     .map((map) => LessonsModel.fromJson(map))
    //     .toList();
    // var response2 = await FirebaseHelper.getCollectionGroup(
    //   FirebaseHelper.getCollectionPath(CollectionPath.practes),
    // );

    // for (var lesson in subject.lessons!) {
    //   lesson.practes = response2
    //       .where((p) => p['id'] == lesson.id) // ✅ filter by lessonId
    //       .map((map) => PractesModel.fromJson(map))
    //       .toList();
    // }
    await HiveHelper.addSubject(subject.id!, subject);
    log(" llllllllll ${HiveHelper.getAllSubjects().toString()}");

    emit(AppChangeState());
  }

  Future<void> downloadVideo(
    LessonsModel lesson, {
    int? indexDownload,
    required SubjectModel subject,
    // int? indexSubject,
  }) async {
    emit(AppInitialState());
    if (indexDownload != null) {
      set.add(indexDownload);
    } else {
      indexDownload = set.first;
    }

    HiveHelper.cacheManager
        .getFileStream(lesson.videoUrl!, withProgress: true)
        .listen((response) async {
          if (response is DownloadProgress) {
            responseFirebaseClass.progressNotifier.value =
                (response.downloaded) / (response.totalSize ?? 1);
            return;
          }
          await HiveHelper.isDownloaded(lesson.id!, true);
          set.remove(indexDownload);
          emit(AppInitialState());
          responseFirebaseClass.progressNotifier.value = 0;
          if (set.isNotEmpty) {
            indexDownload = set.first;
            downloadVideo(
              subject.lessons![set.first],
              //  indexSubject: indexSubject,
              indexDownload: indexDownload,
              subject: subject,
            );
          }
        })
        .onError((e) {
          return;
        });
  }
}

class ResponseFireBase {
  List<SubjectModel> subjectsList = [];
  List<SubjectModel> subjectsListRoadMap = [];
  ValueNotifier<double> progressNotifier = ValueNotifier(0);

  List<List<SubjectModel>> splitresponseTolevel() {
    List<SubjectModel> level1 = [];
    List<SubjectModel> level2 = [];
    List<SubjectModel> level3 = [];
    for (var subject in subjectsListRoadMap) {
      if (!subject.lock!) {
        subject.index = subjectsListRoadMap.indexOf(subject);
      }
      switch (subject.level) {
        case 0:
          level1.add(subject);
          break;
        case 1:
          level2.add(subject);
          break;
        case 2:
          level3.add(subject);
          break;
      }
    }
    return [level1, level2, level3];
  }

  String getNameByID(String id, String localLanguge) {
    for (var subject in subjectsListRoadMap) {
      if (subject.next == id) {
        return subject.name![localLanguge]!;
      }
    }
    return "";
  }
}
