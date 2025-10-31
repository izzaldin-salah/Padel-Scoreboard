// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchResultAdapter extends TypeAdapter<MatchResult> {
  @override
  final int typeId = 0;

  @override
  MatchResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchResult(
      teamAName: fields[0] as String,
      teamBName: fields[1] as String,
      teamAScore: fields[2] as int,
      teamBScore: fields[3] as int,
      winningTeam: fields[4] as String,
      date: fields[5] as DateTime,
      durationInSeconds: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MatchResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.teamAName)
      ..writeByte(1)
      ..write(obj.teamBName)
      ..writeByte(2)
      ..write(obj.teamAScore)
      ..writeByte(3)
      ..write(obj.teamBScore)
      ..writeByte(4)
      ..write(obj.winningTeam)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.durationInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
