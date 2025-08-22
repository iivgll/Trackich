import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String description,
    @ColorConverter() required Color color,
    required DateTime createdAt,
    @Default(true) bool isActive,
    @Default([]) List<String> tags,
    @Default(0.0) double targetHoursPerWeek,
    @Default(0.0) double totalTimeTracked, // in hours
    DateTime? lastActiveAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

// Custom converter for Color to/from JSON
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}