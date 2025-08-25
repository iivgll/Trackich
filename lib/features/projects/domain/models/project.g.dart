// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      targetHoursPerWeek:
          (json['targetHoursPerWeek'] as num?)?.toDouble() ?? 0.0,
      totalTimeTracked: (json['totalTimeTracked'] as num?)?.toDouble() ?? 0.0,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': const ColorConverter().toJson(instance.color),
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
      'tags': instance.tags,
      'targetHoursPerWeek': instance.targetHoursPerWeek,
      'totalTimeTracked': instance.totalTimeTracked,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
    };
