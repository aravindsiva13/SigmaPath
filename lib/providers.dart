import 'package:flutter/foundation.dart';
import 'package:sigma_path/models/app_models.dart';

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
