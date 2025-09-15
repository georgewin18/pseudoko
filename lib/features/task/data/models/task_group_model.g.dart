// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskGroupAdapter extends TypeAdapter<TaskGroup> {
  @override
  final int typeId = 0;

  @override
  TaskGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskGroup(
      id: fields[0] as int,
      name: fields[1] as String,
      ownerId: fields[2] as String?,
      description: fields[3] as String?,
      notStartedCount: fields[4] as int,
      ongoingCount: fields[5] as int,
      completedCount: fields[6] as int,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      updatedBy: fields[9] as String?,
      myRole: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskGroup obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ownerId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.notStartedCount)
      ..writeByte(5)
      ..write(obj.ongoingCount)
      ..writeByte(6)
      ..write(obj.completedCount)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.updatedBy)
      ..writeByte(10)
      ..write(obj.myRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
