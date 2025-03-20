// import 'dart:convert';
// import 'dart:math';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sigma_path/models/user_model.dart';
// import 'package:sigma_path/models/challenge_model.dart';
// import 'package:sigma_path/models/routine_model.dart';
// import 'package:sigma_path/models/focus_session_model.dart';
// import 'package:sigma_path/models/knowledge_model.dart';
// import 'package:sigma_path/utils/constants.dart';

// class MockApi {
//   late SharedPreferences _prefs;
//   final Random _random = Random();

//   MockApi() {
//     _initPrefs();
//   }

//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   // Method for app initialization
//   Future<void> initializeApp() async {
//     await _initPrefs();
//     await _initializeUser();
//     await _initializeChallenges();
//     await _initializeRoutines();
//     await _initializeFocusSessions();
//     await _initializeKnowledgeBase();
//   }

//   String _generateId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }

//   // User methods
//   Future<UserModel> getUser() async {
//     final userData = _prefs.getString(Constants.userDataKey);
//     if (userData != null) {
//       return UserModel.fromJson(jsonDecode(userData));
//     }
//     return await _initializeUser();
//   }

//   Future<UserModel> _initializeUser() async {
//     if (!_prefs.containsKey(Constants.userDataKey)) {
//       final user = UserModel(
//         id: _generateId(),
//         username: 'SigmaUser${_random.nextInt(1000)}',
//         sigmaPoints: 0,
//         level: 1,
//         traits: [
//           Trait(
//             id: _generateId(),
//             name: 'Discipline',
//             score: 50,
//             description: 'Ability to maintain focus and adhere to routines',
//           ),
//           Trait(
//             id: _generateId(),
//             name: 'Leadership',
//             score: 40,
//             description: 'Skill in guiding and motivating others',
//           ),
//         ],
//         personalityType: 'Undetermined',
//       );

//       await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
//       return user;
//     }

//     final userData = _prefs.getString(Constants.userDataKey);
//     if (userData != null) {
//       return UserModel.fromJson(jsonDecode(userData));
//     }

//     // Default user if something went wrong
//     return UserModel(
//       id: 'default',
//       username: 'DefaultUser',
//       sigmaPoints: 0,
//       level: 1,
//       traits: [],
//       personalityType: 'Undetermined',
//     );
//   }

//   Future<void> updateUser(UserModel user) async {
//     await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
//   }

//   // Challenge methods
//   Future<List<Challenge>> getChallenges() async {
//     await _initializeChallenges();

//     final challengesJson = _prefs.getString(Constants.challengesKey);
//     if (challengesJson != null) {
//       final List<dynamic> decoded = jsonDecode(challengesJson);
//       return decoded.map((item) => Challenge.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeChallenges() async {
//     if (!_prefs.containsKey(Constants.challengesKey)) {
//       final challenges = [
//         Challenge(
//           id: _generateId(),
//           title: 'Early Riser',
//           description: 'Wake up at 5 AM for 7 consecutive days',
//           points: 100,
//           isCompleted: false,
//           category: 'Discipline',
//           difficulty: 'Medium',
//         ),
//         Challenge(
//           id: _generateId(),
//           title: 'Cold Shower Master',
//           description: 'Take cold showers for 14 consecutive days',
//           points: 150,
//           isCompleted: false,
//           category: 'Discipline',
//           difficulty: 'Hard',
//         ),
//       ];

//       // Example of completing a challenge
//       final completedChallenge = challenges[1].copyWith(isCompleted: true);

//       // Update challenges array with completed one
//       challenges[1] = completedChallenge;

//       // Save to preferences
//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));
//     }
//   }

//   Future<void> updateChallenge(Challenge challenge) async {
//     final challenges = await getChallenges();
//     final index = challenges.indexWhere((c) => c.id == challenge.id);

//     if (index != -1) {
//       challenges[index] = challenge;
//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));
//     }
//   }

//   // Method for checking in to a challenge (tracking progress)
//   Future<void> checkInChallenge(String challengeId) async {
//     final challenges = await getChallenges();
//     final index = challenges.indexWhere((c) => c.id == challengeId);

//     if (index != -1) {
//       final challenge = challenges[index];

//       // In a real app, we would update the progress here
//       // For now, let's just mark it as completed and add points to the user
//       final updatedChallenge = challenge.copyWith(isCompleted: true);
//       challenges[index] = updatedChallenge;

//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));

//       // Update user with points
//       final user = await getUser();
//       final updatedUser =
//           user.copyWith(sigmaPoints: user.sigmaPoints + challenge.points);
//       await updateUser(updatedUser);
//     }
//   }

//   // Method to start a challenge
//   Future<void> startChallenge(String challengeId) async {
//     // In a real app, this would update the challenge status or add it to active challenges
//     // For now, we'll just log it
//     print('Starting challenge with ID: $challengeId');
//   }

//   // Routines methods
//   Future<List<Routine>> getRoutines() async {
//     await _initializeRoutines();

