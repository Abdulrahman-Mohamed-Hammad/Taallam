import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_app/generated/lib/generated/locale_keys.g.dart';
part 'add_subject-model.g.dart';

abstract class TheMainModel {
  String? id;
  TheMainModel(this.id);
  Map<String, dynamic> toJson();
}

@HiveType(typeId: 0)
class SubjectModel extends TheMainModel {
  @override
  @HiveField(0)
  String? id;
  @HiveField(1)
  Map<String, String>? name;
  @HiveField(2)
  int? lessonsCount;
  @HiveField(3)
  String? image;
  @HiveField(4)
  bool? lock;
  @HiveField(5)
  String? next;
  @HiveField(6)
  int? level;
  @HiveField(7)
  int? progress;
  @HiveField(8)
  bool? isCompleted;
  @HiveField(9)
  List<LessonsModel>? lessons;
  int? index;
  SubjectModel({
    this.id,
    this.name,
    this.lessonsCount,
    this.image,
    this.lock,
    this.next,
    this.level,
  }) : super(id);
  SubjectModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'] != null
          ? Map<String, String>.from(json['name'])
          : null,
      lessonsCount = json['lessonsCount'],
      image = json['image'],
      lock = json['lock'],
      next = json['next'],
      level = json['level'],
      //  isCompleted = json['isCompleted'],
      //  progress = json['progress'],
      super(json['id']);

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "progress": progress,
      "lessonsCount": lessonsCount,
      "image": image,
      "next": next,
      "lock": lock,
      "level": level,
      "isCompleted": isCompleted,
    };
  }

  String gelevelArabic(int levels) {
    switch (level) {
      case 0:
        return LocaleKeys.beginner_level_ll.tr();
      case 1:
        return LocaleKeys.intermediate_level_ll.tr();
      case 2:
        return LocaleKeys.advanced_level_ll.tr();
      default:
        return LocaleKeys.beginner_level_ll.tr();
    }
  }

  void updateProgress(Map<String, dynamic> json) {
    lock = json['isLock'];
    progress = json['progress'];
    isCompleted = json['isCompleted'];
  }
}

@HiveType(typeId: 1)
class LessonsModel extends TheMainModel {
  @override
  @HiveField(0)
  String? id;
  @HiveField(1)
  Map<String, String>? name;
  @HiveField(2)
  String? videoUrl;
  @HiveField(3)
  Map<String, String>? description;
  @HiveField(4)
  Map<String, String>? examples;
  @HiveField(5)
  bool isCompleted = false;

  @HiveField(6)
  List<PractesModel>? practes;

  LessonsModel({this.id, this.name, this.videoUrl}) : super(id);
  LessonsModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'] != null
          ? Map<String, String>.from(json['name'])
          : null,
      videoUrl = json['videoUrl'],
      description = json['description'] != null
          ? Map<String, String>.from(json['description'])
          : null,
      examples = json['examples'] != null
          ? Map<String, String>.from(json['examples'])
          : null,
      isCompleted = json['isCompleted'],
      super(json['id']);
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "videoUrl": videoUrl,
      "description": description,
      "examples": examples,
      "isCompleted": isCompleted,
    };
  }

  void updateProgress(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
  }
}

@HiveType(typeId: 2)
class PractesModel extends TheMainModel {
  @override
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? correctAnswer;
  @HiveField(2)
  Map<String, String>? questionText;
  @HiveField(3)
  List<dynamic>? choices;
  @HiveField(4)
  Map<String, String>? stepAnswer;

  PractesModel({
    this.id,
    this.questionText,
    this.choices,
    this.correctAnswer,
    this.stepAnswer,
  }) : super(id);
  PractesModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      questionText = json['questionText'] != null
          ? Map<String, String>.from(json['questionText'])
          : null,
      choices = json['choices'],
      correctAnswer = json['correctAnswer'],
      stepAnswer = json['stepAnswer'] != null
          ? Map<String, String>.from(json['stepAnswer'])
          : null,
      super(json['id']);
  @override
  Map<String, dynamic> toJson() {
    return {
      "questionText": questionText,
      "choices": choices,
      "correctAnswer": correctAnswer,
      "stepAnswer": stepAnswer,
    };
  }
}
