// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupMemberAdapter extends TypeAdapter<GroupMember> {
  @override
  final int typeId = 3;

  @override
  GroupMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupMember(
      groupId: fields[0] as int,
      userId: fields[1] as String,
      username: fields[2] as String,
      role: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GroupMember obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.groupId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