//     final routinesJson = _prefs.getString(Constants.routinesKey);
//     if (routinesJson != null) {
//       final List<dynamic> decoded = jsonDecode(routinesJson);
//       return decoded.map((item) => Routine.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeRoutines() async {
//     if (!_prefs.containsKey(Constants.routinesKey)) {
//       final routines = [
//         Routine(
//           id: _generateId(),
//           name: 'Morning Sigma Routine',
//           category: 'Productivity',
//           description: 'Start your day like a true Sigma',
//           isActive: true,
//           currentStreak: 3,
//           tasks: [
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Cold Shower',
//               duration: 10,
//               completed: false,
//             ),
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Meditation',
//               duration: 20,
//               completed: false,
//             ),
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Reading',
//               duration: 30,
//               completed: false,
//             ),
//           ],
//         ),
//       ];

//       await _prefs.setString(Constants.routinesKey,
//           jsonEncode(routines.map((r) => r.toJson()).toList()));
//     }
//   }

//   Future<void> saveRoutine(Routine routine) async {
//     final routines = await getRoutines();
//     final index = routines.indexWhere((r) => r.id == routine.id);

//     if (index != -1) {
//       // Update existing routine
//       routines[index] = routine;
//     } else {
//       // Add new routine with generated ID
//       final newRoutine = routine.copyWith(id: _generateId());
//       routines.add(newRoutine);
//     }

//     await _prefs.setString(Constants.routinesKey,
//         jsonEncode(routines.map((r) => r.toJson()).toList()));
//   }

//   Future<void> deleteRoutine(String routineId) async {
//     final routines = await getRoutines();
//     routines.removeWhere((r) => r.id == routineId);
//     await _prefs.setString(Constants.routinesKey,
//         jsonEncode(routines.map((r) => r.toJson()).toList()));
//   }

//   // Focus sessions methods
//   Future<List<FocusSession>> getFocusSessions() async {
//     await _initializeFocusSessions();

//     final sessionsJson = _prefs.getString(Constants.focusSessionsKey);
//     if (sessionsJson != null) {
//       final List<dynamic> decoded = jsonDecode(sessionsJson);
//       return decoded.map((item) => FocusSession.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeFocusSessions() async {
//     if (!_prefs.containsKey(Constants.focusSessionsKey)) {
//       final focusSessions = [
//         FocusSession(
//           id: _generateId(),
//           title: 'Deep Work Session',
//           description: 'Focus on a single task without distractions',
//           duration: 60, // 60 minutes
//           points: 50,
//         ),
//         FocusSession(
//           id: _generateId(),
//           title: 'Pomodoro Session',
//           description: '25 minutes of intense focus',
//           duration: 25, // 25 minutes
//           points: 25,
//         ),
//       ];

//       await _prefs.setString(Constants.focusSessionsKey,
//           jsonEncode(focusSessions.map((s) => s.toJson()).toList()));
//     }
//   }

//   Future<void> saveFocusSession(FocusSession session) async {
//     final sessions = await getFocusSessions();
//     final index = sessions.indexWhere((s) => s.id == session.id);

//     if (index != -1) {
//       // Update existing session
//       sessions[index] = session;
//     } else {
//       // Add new session with generated ID
//       final newSession = session.copyWith(id: _generateId());
//       sessions.add(newSession);
//     }

//     await _prefs.setString(Constants.focusSessionsKey,
//         jsonEncode(sessions.map((s) => s.toJson()).toList()));
//   }

//   Future<void> completeFocusSession(FocusSession session) async {
//     // Mark session as completed
//     final completedSession = session.copyWith(
//       isCompleted: true,
//       endTime: DateTime.now(),
//     );

//     await saveFocusSession(completedSession);

//     // Award points to user
//     final user = await getUser();
//     final updatedUser = user.copyWith(
//       sigmaPoints: user.sigmaPoints + session.points,
//     );

//     await updateUser(updatedUser);
//   }

//   // Knowledge base methods
//   Future<List<KnowledgeCategory>> getKnowledgeCategories() async {
//     await _initializeKnowledgeBase();

//     final knowledgeJson = _prefs.getString(Constants.knowledgeBaseKey);
//     if (knowledgeJson != null) {
//       final List<dynamic> decoded = jsonDecode(knowledgeJson);
//       return decoded.map((item) => KnowledgeCategory.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeKnowledgeBase() async {
//     if (!_prefs.containsKey(Constants.knowledgeBaseKey)) {
//       final categories = [
//         KnowledgeCategory(
//           id: _generateId(),
//           title: 'Sigma Mindset',
//           description: 'Learn about the Sigma mindset and philosophy',
//           iconName: 'psychology',
//           articles: [
//             KnowledgeArticle(
//               id: _generateId(),
//               title: 'The Sigma Mindset Explained',
//               content:
//                   'The Sigma mindset is about independence, self-discipline, and focus on personal growth...',
//               author: 'Sigma Team',
//               publishDate: DateTime.now().subtract(const Duration(days: 30)),
//               tags: ['mindset', 'philosophy', 'sigma'],
//             ),
//           ],
//         ),
//         KnowledgeCategory(
//           id: _generateId(),
//           title: 'Discipline',
//           description:
//               'Techniques to build discipline and maintain good habits',
//           iconName: 'fitness_center',
//           articles: [
//             KnowledgeArticle(
//               id: _generateId(),
//               title: 'Building Unbreakable Discipline',
//               content:
//                   'Discipline is the bridge between goals and accomplishment...',
//               author: 'Sigma Team',
//               publishDate: DateTime.now().subtract(const Duration(days: 20)),
//               tags: ['discipline', 'habits', 'consistency'],
//             ),
//           ],
//         ),
//       ];

