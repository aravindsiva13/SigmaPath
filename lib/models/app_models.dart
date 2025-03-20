import 'dart:convert';
import 'package:flutter/foundation.dart';

// User Model
class User {
  final String id;
  final String username;
  final String email;
  final int sigmaScore;
  final Map<String, int> traitScores;
  final int sigmaPoints;
  final int level;
  final int daysActive;
  final List<SigmaAchievement> achievements;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.sigmaScore,
    required this.traitScores,
    required this.sigmaPoints,
    required this.level,
    required this.daysActive,
    required this.achievements,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    int? sigmaScore,
    Map<String, int>? traitScores,
    int? sigmaPoints,
    int? level,
    int? daysActive,
    List<SigmaAchievement>? achievements,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      sigmaScore: sigmaScore ?? this.sigmaScore,
      traitScores: traitScores ?? this.traitScores,
      sigmaPoints: sigmaPoints ?? this.sigmaPoints,
      level: level ?? this.level,
      daysActive: daysActive ?? this.daysActive,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'sigmaScore': sigmaScore,
      'traitScores': traitScores,
      'sigmaPoints': sigmaPoints,
      'level': level,
      'daysActive': daysActive,
      'achievements': achievements.map((a) => a.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      sigmaScore: json['sigmaScore'],
      traitScores: Map<String, int>.from(json['traitScores']),
      sigmaPoints: json['sigmaPoints'],
      level: json['level'],
      daysActive: json['daysActive'],
      achievements: (json['achievements'] as List)
          .map((a) => SigmaAchievement.fromJson(a))
          .toList(),
    );
  }
}

// Achievement Model
class SigmaAchievement {
  final String id;
  final String title;
  final String description;
  final DateTime dateEarned;
  final int pointsEarned;
  final String iconPath;

  SigmaAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.dateEarned,
    required this.pointsEarned,
    required this.iconPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateEarned': dateEarned.toIso8601String(),
      'pointsEarned': pointsEarned,
      'iconPath': iconPath,
    };
  }

  factory SigmaAchievement.fromJson(Map<String, dynamic> json) {
    return SigmaAchievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateEarned: DateTime.parse(json['dateEarned']),
      pointsEarned: json['pointsEarned'],
      iconPath: json['iconPath'],
    );
  }
}

// Challenge Model
class Challenge {
  final String id;
  final String title;
  final String description;
  final int duration;
  final int difficulty;
  final int sigmaPoints;
  bool isActive;
  bool isCompleted;
  DateTime? startDate;
  DateTime? completionDate;
  int currentStreak;
  int longestStreak;
  List<DateTime> checkInDates;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.sigmaPoints,
    this.isActive = false,
    this.isCompleted = false,
    this.startDate,
    this.completionDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.checkInDates = const [],
  });

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    int? difficulty,
    int? sigmaPoints,
    bool? isActive,
    bool? isCompleted,
    DateTime? startDate,
    DateTime? completionDate,
    int? currentStreak,
    int? longestStreak,
    List<DateTime>? checkInDates,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      sigmaPoints: sigmaPoints ?? this.sigmaPoints,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      checkInDates: checkInDates ?? this.checkInDates,
    );
  }

  void checkIn() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if already checked in today
    if (checkInDates.isNotEmpty) {
      final lastCheckIn = checkInDates.last;
      final lastCheckInDate =
          DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);

      if (lastCheckInDate.isAtSameMomentAs(todayDate)) {
        return; // Already checked in today
      }

      // Check if consecutive days
      final yesterday = todayDate.subtract(const Duration(days: 1));
      final yesterdayDate =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      if (lastCheckInDate.isAtSameMomentAs(yesterdayDate)) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        // Streak broken
        currentStreak = 1;
      }
    } else {
      // First check-in
      currentStreak = 1;
      longestStreak = 1;
    }

    checkInDates.add(todayDate);

    // Check if challenge is completed
    if (checkInDates.length >= duration) {
      isCompleted = true;
      completionDate = todayDate;
      isActive = false;
    }
  }

  bool canCheckInToday() {
    if (isCompleted || !isActive) return false;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (checkInDates.isEmpty) return true;

    final lastCheckIn = checkInDates.last;
    final lastCheckInDate =
        DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);

    return !lastCheckInDate.isAtSameMomentAs(todayDate);
  }

  double get progressPercentage =>
      duration == 0 ? 0 : (checkInDates.length / duration) * 100;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'sigmaPoints': sigmaPoints,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'startDate': startDate?.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'checkInDates':
          checkInDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      sigmaPoints: json['sigmaPoints'],
      isActive: json['isActive'],
      isCompleted: json['isCompleted'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      checkInDates: json['checkInDates'] != null
          ? (json['checkInDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
    );
  }
}

