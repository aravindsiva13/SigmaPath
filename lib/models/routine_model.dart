// lib/models/routine_model.dart
import 'dart:convert';

class Routine {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<RoutineTask> tasks;
  final bool isActive;
  final int currentStreak;

  Routine({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.tasks,
    this.isActive = false,
    this.currentStreak = 0,
  });

  Routine copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    List<RoutineTask>? tasks,
    bool? isActive,
    int? currentStreak,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      isActive: isActive ?? this.isActive,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'isActive': isActive,
      'currentStreak': currentStreak,
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      tasks: json['tasks'] != null
          ? List<RoutineTask>.from(
              json['tasks'].map((x) => RoutineTask.fromJson(x)))
          : [],
      isActive: json['isActive'] ?? false,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}

class RoutineTask {
  final String id;
  final String activity;
  final int duration;
  final bool completed;

  RoutineTask({
    required this.id,
    required this.activity,
    required this.duration,
    this.completed = false,
  });

  RoutineTask copyWith({
    String? id,
    String? activity,
    int? duration,
    bool? completed,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      duration: duration ?? this.duration,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'duration': duration,
      'completed': completed,
    };
  }

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
      id: json['id'],
      activity: json['activity'],
      duration: json['duration'],
      completed: json['completed'] ?? false,
    );
  }
}
