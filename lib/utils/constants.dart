class Constants {
  // App Constants
  static const String appName = 'SigmaPath';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String userDataKey = 'user_data';
  static const String challengesKey = 'challenges';
  static const String routinesKey = 'routines';
  static const String focusSessionsKey = 'focus_sessions';

  // Routes
  static const String homeRoute = '/home';
  static const String personalityTestRoute = '/personality_test';
  static const String routinesRoute = '/routines';
  static const String disciplineRoute = '/discipline';
  static const String knowledgeBaseRoute = '/knowledge_base';
  static const String routineBuilderRoute = '/routine_builder';
  static const String focusModeRoute = '/focus_mode';

  // API Endpoints
  static const String baseUrl =
      'https://api.sigmapath.com'; // Fake URL for mock
  static const String userEndpoint = '/user';
  static const String challengesEndpoint = '/challenges';
  static const String routinesEndpoint = '/routines';
  static const String knowledgeBaseEndpoint = '/knowledge';

  // Personality Test Constants
  static const int questionsPerTrait = 5;
  static const int totalTraits = 5;
  static const int totalQuestions = questionsPerTrait * totalTraits;

  static const String knowledgeBaseKey = 'knowledge_base';
  static const String personalityQuestionsKey = 'personality_questions';

  // Traits
  static const List<String> traits = [
    'Independence',
    'Social Detachment',
    'Confidence',
    'Mindset',
    'Success Drive',
  ];

  // Default Challenge List
  static const List<Map<String, dynamic>> defaultChallenges = [
    {
      'id': 1,
      'title': 'No Social Media for 30 Days',
      'description':
          'Eliminate all social media platforms for 30 days to reclaim your focus.',
      'duration': 30,
      'difficulty': 4,
      'sigmaPoints': 500,
    },
    {
      'id': 2,
      'title': 'Cold Showers for a Week',
      'description':
          'Take cold showers every day for a week to build mental toughness.',
      'duration': 7,
      'difficulty': 3,
      'sigmaPoints': 150,
    },
    {
      'id': 3,
      'title': 'Wake Up at 5 AM for 21 Days',
      'description':
          'Start your day at 5 AM for 21 consecutive days to maximize productivity.',
      'duration': 21,
      'difficulty': 4,
      'sigmaPoints': 400,
    },
    {
      'id': 4,
      'title': 'Read 10 Books in 30 Days',
      'description':
          'Read 10 self-improvement books in 30 days to expand your knowledge.',
      'duration': 30,
      'difficulty': 3,
      'sigmaPoints': 350,
    },
    {
      'id': 5,
      'title': 'No Complaining for 14 Days',
      'description':
          'Go 14 days without complaining to develop a positive mindset.',
      'duration': 14,
      'difficulty': 4,
      'sigmaPoints': 300,
    },
  ];

  // Default Routine Templates
  static const List<Map<String, dynamic>> defaultRoutines = [
    {
      'id': 1,
      'title': 'Sigma Morning Routine',
      'description': 'The ultimate morning routine for peak productivity.',
      'tasks': [
        {'time': '05:00', 'activity': 'Wake up & hydrate'},
        {'time': '05:15', 'activity': '15 minutes meditation'},
        {'time': '05:30', 'activity': '45 minutes workout'},
        {'time': '06:15', 'activity': 'Cold shower'},
        {'time': '06:30', 'activity': 'Protein-rich breakfast'},
        {'time': '07:00', 'activity': 'Planning for the day'},
        {'time': '07:30', 'activity': 'Deep work session'},
      ],
      'category': 'productivity',
    },
    {
      'id': 2,
      'title': 'Sigma Fitness Protocol',
      'description':
          'Optimized fitness routine for strength and mental toughness.',
      'tasks': [
        {'time': '00:00', 'activity': '10 minutes dynamic stretching'},
        {'time': '00:10', 'activity': '5 minutes jump rope'},
        {'time': '00:15', 'activity': '30 minutes compound lifts'},
        {'time': '00:45', 'activity': '15 minutes HIIT'},
        {'time': '01:00', 'activity': '5 minutes static stretching'},
        {'time': '01:05', 'activity': 'Cold shower'},
      ],
      'category': 'fitness',
    },
  ];

  // Knowledge Base Categories
  static const List<Map<String, dynamic>> knowledgeCategories = [
    {
      'id': 1,
      'title': 'Financial Independence',
      'icon': 'assets/images/financial.png',
      'articles': 24,
    },
    {
      'id': 2,
      'title': 'Mental Toughness',
      'icon': 'assets/images/mental.png',
      'articles': 18,
    },
    {
      'id': 3,
      'title': 'Minimalism',
      'icon': 'assets/images/minimalism.png',
      'articles': 15,
    },
    {
      'id': 4,
      'title': 'High Performance',
      'icon': 'assets/images/performance.png',
      'articles': 22,
    },
    {
      'id': 5,
      'title': 'Strategic Solitude',
      'icon': 'assets/images/solitude.png',
      'articles': 12,
    },
  ];

  // Focus Session Presets
  static const List<Map<String, dynamic>> focusPresets = [
    {
      'id': 1,
      'title': 'Deep Work',
      'duration': 90,
      'breakInterval': 0,
      'breakDuration': 0,
    },
    {
      'id': 2,
      'title': 'Pomodoro',
      'duration': 25,
      'breakInterval': 25,
      'breakDuration': 5,
    },
    {
      'id': 3,
      'title': 'Sustained Focus',
      'duration': 50,
      'breakInterval': 50,
      'breakDuration': 10,
    },
  ];

  // Personality Test Questions
  static const List<Map<String, dynamic>> personalityQuestions = [
    // Independence questions
    {
      'id': 1,
      'question': 'I prefer working alone rather than in teams.',
      'trait': 'Independence',
    },
    {
      'id': 2,
      'question':
          'I make decisions based on my own judgment rather than seeking consensus.',
      'trait': 'Independence',
    },
    {
      'id': 3,
      'question': 'I can comfortably spend extended periods of time alone.',
      'trait': 'Independence',
    },
    {
      'id': 4,
      'question':
          'I rarely ask for help, even when facing difficult challenges.',
      'trait': 'Independence',
    },
    {
      'id': 5,
      'question':
          'My personal values guide my actions more than societal expectations.',
      'trait': 'Independence',
    },

    // Social Detachment questions
    {
      'id': 6,
      'question': 'I feel little need to participate in social gatherings.',
      'trait': 'Social Detachment',
    },
    {
      'id': 7,
      'question':
          'I often observe social dynamics without actively participating.',
      'trait': 'Social Detachment',
    },
    {
      'id': 8,
      'question':
          'I have a small circle of close connections rather than many acquaintances.',
      'trait': 'Social Detachment',
    },
    {
      'id': 9,
      'question': 'I rarely share details about my personal life with others.',
      'trait': 'Social Detachment',
    },
    {
      'id': 10,
      'question': 'I value my privacy more than social recognition.',
      'trait': 'Social Detachment',
    },

    // Confidence questions
    {
      'id': 11,
      'question': 'I remain calm under pressure and in unfamiliar situations.',
      'trait': 'Confidence',
    },
    {
      'id': 12,
      'question': 'I speak my mind even when my opinion is unpopular.',
      'trait': 'Confidence',
    },
    {
      'id': 13,
      'question': 'I am comfortable with silence in conversations.',
      'trait': 'Confidence',
    },
    {
      'id': 14,
      'question': 'I rarely seek validation or approval from others.',
      'trait': 'Confidence',
    },
    {
      'id': 15,
      'question': 'I maintain eye contact during conversations.',
      'trait': 'Confidence',
    },

    // Mindset questions
    {
      'id': 16,
      'question': 'I view obstacles as opportunities for growth.',
      'trait': 'Mindset',
    },
    {
      'id': 17,
      'question': 'I prioritize long-term goals over immediate gratification.',
      'trait': 'Mindset',
    },
    {
      'id': 18,
      'question':
          'I actively seek knowledge and continuously learn new skills.',
      'trait': 'Mindset',
    },
    {
      'id': 19,
      'question': 'I take full responsibility for my failures and successes.',
      'trait': 'Mindset',
    },
    {
      'id': 20,
      'question':
          'I reflect on my experiences and adapt my approach accordingly.',
      'trait': 'Mindset',
    },

    // Success Drive questions
    {
      'id': 21,
      'question':
          'I have clear, specific goals that I consistently work towards.',
      'trait': 'Success Drive',
    },
    {
      'id': 22,
      'question': 'I maintain discipline even when no one is watching.',
      'trait': 'Success Drive',
    },
    {
      'id': 23,
      'question': 'I regularly step outside my comfort zone to grow.',
      'trait': 'Success Drive',
    },
    {
      'id': 24,
      'question': 'I pursue excellence in everything I undertake.',
      'trait': 'Success Drive',
    },
    {
      'id': 25,
      'question':
          'I am willing to sacrifice short-term pleasure for long-term success.',
      'trait': 'Success Drive',
    },
  ];

  // Motivational Quotes
  static const List<String> sigmaQuotes = [
    "Silence is better than unecessary drama.",
    "A lion doesn't concern himself with the opinions of sheep.",
    "Create a life that feels good on the inside, not one that just looks good on the outside.",
    "Be selective with your battles. Sometimes peace is better than being right.",
    "Your success is found in your daily routine.",
    "Discipline is choosing between what you want now and what you want most.",
    "The quieter you become, the more you can hear.",
    "Build in silence. Let your success be the noise.",
    "When nobody believes in you, you must believe in yourself.",
    "The strongest people are not those who show strength in front of us, but those who win battles we know nothing about.",
  ];
}