// Routine Model
class RoutineTask {
  final String id;
  final String time;
  final String activity;
  bool isCompleted;

  RoutineTask({
    required this.id,
    required this.time,
    required this.activity,
    this.isCompleted = false,
  });

  RoutineTask copyWith({
    String? id,
    String? time,
    String? activity,
    bool? isCompleted,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      time: time ?? this.time,
      activity: activity ?? this.activity,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'activity': activity,
      'isCompleted': isCompleted,
    };
  }

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    return RoutineTask(
      id: json['id'],
      time: json['time'],
      activity: json['activity'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class Routine {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<RoutineTask> tasks;
  final List<String> weekdays;
  bool isActive;
  int completionCount;
  int currentStreak;
  int longestStreak;
  List<DateTime> completionDates;

  Routine({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tasks,
    this.weekdays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.isActive = false,
    this.completionCount = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completionDates = const [],
  });

  Routine copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<RoutineTask>? tasks,
    List<String>? weekdays,
    bool? isActive,
    int? completionCount,
    int? currentStreak,
    int? longestStreak,
    List<DateTime>? completionDates,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tasks: tasks ?? this.tasks,
      weekdays: weekdays ?? this.weekdays,
      isActive: isActive ?? this.isActive,
      completionCount: completionCount ?? this.completionCount,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completionDates: completionDates ?? this.completionDates,
    );
  }

  void completeTask(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index] = tasks[index].copyWith(isCompleted: true);
    }
  }

  void resetTasks() {
    for (var i = 0; i < tasks.length; i++) {
      tasks[i] = tasks[i].copyWith(isCompleted: false);
    }
  }

  bool get isCompleted => tasks.every((task) => task.isCompleted);

  double get progressPercentage {
    if (tasks.isEmpty) return 0;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    return (completedCount / tasks.length) * 100;
  }

  void completeRoutine() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if already completed today
    if (completionDates.isNotEmpty) {
      final lastCompletion = completionDates.last;
      final lastCompletionDate = DateTime(
          lastCompletion.year, lastCompletion.month, lastCompletion.day);

      if (lastCompletionDate.isAtSameMomentAs(todayDate)) {
        return; // Already completed today
      }

      // Check if consecutive days
      final yesterday = todayDate.subtract(const Duration(days: 1));
      final yesterdayDate =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      if (lastCompletionDate.isAtSameMomentAs(yesterdayDate)) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        // Streak broken
        currentStreak = 1;
      }
    } else {
      // First completion
      currentStreak = 1;
      longestStreak = 1;
    }

    completionDates.add(todayDate);
    completionCount++;
    resetTasks();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'weekdays': weekdays,
      'isActive': isActive,
      'completionCount': completionCount,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completionDates':
          completionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      tasks: (json['tasks'] as List)
          .map((task) => RoutineTask.fromJson(task))
          .toList(),
      weekdays: List<String>.from(json['weekdays'] ?? []),
      isActive: json['isActive'] ?? false,
      completionCount: json['completionCount'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      completionDates: json['completionDates'] != null
          ? (json['completionDates'] as List)
              .map((date) => DateTime.parse(date))
              .toList()
          : [],
    );
  }
}

// Focus Session Model
class FocusSession {
  final String id;
  final String title;
  final int duration;
  final int breakInterval;
  final int breakDuration;
  final DateTime createdAt;
  DateTime? startedAt;
  DateTime? completedAt;
  bool isCompleted;
  List<String> blockedWebsites;

