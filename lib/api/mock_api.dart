import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/utils/constants.dart';

class MockApi {
  final Random _random = Random();
  late SharedPreferences _prefs;
  
  // Singleton pattern
  static final MockApi _instance = MockApi._internal();
  factory MockApi() => _instance;
  MockApi._internal();
  
  // Initialize the app - load or create mock data
  Future<void> initializeApp() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeUser();
    await _initializeChallenges();
    await _initializeRoutines();
    await _initializeFocusSessions();
  }
  
  Future<List<Challenge>> getChallenges() async {
    final challengesData = _prefs.getString(Constants.challengesKey);
    if (challengesData != null) {
      final List<dynamic> decoded = jsonDecode(challengesData);
      return decoded.map((data) => Challenge.fromJson(data)).toList();
    }
    return [];
  }
  
  Future<void> updateChallenge(Challenge challenge) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challenge.id);
    
    if (index != -1) {
      challenges[index] = challenge;
      await _prefs.setString(Constants.challengesKey, jsonEncode(
        challenges.map((c) => c.toJson()).toList()
      ));
    }
  }
  
  Future<void> startChallenge(String challengeId) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challengeId);
    
    if (index != -1) {
      challenges[index] = challenges[index].copyWith(
        isActive: true,
        startDate: DateTime.now(),
      );
      
      await _prefs.setString(Constants.challengesKey, jsonEncode(
        challenges.map((c) => c.toJson()).toList()
      ));
    }
  }
  
  Future<void> checkInChallenge(String challengeId) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challengeId);
    
    if (index != -1) {
      challenges[index].checkIn();
      
      // Reward points if challenge completed
      if (challenges[index].isCompleted) {
        final user = await getUser();
        final updatedUser = user.copyWith(
          sigmaPoints: user.sigmaPoints + challenges[index].sigmaPoints
        );
        await updateUser(updatedUser);
        
        // Add achievement if it was their first completed challenge
        if (challenges.where((c) => c.isCompleted).length == 1) {
          final achievement = SigmaAchievement(
            id: _generateId(),
            title: 'First Challenge Completed',
            description: 'Successfully completed your first Sigma Challenge.',
            dateEarned: DateTime.now(),
            pointsEarned: 250,
            iconPath: 'assets/images/achievement_challenge.png',
          );
          
          final updatedAchievements = List<SigmaAchievement>.from(user.achievements)
            ..add(achievement);
          
          final userWithAchievement = updatedUser.copyWith(
            achievements: updatedAchievements
          );
          await updateUser(userWithAchievement);
        }
      }
      
      await _prefs.setString(Constants.challengesKey, jsonEncode(
        challenges.map((c) => c.toJson()).toList()
      ));
    }
  }
  
  // Routine Methods
  Future<void> _initializeRoutines() async {
    if (!_prefs.containsKey(Constants.routinesKey)) {
      final routines = Constants.defaultRoutines.map((routineData) {
        final taskList = (routineData['tasks'] as List<Map<String, dynamic>>).map((task) {
          return RoutineTask(
            id: _generateId(),
            time: task['time'],
            activity: task['activity'],
          );
        }).toList();
        
        return Routine(
          id: _generateId(),
          title: routineData['title'],
          description: routineData['description'],
          category: routineData['category'],
          tasks: taskList,
        );
      }).toList();
      
      // Activate one routine for demo
      routines[0] = routines[0].copyWith(isActive: true);
      
      await _prefs.setString(Constants.routinesKey, jsonEncode(
        routines.map((routine) => routine.toJson()).toList()
      ));
    }
  }
  
  Future<List<Routine>> getRoutines() async {
    final routinesData = _prefs.getString(Constants.routinesKey);
    if (routinesData != null) {
      final List<dynamic> decoded = jsonDecode(routinesData);
      return decoded.map((data) => Routine.fromJson(data)).toList();
    }
    return [];
  }
  
  Future<void> updateRoutine(Routine routine) async {
    final routines = await getRoutines();
    final index = routines.indexWhere((r) => r.id == routine.id);
    
    if (index != -1) {
      routines[index] = routine;
      await _prefs.setString(Constants.routinesKey, jsonEncode(
        routines.map((r) => r.toJson()).toList()
      ));
    }
  }
  
  Future<void> addRoutine(Routine routine) async {
    final routines = await getRoutines();
    routines.add(routine);
    
    await _prefs.setString(Constants.routinesKey, jsonEncode(
      routines.map((r) => r.toJson()).toList()
    ));
  }
  
  Future<void> completeRoutine(String routineId) async {
    final routines = await getRoutines();
    final index = routines.indexWhere((r) => r.id == routineId);
    
    if (index != -1) {
      routines[index].completeRoutine();
      
      // Award sigma points
      final user = await getUser();
      final updatedUser = user.copyWith(
        sigmaPoints: user.sigmaPoints + 50 // 50 points per routine completion
      );
      await updateUser(updatedUser);
      
      await _prefs.setString(Constants.routinesKey, jsonEncode(
        routines.map((r) => r.toJson()).toList()
      ));
    }
  }
  
  // Focus Session Methods
  Future<void> _initializeFocusSessions() async {
    if (!_prefs.containsKey(Constants.focusSessionsKey)) {
      // Create some completed sessions for demo
      final sessions = <FocusSession>[
        FocusSession(
          id: _generateId(),
          title: 'Deep Work',
          duration: 90,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 30)),
          isCompleted: true,
        ),
        FocusSession(
          id: _generateId(),
          title: 'Pomodoro',
          duration: 25,
          breakInterval: 25,
          breakDuration: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          startedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
          completedAt: DateTime.now().subtract(const Duration(days: 2, hours: 3, minutes: 45)),
          isCompleted: true,
        ),
      ];
      
      await _prefs.setString(Constants.focusSessionsKey, jsonEncode(
        sessions.map((session) => session.toJson()).toList()
      ));
    }
  }
  
  Future<List<FocusSession>> getFocusSessions() async {
    final sessionsData = _prefs.getString(Constants.focusSessionsKey);
    if (sessionsData != null) {
      final List<dynamic> decoded = jsonDecode(sessionsData);
      return decoded.map((data) => FocusSession.fromJson(data)).toList();
    }
    return [];
  }
  
  Future<void> addFocusSession(FocusSession session) async {
    final sessions = await getFocusSessions();
    sessions.add(session);
    
    await _prefs.setString(Constants.focusSessionsKey, jsonEncode(
      sessions.map((s) => s.toJson()).toList()
    ));
  }
  
  Future<void> completeFocusSession(FocusSession session) async {
    final sessions = await getFocusSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    
    if (index != -1) {
      sessions[index] = session;
      
      // Award sigma points based on duration
      final points = (session.duration / 10).round(); // 1 point per 10 minutes
      final user = await getUser();
      final updatedUser = user.copyWith(
        sigmaPoints: user.sigmaPoints + points
      );
      await updateUser(updatedUser);
      
      await _prefs.setString(Constants.focusSessionsKey, jsonEncode(
        sessions.map((s) => s.toJson()).toList()
      ));
    } else {
      // New session to add
      await addFocusSession(session);
    }
  }
  
  // Helper Methods
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
        _random.nextInt(1000).toString();
  }
  
  // Knowledge Base Methods
  Future<List<Map<String, dynamic>>> getKnowledgeCategories() async {
    // Simply return the constant categories
    return Constants.knowledgeCategories;
  }
  
  Future<List<PersonalityQuestion>> getPersonalityQuestions() async {
    return Constants.personalityQuestions.map((q) => 
      PersonalityQuestion(
        id: q['id'].toString(),
        question: q['question'],
        trait: q['trait'],
      )
    ).toList();
  }
}
  
  // User Methods
  Future<void> _initializeUser() async {
    if (!_prefs.containsKey(Constants.userDataKey)) {
      final user = User(
        id: _generateId(),
        username: 'SigmaUser${_random.nextInt(1000)}',
        email: 'sigma.user@example.com',
        sigmaScore: 78,
        traitScores: {
          'Independence': 85,
          'Social Detachment': 75,
          'Confidence': 80,
          'Mindset': 82,
          'Success Drive': 70,
        },
        sigmaPoints: 1500,
        level: 3,
        daysActive: 27,
        achievements: [
          SigmaAchievement(
            id: _generateId(),
            title: 'Early Adopter',
            description: 'Joined SigmaPath in its early days.',
            dateEarned: DateTime.now().subtract(const Duration(days: 27)),
            pointsEarned: 500,
            iconPath: 'assets/images/achievement_early.png',
          ),
          SigmaAchievement(
            id: _generateId(),
            title: 'First Challenge Completed',
            description: 'Successfully completed your first Sigma Challenge.',
            dateEarned: DateTime.now().subtract(const Duration(days: 14)),
            pointsEarned: 250,
            iconPath: 'assets/images/achievement_challenge.png',
          ),
        ],
      );
      
      await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
    }
  }
  
  Future<User> getUser() async {
    final userData = _prefs.getString(Constants.userDataKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    throw Exception('User not found');
  }
  
  Future<void> updateUser(User user) async {
    await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
  }
  
  Future<Map<String, int>> updatePersonalityTest(List<PersonalityQuestion> answers) async {
    // Calculate scores for each trait
    final Map<String, List<int>> traitAnswers = {};
    for (final question in answers) {
      if (question.answer != null) {
        if (!traitAnswers.containsKey(question.trait)) {
          traitAnswers[question.trait] = [];
        }
        traitAnswers[question.trait]!.add(question.answer!);
      }
    }
    
    // Calculate average score for each trait
    final Map<String, int> traitScores = {};
    traitAnswers.forEach((trait, answers) {
      final sum = answers.reduce((a, b) => a + b);
      final avg = (sum / answers.length * 20).round(); // Scale to 0-100
      traitScores[trait] = avg;
    });
    
    // Update user trait scores
    final User user = await getUser();
    final updatedUser = user.copyWith(traitScores: traitScores);
    await updateUser(updatedUser);
    
    return traitScores;
  }
  
  // Challenge Methods
  Future<void> _initializeChallenges() async {
    if (!_prefs.containsKey(Constants.challengesKey)) {
      final challenges = Constants.defaultChallenges.map((challenge) {
        return Challenge(
          id: _generateId(),
          title: challenge['title'],
          description: challenge['description'],
          duration: challenge['duration'],
          difficulty: challenge['difficulty'],
          sigmaPoints: challenge['sigmaPoints'],
        );
      }).toList();
      
      // Add one active challenge for demo
      final activeChallenge = challenges[0].copyWith(
        isActive: true, 
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        currentStreak: 5,
        longestStreak: 5,
        checkInDates: List.generate(
          5, 
          (i) => DateTime.now().subtract(Duration(days: 5 - i))
        ),
      );
      
      challenges[0] = activeChallenge;
      
      // Add one completed challenge for demo
      final completedChallenge = challenges[1].copyWith(
        isCompleted: true,
        startDate: DateTime.now().subtract(const Duration(days: 14)),
        completionDate: DateTime.now().subtract(const Duration(days: 7)),
        currentStreak: 7,
        longestStreak: 7,
        checkInDates: List.generate(
          7, 
          (i) => DateTime.now().subtract(Duration(days: 14 - i))
        ),