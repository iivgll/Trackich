// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  color: const ColorConverter().fromJson((json['color'] as num).toInt()),
  isArchived: json['isArchived'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'color': const ColorConverter().toJson(instance.color),
  'isArchived': instance.isArchived,
  'createdAt': instance.createdAt?.toIso8601String(),
  'archivedAt': instance.archivedAt?.toIso8601String(),
};