//       await _prefs.setString(Constants.knowledgeBaseKey,
//           jsonEncode(categories.map((c) => c.toJson()).toList()));
//     }
//   }

//   // Personality test methods
//   Future<List<Map<String, dynamic>>> getPersonalityQuestions() async {
//     return [
//       {
//         'question': 'I prefer to work alone rather than in a team',
//         'score': 3,
//         'options': [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ]
//       },
//       {
//         'question': 'I have a strict daily routine that I follow',
//         'score': 3,
//         'options': [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ]
//       },
//       {
//         'question': 'I prioritize self-improvement over social activities',
//         'score': 3,
//         'options': [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ]
//       },
//       {
//         'question':
//             'I focus on long-term goals rather than immediate satisfaction',
//         'score': 3,
//         'options': [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ]
//       },
//       {
//         'question': 'I am comfortable going against mainstream opinions',
//         'score': 3,
//         'options': [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ]
//       },
//     ];
//   }

//   Future<Map<String, dynamic>> updatePersonalityTest(
//       List<dynamic> questions) async {
//     // Process the test results
//     final totalScore =
//         questions.fold<int>(0, (sum, q) => sum + (q['score'] as int? ?? 0));
//     final maxPossibleScore =
//         questions.length * 5; // Assuming 5 is max score per question
//     final percentageScore = (totalScore / maxPossibleScore) * 100;

//     // Determine personality type based on score
//     String personalityType;
//     List<String> traits = [];

//     if (percentageScore >= 80) {
//       personalityType = 'Sigma';
//       traits = ['Leadership', 'Discipline', 'Focus', 'Independence'];
//     } else if (percentageScore >= 60) {
//       personalityType = 'Alpha';
//       traits = ['Confidence', 'Sociability', 'Ambition'];
//     } else if (percentageScore >= 40) {
//       personalityType = 'Beta';
//       traits = ['Loyalty', 'Supportive', 'Reliable'];
//     } else {
//       personalityType = 'Omega';
//       traits = ['Creative', 'Analytical', 'Independent'];
//     }

//     // Update user personality data
//     final user = await getUser();
//     final updatedUser = user.copyWith(
//       personalityType: personalityType,
//       sigmaPoints:
//           user.sigmaPoints + 50, // Bonus points for completing the test
//       traits: traits
//           .map((name) => Trait(
//                 id: _generateId(),
//                 name: name,
//                 score: _random.nextInt(30) + 70, // Random score between 70-100
//                 description: 'A key trait of $personalityType personality',
//               ))
//           .toList(),
//     );

//     await updateUser(updatedUser);

//     // Return results to display to the user
//     return {
//       'score': percentageScore.round(),
//       'type': personalityType,
//       'traits': traits,
//     };
//   }
// }

//2

// import 'dart:convert';
// import 'dart:math';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sigma_path/models/app_models.dart';
// import 'package:sigma_path/utils/constants.dart';

// class MockApi {
//   late SharedPreferences _prefs;
//   final Random _random = Random();

//   MockApi() {
//     _initPrefs();
//   }

//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   // Method for app initialization
//   Future<void> initializeApp() async {
//     await _initPrefs();
//     await _initializeUser();
//     await _initializeChallenges();
//     await _initializeRoutines();
//     await _initializeFocusSessions();
//     await _initializeKnowledgeBase();
//   }

//   String _generateId() {
//     return DateTime.now().millisecondsSinceEpoch.toString();
//   }

//   // User methods
//   Future<User> getUser() async {
//     final userData = _prefs.getString(Constants.userDataKey);
//     if (userData != null) {
//       return User.fromJson(jsonDecode(userData));
//     }
//     return await _initializeUser();
//   }

//   Future<User> _initializeUser() async {
//     if (!_prefs.containsKey(Constants.userDataKey)) {
//       final user = User(
//         id: _generateId(),
//         username: 'SigmaUser${_random.nextInt(1000)}',
//         email: 'user@example.com',
//         sigmaScore: 70,
//         traitScores: {
//           'Discipline': 80,
//           'Focus': 75,
//           'Leadership': 65,
//           'Independence': 70,
//         },
//         sigmaPoints: 0,
//         level: 1,
//         daysActive: 1,
//         achievements: [],
//         traits: [
//           Trait(
//             id: _generateId(),
//             name: 'Discipline',
//             score: 80,
//             description: 'Ability to maintain focus and adhere to routines',
//           ),
//           Trait(
//             id: _generateId(),
//             name: 'Leadership',
//             score: 65,
//             description: 'Skill in guiding and motivating others',
//           ),
//         ],
//         personalityType: 'Undetermined',
//       );

//       await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
//       return user;
//     }

//     final userData = _prefs.getString(Constants.userDataKey);
//     if (userData != null) {
//       return User.fromJson(jsonDecode(userData));
//     }

//     // Default user if something went wrong
//     return User(
//       id: 'default',
//       username: 'DefaultUser',
//       email: 'default@example.com',
//       sigmaScore: 50,
//       traitScores: {},
//       sigmaPoints: 0,
//       level: 1,
//       daysActive: 0,
//       achievements: [],
//       traits: [],
//       personalityType: 'Undetermined',
//     );
//   }

//   Future<void> updateUser(User user) async {
//     await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
//   }

//   // Challenge methods
//   Future<List<Challenge>> getChallenges() async {
//     await _initializeChallenges();

