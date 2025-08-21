import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.isArchived = false,
    this.createdAt,
    this.archivedAt,
  });

  final String id;
  final String name;
  final String description;
  @ColorConverter()
  final Color color;
  final bool isArchived;
  final DateTime? createdAt;
  final DateTime? archivedAt;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  Project copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? archivedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project{id: $id, name: $name, description: $description, '
        'color: $color, isArchived: $isArchived, createdAt: $createdAt, '
        'archivedAt: $archivedAt}';
  }
}

/// JSON converter for Color objects
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}