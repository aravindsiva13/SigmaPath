// lib/models/challenge_model.dart
import 'dart:convert';

class Challenge {
  final String id;
  final String title;
  final String description;
  final int points;
  final bool isCompleted;
  final String category;
  final String difficulty;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isCompleted = false,
    required this.category,
    required this.difficulty,
  });

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    bool? isCompleted,
    String? category,
    String? difficulty,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'isCompleted': isCompleted,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      points: json['points'],
      isCompleted: json['isCompleted'] ?? false,
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }
}
