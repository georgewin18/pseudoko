// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      taskGroupId: fields[1] as int?,
      name: fields[2] as String,
      description: fields[3] as String?,
      attachment: fields[4] as String?,
      progress: fields[5] as int,
      date: fields[6] as DateTime,
      time: fields[7] as TimeOfDay,
      createdAt: fields[8] as DateTime?,
      createdBy: fields[9] as String?,
      updatedAt: fields[10] as DateTime?,
      updatedBy: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskGroupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.attachment)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.time)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeOfDayAdapterAdapter extends TypeAdapter<TimeOfDayAdapter> {
  @override
  final int typeId = 2;

  @override
  TimeOfDayAdapter read(BinaryReader reader) {
    return TimeOfDayAdapter();
  }

  @override
  void write(BinaryWriter writer, TimeOfDayAdapter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
