import 'dart:convert';

import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';

class KeysHive {
  static const String subjectsHive = "Subjects";
  static const String downloadedVideoHive = "downloadedVideo";
}

class HiveHelper {
  // static ValueNotifier<bool> isOnline = ValueNotifier(true);

  static late Box _subjectbox;
  static late Box _isdownloadedVideobox;
  static late DefaultCacheManager cacheManager;

  static List<String> listSubject = [];
  static Future<void> initilizeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SubjectModelAdapter());
    Hive.registerAdapter(LessonsModelAdapter());
    Hive.registerAdapter(PractesModelAdapter());
  }

  // static initilizeIsonlie() async {
  //   listinerMethod();
  //   isOnline.value = await checkInternet();
  // }

  // static listinerMethod() {
  //   isOnline.addListener(() {
  //     log("isOnlineChange ${isOnline.value}");
  //   });
  // }

  static void initilizeDefualtCasheManger() {
    cacheManager = DefaultCacheManager();
  }

  static Future<void> openAllboxs() async {
    // await Hive.deleteBoxFromDisk(KeysHive.subjectsHive);
    _subjectbox = await Hive.openBox(KeysHive.subjectsHive);
    _isdownloadedVideobox = await Hive.openBox(KeysHive.downloadedVideoHive);
  }

  static Future<void> addSubject(String key, SubjectModel subject) async {
    await _subjectbox.put(key, subject);
  }

  static Future<void> isDownloaded(String key, bool value) async {
    await _isdownloadedVideobox.put(key, value);
  }

  static bool? getisDownloaded(String key) {
    return _isdownloadedVideobox.get(key);
  }

  static Future<SubjectModel?> getSubject(String key) async {
    return await _subjectbox.get(key);
  }

  static List<SubjectModel> getAllSubjects() {
    return _subjectbox.values.cast<SubjectModel>().toList();
  }

  static String convertListToString(List<String> list) {
    return jsonEncode(list);
  }

  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('firebase.google.com');
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

class SubjectDatabase {}
