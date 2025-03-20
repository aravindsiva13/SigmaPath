// lib/models/user_model.dart
import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final int sigmaPoints;
  final int level;
  final List<Trait> traits;
  final String personalityType;

  UserModel({
    required this.id,
    required this.username,
    this.sigmaPoints = 0,
    this.level = 1,
    this.traits = const [],
    this.personalityType = 'Undetermined',
  });

  UserModel copyWith({
    String? id,
    String? username,
    int? sigmaPoints,
    int? level,
    List<Trait>? traits,
    String? personalityType,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      sigmaPoints: sigmaPoints ?? this.sigmaPoints,
      level: level ?? this.level,
      traits: traits ?? this.traits,
      personalityType: personalityType ?? this.personalityType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'sigmaPoints': sigmaPoints,
      'level': level,
      'traits': traits.map((trait) => trait.toJson()).toList(),
      'personalityType': personalityType,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      sigmaPoints: json['sigmaPoints'] ?? 0,
      level: json['level'] ?? 1,
      traits: json['traits'] != null
          ? List<Trait>.from(json['traits'].map((x) => Trait.fromJson(x)))
          : [],
      personalityType: json['personalityType'] ?? 'Undetermined',
    );
  }
}

class Trait {
  final String id;
  final String name;
  final int score;
  final String description;

  Trait({
    required this.id,
    required this.name,
    this.score = 50,
    required this.description,
  });

  Trait copyWith({
    String? id,
    String? name,
    int? score,
    String? description,
  }) {
    return Trait(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'description': description,
    };
  }

  factory Trait.fromJson(Map<String, dynamic> json) {
    return Trait(
      id: json['id'],
      name: json['name'],
      score: json['score'] ?? 50,
      description: json['description'] ?? '',
    );
  }
}
