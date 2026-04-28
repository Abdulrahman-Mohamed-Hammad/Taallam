// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_subject-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectModelAdapter extends TypeAdapter<SubjectModel> {
  @override
  final int typeId = 0;

  @override
  SubjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectModel(
        id: fields[0] as String?,
        name: (fields[1] as Map?)?.cast<String, String>(),
        lessonsCount: fields[2] as int?,
        image: fields[3] as String?,
        lock: fields[4] as bool?,
        next: fields[5] as String?,
        level: fields[6] as int?,
      )
      ..progress = fields[7] as int?
      ..isCompleted = fields[8] as bool?
      ..lessons = (fields[9] as List?)?.cast<LessonsModel>();
  }

  @override
  void write(BinaryWriter writer, SubjectModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lessonsCount)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.lock)
      ..writeByte(5)
      ..write(obj.next)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.progress)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LessonsModelAdapter extends TypeAdapter<LessonsModel> {
  @override
  final int typeId = 1;

  @override
  LessonsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonsModel(
        id: fields[0] as String?,
        name: (fields[1] as Map?)?.cast<String, String>(),
        videoUrl: fields[2] as String?,
      )
      ..description = (fields[3] as Map?)?.cast<String, String>()
      ..examples = (fields[4] as Map?)?.cast<String, String>()
      ..isCompleted = fields[5] as bool
      ..practes = (fields[6] as List?)?.cast<PractesModel>();
  }

  @override
  void write(BinaryWriter writer, LessonsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.videoUrl)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.examples)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.practes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PractesModelAdapter extends TypeAdapter<PractesModel> {
  @override
  final int typeId = 2;

  @override
  PractesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PractesModel(
      id: fields[0] as String?,
      questionText: (fields[2] as Map?)?.cast<String, String>(),
      choices: (fields[3] as List?)?.cast<dynamic>(),
      correctAnswer: fields[1] as String?,
      stepAnswer: (fields[4] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PractesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.correctAnswer)
      ..writeByte(2)
      ..write(obj.questionText)
      ..writeByte(3)
      ..write(obj.choices)
      ..writeByte(4)
      ..write(obj.stepAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PractesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