  FocusSession({
    required this.id,
    required this.title,
    required this.duration,
    this.breakInterval = 0,
    this.breakDuration = 0,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.isCompleted = false,
    this.blockedWebsites = const [],
  });

  FocusSession copyWith({
    String? id,
    String? title,
    int? duration,
    int? breakInterval,
    int? breakDuration,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
    List<String>? blockedWebsites,
  }) {
    return FocusSession(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      breakInterval: breakInterval ?? this.breakInterval,
      breakDuration: breakDuration ?? this.breakDuration,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      blockedWebsites: blockedWebsites ?? this.blockedWebsites,
    );
  }

  void start() {
    startedAt = DateTime.now();
  }

  void complete() {
    completedAt = DateTime.now();
    isCompleted = true;
  }

  int get actualDurationMinutes {
    if (startedAt == null || completedAt == null) return 0;
    return completedAt!.difference(startedAt!).inMinutes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'breakInterval': breakInterval,
      'breakDuration': breakDuration,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'blockedWebsites': blockedWebsites,
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      breakInterval: json['breakInterval'] ?? 0,
      breakDuration: json['breakDuration'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      startedAt:
          json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      blockedWebsites: List<String>.from(json['blockedWebsites'] ?? []),
    );
  }
}

// Personality Test Question Model
class PersonalityQuestion {
  final String id;
  final String question;
  final String trait;
  int? answer; // 1-5 scale

  PersonalityQuestion({
    required this.id,
    required this.question,
    required this.trait,
    this.answer,
  });

  PersonalityQuestion copyWith({
    String? id,
    String? question,
    String? trait,
    int? answer,
  }) {
    return PersonalityQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      trait: trait ?? this.trait,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'trait': trait,
      'answer': answer,
    };
  }

  factory PersonalityQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalityQuestion(
      id: json['id'],
      question: json['question'],
      trait: json['trait'],
      answer: json['answer'],
    );
  }
}

// Knowledge Article Model
class KnowledgeArticle {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final List<String> tags;
  bool isFavorite;
  bool isRead;

  KnowledgeArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.tags,
    this.isFavorite = false,
    this.isRead = false,
  });

  KnowledgeArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? publishedAt,
    int? readTimeMinutes,
    List<String>? tags,
    bool? isFavorite,
    bool? isRead,
  }) {
    return KnowledgeArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      publishedAt: publishedAt ?? this.publishedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'publishedAt': publishedAt.toIso8601String(),
      'readTimeMinutes': readTimeMinutes,
      'tags': tags,
      'isFavorite': isFavorite,
      'isRead': isRead,
    };
  }

  factory KnowledgeArticle.fromJson(Map<String, dynamic> json) {
    return KnowledgeArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      publishedAt: DateTime.parse(json['publishedAt']),
      readTimeMinutes: json['readTimeMinutes'],
      tags: List<String>.from(json['tags']),
      isFavorite: json['isFavorite'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }
}

// Provider classes
class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateSigmaPoints(int points) {
    if (_user != null) {
      _user = _user!.copyWith(sigmaPoints: _user!.sigmaPoints + points);
      notifyListeners();
    }
  }

  void incrementLevel() {
    if (_user != null) {
      _user = _user!.copyWith(level: _user!.level + 1);
      notifyListeners();
    }
  }

  void addAchievement(SigmaAchievement achievement) {
    if (_user != null) {
      final updatedAchievements =
          List<SigmaAchievement>.from(_user!.achievements)..add(achievement);
      _user = _user!.copyWith(achievements: updatedAchievements);
      notifyListeners();
    }
  }

  void updateTraitScores(Map<String, int> newScores) {
    if (_user != null) {
      final updatedTraitScores = Map<String, int>.from(_user!.traitScores);
      newScores.forEach((key, value) {
        updatedTraitScores[key] = value;
      });

      // Recalculate sigma score (average of all traits)
      final newSigmaScore = updatedTraitScores.values.reduce((a, b) => a + b) ~/
          updatedTraitScores.length;

      _user = _user!.copyWith(
        traitScores: updatedTraitScores,
        sigmaScore: newSigmaScore,
      );
      notifyListeners();
    }
  }
}

class ChallengeProvider with ChangeNotifier {
  List<Challenge> _challenges = [];