//     final challengesJson = _prefs.getString(Constants.challengesKey);
//     if (challengesJson != null) {
//       final List<dynamic> decoded = jsonDecode(challengesJson);
//       return decoded.map((item) => Challenge.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeChallenges() async {
//     if (!_prefs.containsKey(Constants.challengesKey)) {
//       final challenges = [
//         Challenge(
//           id: _generateId(),
//           title: 'Early Riser',
//           description: 'Wake up at 5 AM for 7 consecutive days',
//           points: 100,
//           isCompleted: false,
//           category: 'Discipline',
//           difficulty: 3,
//         ),
//         Challenge(
//           id: _generateId(),
//           title: 'Cold Shower Master',
//           description: 'Take cold showers for 14 consecutive days',
//           points: 150,
//           isCompleted: false,
//           category: 'Discipline',
//           difficulty: 4,
//         ),
//       ];

//       // Example of completing a challenge
//       final completedChallenge = challenges[1].copyWith(isCompleted: true);

//       // Update challenges array with completed one
//       challenges[1] = completedChallenge;

//       // Save to preferences
//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));
//     }
//   }

//   Future<void> updateChallenge(Challenge challenge) async {
//     final challenges = await getChallenges();
//     final index = challenges.indexWhere((c) => c.id == challenge.id);

//     if (index != -1) {
//       challenges[index] = challenge;
//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));
//     }
//   }

//   // Method for checking in to a challenge (tracking progress)
//   Future<void> checkInChallenge(String challengeId) async {
//     final challenges = await getChallenges();
//     final index = challenges.indexWhere((c) => c.id == challengeId);

//     if (index != -1) {
//       final challenge = challenges[index];

//       // In a real app, we would update the progress here
//       // For now, let's just mark it as completed and add points to the user
//       final updatedChallenge = challenge.copyWith(isCompleted: true);
//       challenges[index] = updatedChallenge;

//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));

//       // Update user with points
//       final user = await getUser();
//       final updatedUser =
//           user.copyWith(sigmaPoints: user.sigmaPoints + challenge.points);
//       await updateUser(updatedUser);
//     }
//   }

//   // Method to start a challenge
//   Future<void> startChallenge(String challengeId) async {
//     final challenges = await getChallenges();
//     final index = challenges.indexWhere((c) => c.id == challengeId);

//     if (index != -1) {
//       final challenge = challenges[index];
//       final updatedChallenge = challenge.copyWith(
//         isActive: true,
//         startDate: DateTime.now(),
//       );
//       challenges[index] = updatedChallenge;

//       await _prefs.setString(Constants.challengesKey,
//           jsonEncode(challenges.map((c) => c.toJson()).toList()));
//     }
//   }

//   // Routines methods
//   Future<List<Routine>> getRoutines() async {
//     await _initializeRoutines();

//     final routinesJson = _prefs.getString(Constants.routinesKey);
//     if (routinesJson != null) {
//       final List<dynamic> decoded = jsonDecode(routinesJson);
//       return decoded.map((item) => Routine.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeRoutines() async {
//     if (!_prefs.containsKey(Constants.routinesKey)) {
//       final routines = [
//         Routine(
//           id: _generateId(),
//           title: 'Morning Sigma Routine',
//           category: 'Productivity',
//           description: 'Start your day like a true Sigma',
//           isActive: true,
//           currentStreak: 3,
//           tasks: [
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Cold Shower',
//               time: '06:00', // Add the time parameter
//               isCompleted: false,
//             ),
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Meditation',
//               time: '06:15', // Add the time parameter
//               isCompleted: false,
//             ),
//             RoutineTask(
//               id: _generateId(),
//               activity: 'Reading',
//               time: '06:45', // Add the time parameter
//               isCompleted: false,
//             ),
//           ],
//         ),
//       ];

//       await _prefs.setString(Constants.routinesKey,
//           jsonEncode(routines.map((r) => r.toJson()).toList()));
//     }
//   }

//   Future<void> saveRoutine(Routine routine) async {
//     final routines = await getRoutines();
//     final index = routines.indexWhere((r) => r.id == routine.id);

//     if (index != -1) {
//       // Update existing routine
//       routines[index] = routine;
//     } else {
//       // Add new routine with generated ID
//       final newRoutine = routine.copyWith(id: _generateId());
//       routines.add(newRoutine);
//     }

//     await _prefs.setString(Constants.routinesKey,
//         jsonEncode(routines.map((r) => r.toJson()).toList()));
//   }

//   Future<void> deleteRoutine(String routineId) async {
//     final routines = await getRoutines();
//     routines.removeWhere((r) => r.id == routineId);
//     await _prefs.setString(Constants.routinesKey,
//         jsonEncode(routines.map((r) => r.toJson()).toList()));
//   }

//   // Focus sessions methods
//   Future<List<FocusSession>> getFocusSessions() async {
//     await _initializeFocusSessions();

//     final sessionsJson = _prefs.getString(Constants.focusSessionsKey);
//     if (sessionsJson != null) {
//       final List<dynamic> decoded = jsonDecode(sessionsJson);
//       return decoded.map((item) => FocusSession.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeFocusSessions() async {
//     if (!_prefs.containsKey(Constants.focusSessionsKey)) {
//       final focusSessions = [
//         FocusSession(
//           id: _generateId(),
//           title: 'Deep Work Session',
//           description: 'Focus on a single task without distractions',
//           duration: 60, // 60 minutes
//           points: 50,
//           createdAt: DateTime.now().subtract(const Duration(days: 1)),
//         ),
//         FocusSession(
//           id: _generateId(),
//           title: 'Pomodoro Session',
//           description: '25 minutes of intense focus',
//           duration: 25, // 25 minutes
//           points: 25,
//           createdAt: DateTime.now().subtract(const Duration(days: 2)),
//         ),
//       ];

