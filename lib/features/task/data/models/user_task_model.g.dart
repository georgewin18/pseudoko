// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTaskAdapter extends TypeAdapter<UserTask> {
  @override
  final int typeId = 4;

  @override
  UserTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTask(
      id: fields[0] as int,
      taskGroupId: fields[1] as int?,
      name: fields[2] as String,
      description: fields[3] as String?,
      progress: fields[4] as int,
      date: fields[5] as DateTime?,
      time: fields[6] as TimeOfDay?,
      createdAt: fields[7] as DateTime?,
      groupName: fields[8] as String,
      myRole: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserTask obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskGroupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.groupName)
      ..writeByte(9)
      ..write(obj.myRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