  List<Challenge> get challenges => _challenges;
  List<Challenge> get activeChallenges =>
      _challenges.where((challenge) => challenge.isActive).toList();
  List<Challenge> get completedChallenges =>
      _challenges.where((challenge) => challenge.isCompleted).toList();
  List<Challenge> get availableChallenges => _challenges
      .where((challenge) => !challenge.isActive && !challenge.isCompleted)
      .toList();

  void setChallenges(List<Challenge> challenges) {
    _challenges = challenges;
    notifyListeners();
  }

  void addChallenge(Challenge challenge) {
    _challenges.add(challenge);
    notifyListeners();
  }

  void updateChallenge(Challenge updatedChallenge) {
    final index = _challenges.indexWhere((c) => c.id == updatedChallenge.id);
    if (index != -1) {
      _challenges[index] = updatedChallenge;
      notifyListeners();
    }
  }

  void startChallenge(String challengeId) {
    final index = _challenges.indexWhere((c) => c.id == challengeId);
    if (index != -1) {
      _challenges[index] = _challenges[index].copyWith(
        isActive: true,
        startDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void checkInChallenge(String challengeId) {
    final index = _challenges.indexWhere((c) => c.id == challengeId);
    if (index != -1) {
      _challenges[index].checkIn();
      notifyListeners();
    }
  }
}

class RoutineProvider with ChangeNotifier {
  List<Routine> _routines = [];

  List<Routine> get routines => _routines;
  List<Routine> get activeRoutines =>
      _routines.where((routine) => routine.isActive).toList();

  void setRoutines(List<Routine> routines) {
    _routines = routines;
    notifyListeners();
  }

  void addRoutine(Routine routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void updateRoutine(Routine updatedRoutine) {
    final index = _routines.indexWhere((r) => r.id == updatedRoutine.id);
    if (index != -1) {
      _routines[index] = updatedRoutine;
      notifyListeners();
    }
  }

  void activateRoutine(String routineId, bool activate) {
    final index = _routines.indexWhere((r) => r.id == routineId);
    if (index != -1) {
      _routines[index] = _routines[index].copyWith(isActive: activate);
      notifyListeners();
    }
  }

  void completeRoutineTask(String routineId, String taskId) {
    final index = _routines.indexWhere((r) => r.id == routineId);
    if (index != -1) {
      _routines[index].completeTask(taskId);

      // Check if routine is completed
      if (_routines[index].isCompleted) {
        _routines[index].completeRoutine();
      }

      notifyListeners();
    }
  }
}

class FocusSessionProvider with ChangeNotifier {
  List<FocusSession> _sessions = [];
  FocusSession? _activeSession;

  List<FocusSession> get sessions => _sessions;
  FocusSession? get activeSession => _activeSession;
  List<FocusSession> get completedSessions =>
      _sessions.where((session) => session.isCompleted).toList();

  void setSessions(List<FocusSession> sessions) {
    _sessions = sessions;
    notifyListeners();
  }

  void addSession(FocusSession session) {
    _sessions.add(session);
    notifyListeners();
  }

  void startSession(FocusSession session) {
    session.start();
    _activeSession = session;
    _sessions.add(session);
    notifyListeners();
  }

  void completeActiveSession() {
    if (_activeSession != null) {
      _activeSession!.complete();

      // Find and update in the sessions list
      final index = _sessions.indexWhere((s) => s.id == _activeSession!.id);
      if (index != -1) {
        _sessions[index] = _activeSession!;
      }

      _activeSession = null;
      notifyListeners();
    }
  }

  void cancelActiveSession() {
    if (_activeSession != null) {
      // Remove from sessions list if not yet completed
      _sessions.removeWhere((s) => s.id == _activeSession!.id);
      _activeSession = null;
      notifyListeners();
    }
  }

  int get totalFocusMinutes {
    return completedSessions.fold<int>(
        0, (sum, session) => sum + session.actualDurationMinutes);
  }

  int get sessionsToday {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return completedSessions.where((session) {
      if (session.completedAt == null) return false;
      return session.completedAt!.isAfter(todayStart);
    }).length;
  }
}