//       await _prefs.setString(Constants.focusSessionsKey,
//           jsonEncode(focusSessions.map((s) => s.toJson()).toList()));
//     }
//   }

//   Future<void> saveFocusSession(FocusSession session) async {
//     final sessions = await getFocusSessions();
//     final index = sessions.indexWhere((s) => s.id == session.id);

//     if (index != -1) {
//       // Update existing session
//       sessions[index] = session;
//     } else {
//       // Add new session with generated ID
//       final newSession = session.copyWith(id: _generateId());
//       sessions.add(newSession);
//     }

//     await _prefs.setString(Constants.focusSessionsKey,
//         jsonEncode(sessions.map((s) => s.toJson()).toList()));
//   }

//   Future<void> completeFocusSession(FocusSession session) async {
//     // Mark session as completed
//     final completedSession = session.copyWith(
//       isCompleted: true,
//       completedAt: DateTime.now(),
//     );

//     await saveFocusSession(completedSession);

//     // Award points to user
//     final user = await getUser();
//     final updatedUser = user.copyWith(
//       sigmaPoints: user.sigmaPoints + session.points,
//     );

//     await updateUser(updatedUser);
//   }

//   // Knowledge base methods
//   Future<List<KnowledgeCategory>> getKnowledgeCategories() async {
//     await _initializeKnowledgeBase();

//     final knowledgeJson = _prefs.getString(Constants.knowledgeBaseKey);
//     if (knowledgeJson != null) {
//       final List<dynamic> decoded = jsonDecode(knowledgeJson);
//       return decoded.map((item) => KnowledgeCategory.fromJson(item)).toList();
//     }

//     return [];
//   }

//   Future<void> _initializeKnowledgeBase() async {
//     if (!_prefs.containsKey(Constants.knowledgeBaseKey)) {
//       final categories = [
//         KnowledgeCategory(
//           id: _generateId(),
//           title: 'Sigma Mindset',
//           description: 'Learn about the Sigma mindset and philosophy',
//           iconName: 'psychology',
//           articles: [
//             KnowledgeArticle(
//               id: _generateId(),
//               title: 'The Sigma Mindset Explained',
//               content:
//                   'The Sigma mindset is about independence, self-discipline, and focus on personal growth...',
//               category: 'Mindset',
//               publishedAt: DateTime.now().subtract(const Duration(days: 30)),
//               readTimeMinutes: 5,
//               author: 'Sigma Team',
//               publishDate: DateTime.now().subtract(const Duration(days: 30)),
//               tags: ['mindset', 'philosophy', 'sigma'],
//             ),
//           ],
//         ),
//         KnowledgeCategory(
//           id: _generateId(),
//           title: 'Discipline',
//           description:
//               'Techniques to build discipline and maintain good habits',
//           iconName: 'fitness_center',
//           articles: [
//             KnowledgeArticle(
//               id: _generateId(),
//               title: 'Building Unbreakable Discipline',
//               content:
//                   'Discipline is the bridge between goals and accomplishment...',
//               category: 'Discipline',
//               publishedAt: DateTime.now().subtract(const Duration(days: 20)),
//               readTimeMinutes: 4,
//               author: 'Sigma Team',
//               publishDate: DateTime.now().subtract(const Duration(days: 20)),
//               tags: ['discipline', 'habits', 'consistency'],
//             ),
//           ],
//         ),
//       ];

//       await _prefs.setString(Constants.knowledgeBaseKey,
//           jsonEncode(categories.map((c) => c.toJson()).toList()));
//     }
//   }

//   // Personality test methods
//   Future<List<PersonalityQuestion>> getPersonalityQuestions() async {
//     return [
//       PersonalityQuestion(
//         question: 'I prefer to work alone rather than in a team',
//         score: 3,
//         options: [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ],
//         trait: 'Independence',
//       ),
//       PersonalityQuestion(
//         question: 'I have a strict daily routine that I follow',
//         score: 3,
//         options: [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ],
//         trait: 'Discipline',
//       ),
//       PersonalityQuestion(
//         question: 'I prioritize self-improvement over social activities',
//         score: 3,
//         options: [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ],
//         trait: 'Focus',
//       ),
//       PersonalityQuestion(
//         question:
//             'I focus on long-term goals rather than immediate satisfaction',
//         score: 3,
//         options: [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ],
//         trait: 'Discipline',
//       ),
//       PersonalityQuestion(
//         question: 'I am comfortable going against mainstream opinions',
//         score: 3,
//         options: [
//           'Strongly Disagree',
//           'Disagree',
//           'Neutral',
//           'Agree',
//           'Strongly Agree'
//         ],
//         trait: 'Independence',
//       ),
//     ];
//   }

//   Future<Map<String, int>> updatePersonalityTest(
//       List<PersonalityQuestion> questions) async {
//     // Process the test results
//     final totalScore = questions.fold<int>(0, (sum, q) => sum + q.score);
//     final maxPossibleScore =
//         questions.length * 5; // Assuming 5 is max score per question
//     final percentageScore = (totalScore / maxPossibleScore) * 100;

