// lib/models/focus_session_model.dart
import 'dart:convert';

class FocusSession {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final int points;

  FocusSession({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.points = 0,
  });

  FocusSession copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    int? points,
  }) {
    return FocusSession(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'points': points,
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isCompleted: json['isCompleted'] ?? false,
      points: json['points'] ?? 0,
    );
  }
}
