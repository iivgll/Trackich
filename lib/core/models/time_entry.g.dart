// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => TimeEntry(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  taskName: json['taskName'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
  notes: json['notes'] as String?,
  isBreak: json['isBreak'] as bool? ?? false,
  breakType: $enumDecodeNullable(_$BreakTypeEnumMap, json['breakType']),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$TimeEntryToJson(TimeEntry instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'taskName': instance.taskName,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'duration': instance.duration?.inMicroseconds,
  'notes': instance.notes,
  'isBreak': instance.isBreak,
  'breakType': _$BreakTypeEnumMap[instance.breakType],
  'tags': instance.tags,
};

const _$BreakTypeEnumMap = {
  BreakType.short: 'short',
  BreakType.long: 'long',
  BreakType.custom: 'custom',
  BreakType.lunch: 'lunch',
};