//     // Determine personality type based on score
//     String personalityType;
//     List<String> traits = [];

//     if (percentageScore >= 80) {
//       personalityType = 'Sigma';
//       traits = ['Leadership', 'Discipline', 'Focus', 'Independence'];
//     } else if (percentageScore >= 60) {
//       personalityType = 'Alpha';
//       traits = ['Confidence', 'Sociability', 'Ambition'];
//     } else if (percentageScore >= 40) {
//       personalityType = 'Beta';
//       traits = ['Loyalty', 'Supportive', 'Reliable'];
//     } else {
//       personalityType = 'Omega';
//       traits = ['Creative', 'Analytical', 'Independent'];
//     }

//     // Update user personality data
//     final user = await getUser();

//     // Create trait objects
//     final updatedTraits = traits
//         .map((name) => Trait(
//               id: _generateId(),
//               name: name,
//               score: _random.nextInt(30) + 70, // Random score between 70-100
//               description: 'A key trait of $personalityType personality',
//             ))
//         .toList();

//     final updatedUser = user.copyWith(
//       personalityType: personalityType,
//       sigmaPoints:
//           user.sigmaPoints + 50, // Bonus points for completing the test
//       traits: updatedTraits,
//     );

//     await updateUser(updatedUser);

//     // Return results to display to the user - using Map<String, int> as expected by the existing code
//     final Map<String, int> resultMap = {};
//     resultMap['score'] = percentageScore.round();

//     // Add trait scores
//     for (var trait in updatedTraits) {
//       resultMap[trait.name] = trait.score;
//     }

//     return resultMap;
//   }
// }

//3

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/utils/constants.dart';

class MockApi {
  late SharedPreferences _prefs;
  final Random _random = Random();

  MockApi() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Method for app initialization
  Future<void> initializeApp() async {
    await _initPrefs();
    await _initializeUser();
    await _initializeChallenges();
    await _initializeRoutines();
    await _initializeFocusSessions();
    await _initializeKnowledgeBase();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // User methods
  Future<User> getUser() async {
    final userData = _prefs.getString(Constants.userDataKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return await _initializeUser();
  }

  Future<User> _initializeUser() async {
    if (!_prefs.containsKey(Constants.userDataKey)) {
      final user = User(
        id: _generateId(),
        username: 'SigmaUser${_random.nextInt(1000)}',
        email: 'user@example.com',
        sigmaScore: 70,
        traitScores: {
          'Discipline': 80,
          'Focus': 75,
          'Leadership': 65,
          'Independence': 70,
        },
        sigmaPoints: 0,
        level: 1,
        daysActive: 1,
        achievements: [],
      );

      await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
      return user;
    }

    final userData = _prefs.getString(Constants.userDataKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }

    // Default user if something went wrong
    return User(
      id: 'default',
      username: 'DefaultUser',
      email: 'default@example.com',
      sigmaScore: 50,
      traitScores: {},
      sigmaPoints: 0,
      level: 1,
      daysActive: 0,
      achievements: [],
    );
  }

  Future<void> updateUser(User user) async {
    await _prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));
  }

  // Challenge methods
  Future<List<Challenge>> getChallenges() async {
    await _initializeChallenges();

    final challengesJson = _prefs.getString(Constants.challengesKey);
    if (challengesJson != null) {
      final List<dynamic> decoded = jsonDecode(challengesJson);
      return decoded.map((item) => Challenge.fromJson(item)).toList();
    }

    return [];
  }

  Future<void> _initializeChallenges() async {
    if (!_prefs.containsKey(Constants.challengesKey)) {
      final challenges = [
        Challenge(
          id: _generateId(),
          title: 'Early Riser',
          description: 'Wake up at 5 AM for 7 consecutive days',
          duration: 7,
          sigmaPoints: 100,
          isCompleted: false,
          isActive: false,
          difficulty: 3,
          currentStreak: 0,
          longestStreak: 0,
          checkInDates: [],
        ),
        Challenge(
          id: _generateId(),
          title: 'Cold Shower Master',
          description: 'Take cold showers for 14 consecutive days',
          duration: 14,
          sigmaPoints: 150,
          isCompleted: false,
          isActive: false,
          difficulty: 4,
          currentStreak: 0,
          longestStreak: 0,
          checkInDates: [],
        ),
      ];

      // Example of completing a challenge
      final completedChallenge = challenges[1].copyWith(isCompleted: true);

      // Update challenges array with completed one
      challenges[1] = completedChallenge;

      // Save to preferences
      await _prefs.setString(Constants.challengesKey,
          jsonEncode(challenges.map((c) => c.toJson()).toList()));
    }
  }

