// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryImpl _$$TimeEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      taskName: json['taskName'] as String,
      description: json['description'] as String? ?? '',
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: const DurationConverter().fromJson(
        (json['duration'] as num).toInt(),
      ),
      totalAccumulatedTime: json['totalAccumulatedTime'] == null
          ? Duration.zero
          : const DurationConverter().fromJson(
              (json['totalAccumulatedTime'] as num).toInt(),
            ),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isBreak: json['isBreak'] as bool? ?? false,
      breakType: json['breakType'] == null
          ? null
          : BreakType.fromJson(json['breakType'] as Map<String, dynamic>),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TimeEntryImplToJson(_$TimeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'taskName': instance.taskName,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': const DurationConverter().toJson(instance.duration),
      'totalAccumulatedTime': const DurationConverter().toJson(
        instance.totalAccumulatedTime,
      ),
      'tags': instance.tags,
      'isBreak': instance.isBreak,
      'breakType': instance.breakType,
      'isCompleted': instance.isCompleted,
    };

_$ShortBreakImpl _$$ShortBreakImplFromJson(Map<String, dynamic> json) =>
    _$ShortBreakImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$ShortBreakImplToJson(_$ShortBreakImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

_$LongBreakImpl _$$LongBreakImplFromJson(Map<String, dynamic> json) =>
    _$LongBreakImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$LongBreakImplToJson(_$LongBreakImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

_$CustomBreakImpl _$$CustomBreakImplFromJson(Map<String, dynamic> json) =>
    _$CustomBreakImpl(
      name: json['name'] as String,
      duration: const DurationConverter().fromJson(
        (json['duration'] as num).toInt(),
      ),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CustomBreakImplToJson(_$CustomBreakImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': const DurationConverter().toJson(instance.duration),
      'runtimeType': instance.$type,
    };