  Future<void> updateChallenge(Challenge challenge) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challenge.id);

    if (index != -1) {
      challenges[index] = challenge;
      await _prefs.setString(Constants.challengesKey,
          jsonEncode(challenges.map((c) => c.toJson()).toList()));
    }
  }

  // Method for checking in to a challenge (tracking progress)
  Future<void> checkInChallenge(String challengeId) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challengeId);

    if (index != -1) {
      final challenge = challenges[index];

      // Update the challenge with a check-in
      challenge.checkIn();
      challenges[index] = challenge;

      await _prefs.setString(Constants.challengesKey,
          jsonEncode(challenges.map((c) => c.toJson()).toList()));

      // If the challenge is now completed, update user with points
      if (challenge.isCompleted) {
        final user = await getUser();
        final updatedUser = user.copyWith(
            sigmaPoints: user.sigmaPoints + challenge.sigmaPoints);
        await updateUser(updatedUser);
      }
    }
  }

  // Method to start a challenge
  Future<void> startChallenge(String challengeId) async {
    final challenges = await getChallenges();
    final index = challenges.indexWhere((c) => c.id == challengeId);

    if (index != -1) {
      final challenge = challenges[index];
      final updatedChallenge = challenge.copyWith(
        isActive: true,
        startDate: DateTime.now(),
      );
      challenges[index] = updatedChallenge;

      await _prefs.setString(Constants.challengesKey,
          jsonEncode(challenges.map((c) => c.toJson()).toList()));
    }
  }

  // Routines methods
  Future<List<Routine>> getRoutines() async {
    await _initializeRoutines();

    final routinesJson = _prefs.getString(Constants.routinesKey);
    if (routinesJson != null) {
      final List<dynamic> decoded = jsonDecode(routinesJson);
      return decoded.map((item) => Routine.fromJson(item)).toList();
    }

    return [];
  }

  Future<void> _initializeRoutines() async {
    if (!_prefs.containsKey(Constants.routinesKey)) {
      final routines = [
        Routine(
          id: _generateId(),
          title: 'Morning Sigma Routine',
          category: 'Productivity',
          description: 'Start your day like a true Sigma',
          isActive: true,
          currentStreak: 3,
          completionCount: 0,
          longestStreak: 3,
          completionDates: [],
          weekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          tasks: [
            RoutineTask(
              id: _generateId(),
              activity: 'Cold Shower',
              time: '06:00',
              isCompleted: false,
            ),
            RoutineTask(
              id: _generateId(),
              activity: 'Meditation',
              time: '06:15',
              isCompleted: false,
            ),
            RoutineTask(
              id: _generateId(),
              activity: 'Reading',
              time: '06:45',
              isCompleted: false,
            ),
          ],
        ),
      ];

      await _prefs.setString(Constants.routinesKey,
          jsonEncode(routines.map((r) => r.toJson()).toList()));
    }
  }

  Future<void> saveRoutine(Routine routine) async {
    final routines = await getRoutines();
    final index = routines.indexWhere((r) => r.id == routine.id);

    if (index != -1) {
      // Update existing routine
      routines[index] = routine;
    } else {
      // Add new routine with generated ID
      final newRoutine = routine.copyWith(id: _generateId());
      routines.add(newRoutine);
    }

    await _prefs.setString(Constants.routinesKey,
        jsonEncode(routines.map((r) => r.toJson()).toList()));
  }

  Future<void> deleteRoutine(String routineId) async {
    final routines = await getRoutines();
    routines.removeWhere((r) => r.id == routineId);
    await _prefs.setString(Constants.routinesKey,
        jsonEncode(routines.map((r) => r.toJson()).toList()));
  }

  // Focus sessions methods
  Future<List<FocusSession>> getFocusSessions() async {
    await _initializeFocusSessions();

    final sessionsJson = _prefs.getString(Constants.focusSessionsKey);
    if (sessionsJson != null) {
      final List<dynamic> decoded = jsonDecode(sessionsJson);
      return decoded.map((item) => FocusSession.fromJson(item)).toList();
    }

    return [];
  }

  Future<void> _initializeFocusSessions() async {
    if (!_prefs.containsKey(Constants.focusSessionsKey)) {
      final focusSessions = [
        FocusSession(
          id: _generateId(),
          title: 'Deep Work Session',
          duration: 60, // 60 minutes
          breakInterval: 0,
          breakDuration: 0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: false,
          blockedWebsites: [],
        ),
        FocusSession(
          id: _generateId(),
          title: 'Pomodoro Session',
          duration: 25, // 25 minutes
          breakInterval: 25,
          breakDuration: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          isCompleted: false,
          blockedWebsites: [],
        ),
      ];

      await _prefs.setString(Constants.focusSessionsKey,
          jsonEncode(focusSessions.map((s) => s.toJson()).toList()));
    }
  }

  Future<void> saveFocusSession(FocusSession session) async {
    final sessions = await getFocusSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);

    if (index != -1) {
      // Update existing session
      sessions[index] = session;
    } else {
      // Add new session with generated ID
      final newSession = session.copyWith(id: _generateId());
      sessions.add(newSession);
    }

    await _prefs.setString(Constants.focusSessionsKey,
        jsonEncode(sessions.map((s) => s.toJson()).toList()));
  }

  Future<void> completeFocusSession(FocusSession session) async {
    // Mark session as completed
    final completedSession = session.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    await saveFocusSession(completedSession);

    // Award points to user (assuming FocusSession has duration that can be used for points)
    final user = await getUser();
    // Award 1 point per minute
    final pointsToAward = session.duration;
    final updatedUser = user.copyWith(
      sigmaPoints: user.sigmaPoints + pointsToAward,
    );

    await updateUser(updatedUser);
  }

  // Knowledge base methods
  Future<List<KnowledgeCategory>> getKnowledgeCategories() async {
    await _initializeKnowledgeBase();

    final knowledgeJson = _prefs.getString(Constants.knowledgeBaseKey);
    if (knowledgeJson != null) {
      final List<dynamic> decoded = jsonDecode(knowledgeJson);
      return decoded.map((item) => KnowledgeCategory.fromJson(item)).toList();
    }

    return [];
  }

  Future<void> _initializeKnowledgeBase() async {
    if (!_prefs.containsKey(Constants.knowledgeBaseKey)) {
      final categories = [
        KnowledgeCategory(
          id: _generateId(),
          title: 'Sigma Mindset',
          description: 'Learn about the Sigma mindset and philosophy',
          iconName: 'psychology',
          articles: [
            KnowledgeArticle(
              id: _generateId(),
              title: 'The Sigma Mindset Explained',
              content:
                  'The Sigma mindset is about independence, self-discipline, and focus on personal growth...',
              category: 'Mindset',
              publishedAt: DateTime.now().subtract(const Duration(days: 30)),
              readTimeMinutes: 5,
              tags: ['mindset', 'philosophy', 'sigma'],
              isFavorite: false,
              isRead: false,
            ),
          ],
        ),
        KnowledgeCategory(
          id: _generateId(),
          title: 'Discipline',
          description:
              'Techniques to build discipline and maintain good habits',
          iconName: 'fitness_center',
          articles: [
            KnowledgeArticle(
              id: _generateId(),
              title: 'Building Unbreakable Discipline',
              content:
                  'Discipline is the bridge between goals and accomplishment...',
              category: 'Discipline',
              publishedAt: DateTime.now().subtract(const Duration(days: 20)),
              readTimeMinutes: 4,
              tags: ['discipline', 'habits', 'consistency'],
              isFavorite: false,
              isRead: false,
            ),
          ],
        ),
      ];

      await _prefs.setString(Constants.knowledgeBaseKey,
          jsonEncode(categories.map((c) => c.toJson()).toList()));
    }
  }

  // Personality test methods
  Future<List<PersonalityQuestion>> getPersonalityQuestions() async {
    return [
      PersonalityQuestion(
        id: _generateId(),
        question: 'I prefer to work alone rather than in a team',
        answer: null,
        options: [
          'Strongly Disagree',
          'Disagree',
          'Neutral',
          'Agree',
          'Strongly Agree'
        ],
        trait: 'Independence',
      ),
      PersonalityQuestion(
        id: _generateId(),
        question: 'I have a strict daily routine that I follow',
        answer: null,
        options: [
          'Strongly Disagree',
          'Disagree',
          'Neutral',
          'Agree',
          'Strongly Agree'
        ],
        trait: 'Discipline',
      ),
      PersonalityQuestion(
        id: _generateId(),
        question: 'I prioritize self-improvement over social activities',
        answer: null,
        options: [
          'Strongly Disagree',
          'Disagree',
          'Neutral',
          'Agree',
          'Strongly Agree'
        ],
        trait: 'Focus',
      ),
      PersonalityQuestion(
        id: _generateId(),
        question:
            'I focus on long-term goals rather than immediate satisfaction',
        answer: null,
        options: [
          'Strongly Disagree',
          'Disagree',
          'Neutral',
          'Agree',
          'Strongly Agree'
        ],
        trait: 'Discipline',
      ),
      PersonalityQuestion(
        id: _generateId(),
        question: 'I am comfortable going against mainstream opinions',
        answer: null,
        options: [
          'Strongly Disagree',
          'Disagree',
          'Neutral',
          'Agree',
          'Strongly Agree'
        ],
        trait: 'Independence',
      ),
    ];
  }

  Future<Map<String, int>> updatePersonalityTest(
      List<PersonalityQuestion> questions) async {
    // Process the test results
    int totalScore = 0;
    for (var question in questions) {
      totalScore += question.answer ?? 3; // Default to 3 if not answered
    }

    final maxPossibleScore =
        questions.length * 5; // Assuming 5 is max score per question
    final percentageScore = (totalScore / maxPossibleScore) * 100;

    // Determine personality type based on score
    List<String> traitNames = [];

    if (percentageScore >= 80) {
      traitNames = ['Leadership', 'Discipline', 'Focus', 'Independence'];
    } else if (percentageScore >= 60) {
      traitNames = ['Confidence', 'Sociability', 'Ambition'];
    } else if (percentageScore >= 40) {
      traitNames = ['Loyalty', 'Supportive', 'Reliable'];
    } else {
      traitNames = ['Creative', 'Analytical', 'Independent'];
    }

    // Update user personality data
    final user = await getUser();

    // Update user traitScores map with the new values
    Map<String, int> updatedTraitScores = Map.from(user.traitScores);
    for (var traitName in traitNames) {
      int score = _random.nextInt(30) + 70; // Random score between 70-100
      updatedTraitScores[traitName] = score;
    }

    final updatedUser = user.copyWith(
      sigmaPoints:
          user.sigmaPoints + 50, // Bonus points for completing the test
      sigmaScore: (updatedTraitScores.values.reduce((a, b) => a + b) /
              updatedTraitScores.length)
          .round(),
      traitScores: updatedTraitScores,
    );

    await updateUser(updatedUser);

    // Return results to display to the user
    final Map<String, int> resultMap = {};
    resultMap['score'] = percentageScore.round();

    // Add trait scores
    for (var traitName in traitNames) {
      resultMap[traitName] = updatedTraitScores[traitName] ?? 0;
    }

    return resultMap;
  }
}
