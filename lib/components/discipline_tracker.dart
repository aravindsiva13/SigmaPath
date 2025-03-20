// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sigma_path/api/mock_api.dart';
// import 'package:sigma_path/components/sigma_score_indicator.dart';
// import 'package:sigma_path/models/app_models.dart';
// import 'package:sigma_path/theme/app_theme.dart';
// import 'package:sigma_path/utils/constants.dart';

// class PersonalityTestScreen extends StatefulWidget {
//   const PersonalityTestScreen({super.key});

//   @override
//   State<PersonalityTestScreen> createState() => _PersonalityTestScreenState();
// }

// class _PersonalityTestScreenState extends State<PersonalityTestScreen> {
//   final PageController _pageController = PageController();
//   List<PersonalityQuestion> _questions = [];
//   bool _isLoading = true;
//   bool _testCompleted = false;
//   Map<String, int> _results = {};
//   int _currentPage = 0;
//   int _totalPages = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadQuestions();
//   }

//   Future<void> _loadQuestions() async {
//     try {
//       final questions = await MockApi().getPersonalityQuestions();
//       setState(() {
//         _questions = questions;
//         _isLoading = false;
//         _totalPages = questions.length;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading questions: $e')),
//       );
//     }
//   }

//   void _nextPage() {
//     if (_currentPage < _totalPages - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _completeTest();
//     }
//   }

//   void _previousPage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   Future<void> _completeTest() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final results = await MockApi().updatePersonalityTest(_questions);

//       setState(() {
//         _testCompleted = true;
//         _results = results;
//         _isLoading = false;
//       });

//       // Update the user provider
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.updateTraitScores(results);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error submitting test: $e')),
//       );
//     }
//   }

//   void _answerQuestion(int questionIndex, int answerValue) {
//     setState(() {
//       _questions[questionIndex] = _questions[questionIndex].copyWith(
//         answer: answerValue,
//       );
//     });
//   }

//   bool _canContinue() {
//     if (_currentPage >= _questions.length) return false;
//     return _questions[_currentPage].answer != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sigma Personality Test'),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _testCompleted
//               ? _buildResultsPage()
//               : _buildTestPage(),
//     );
//   }

//   Widget _buildTestPage() {
//     return Column(
//       children: [
//         // Progress indicator
//         LinearProgressIndicator(
//           value: (_currentPage + 1) / _totalPages,
//           backgroundColor: Colors.grey[800],
//           valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
//           minHeight: 6,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Question ${_currentPage + 1} of $_totalPages',
//                 style: TextStyle(
//                   color: AppTheme.textSecondaryColor,
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 'Trait: ${_currentPage < _questions.length ? _questions[_currentPage].trait : ""}',
//                 style: TextStyle(
//                   color: AppTheme.primaryColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Question pages
//         Expanded(
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: _questions.length,
//             physics: const NeverScrollableScrollPhysics(),
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               final question = _questions[index];
//               return Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       question.question,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     _buildAnswerOptions(index, question.answer),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         // Navigation buttons
//         Padding(
//           padding: const EdgeInsets.all(24),
//           child: Row(
//             children: [
//               if (_currentPage > 0)
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: _previousPage,
//                     child: const Text('PREVIOUS'),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       side: BorderSide(color: AppTheme.primaryColor),
//                     ),
//                   ),
//                 ),
//               if (_currentPage > 0) const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: _canContinue() ? _nextPage : null,
//                   child: Text(
//                       _currentPage == _totalPages - 1 ? 'COMPLETE' : 'NEXT'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAnswerOptions(int questionIndex, int? selectedAnswer) {
//     return Column(
//       children: List.generate(5, (answerValue) {
//         final value = answerValue + 1; // 1-5 scale
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: InkWell(
//             onTap: () => _answerQuestion(questionIndex, value),
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: selectedAnswer == value
//                     ? AppTheme.primaryColor.withOpacity(0.2)
//                     : Colors.transparent,
//                 border: Border.all(
//                   color: selectedAnswer == value
//                       ? AppTheme.primaryColor
//                       : Colors.grey[700]!,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: selectedAnswer == value
//                           ? AppTheme.primaryColor
//                           : Colors.transparent,
//                       border: Border.all(
//                         color: selectedAnswer == value
//                             ? AppTheme.primaryColor
//                             : Colors.grey[600]!,
//                         width: 2,
//                       ),
//                     ),
//                     child: selectedAnswer == value
//                         ? const Icon(
//                             Icons.check,
//                             size: 16,
//                             color: Colors.white,
//                           )
//                         : null,
//                   ),
//                   const SizedBox(width: 16),
//                   Text(
//                     _getAnswerText(value),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: selectedAnswer == value
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       color: selectedAnswer == value
//                           ? AppTheme.primaryColor
//                           : AppTheme.textPrimaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   String _getAnswerText(int value) {
//     switch (value) {
//       case 1:
//         return 'Strongly Disagree';
//       case 2:
//         return 'Disagree';
//       case 3:
//         return 'Neutral';
//       case 4:
//         return 'Agree';
//       case 5:
//         return 'Strongly Agree';
//       default:
//         return '';
//     }
//   }

//   Widget _buildResultsPage() {
//     final user = Provider.of<UserProvider>(context).user;
//     if (user == null) return const Center(child: CircularProgressIndicator());

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'YOUR SIGMA SCORE',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _getSigmaScoreDescription(user.sigmaScore),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppTheme.textSecondaryColor,
//               ),
//             ),
//             const SizedBox(height: 32),
//             SigmaScoreIndicator(
//               score: user.sigmaScore,
//               size: 180,
//               traitScores: user.traitScores,
//               showTraits: true,
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               'TRAIT ANALYSIS',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...Constants.traits
//                 .map((trait) => _buildTraitAnalysis(
//                       trait,
//                       user.traitScores[trait] ?? 0,
//                     ))
//                 .toList(),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('RETURN TO DASHBOARD'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTraitAnalysis(String trait, int score) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 trait.toUpperCase(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 score.toString(),
//                 style: TextStyle(
//                   color: _getScoreColor(score),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: score / 100,
//             backgroundColor: Colors.grey[800],
//             valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
//             minHeight: 8,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _getTraitDescription(trait, score),
//             style: TextStyle(
//               color: AppTheme.textSecondaryColor,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getScoreColor(int score) {
//     if (score >= 90) {
//       return AppTheme.primaryColor;
//     } else if (score >= 75) {
//       return AppTheme.secondaryColor;
//     } else if (score >= 60) {
//       return Colors.greenAccent;
//     } else if (score >= 40) {
//       return Colors.amberAccent;
//     } else if (score >= 25) {
//       return Colors.orangeAccent;
//     } else {
//       return Colors.redAccent;
//     }
//   }

//   String _getSigmaScoreDescription(int score) {
//     if (score >= 90) {
//       return 'You embody the true Sigma Male mindset. Your exceptional self-reliance and mental clarity set you apart.';
//     } else if (score >= 75) {
//       return 'You strongly align with the Sigma Male archetype. With some focus on specific traits, you can reach your full potential.';
//     } else if (score >= 60) {
//       return 'You display many Sigma Male characteristics. Continue developing your independence and self-confidence.';
//     } else if (score >= 40) {
//       return 'You show potential but need to work on core Sigma traits. Focus on self-improvement and mental toughness.';
//     } else {
//       return 'You currently align more with traditional social hierarchies. Developing independence and self-mastery will help you cultivate the Sigma mindset.';
//     }
//   }

//   String _getTraitDescription(String trait, int score) {
//     switch (trait) {
//       case 'Independence':
//         if (score >= 75) {
//           return 'You excel at making decisions on your own and rarely need external validation.';
//         } else if (score >= 50) {
//           return 'You display good autonomy but sometimes rely on others for support or guidance.';
//         } else {
//           return 'Consider developing greater self-reliance and decision-making confidence.';
//         }
//       case 'Social Detachment':
//         if (score >= 75) {
//           return 'You maintain a healthy distance from social hierarchies and navigate social settings on your own terms.';
//         } else if (score >= 50) {
//           return 'You balance social engagement with personal space but could benefit from more strategic detachment.';
//         } else {
//           return 'You may be overly concerned with social acceptance and validation.';
//         }
//       case 'Confidence':
//         if (score >= 75) {
//           return 'Your self-assurance is exceptional and unwavering, even in challenging situations.';
//         } else if (score >= 50) {
//           return 'You display good confidence in familiar settings but could strengthen it in unfamiliar territory.';
//         } else {
//           return 'Focus on building inner confidence regardless of external circumstances.';
//         }
//       case 'Mindset':
//         if (score >= 75) {
//           return 'You possess a growth-oriented mindset and excel at critical thinking and self-reflection.';
//         } else if (score >= 50) {
//           return 'You show good mental resilience but could benefit from more consistent strategic thinking.';
//         } else {
//           return 'Developing mental discipline and strategic thinking will greatly enhance your sigma potential.';
//         }
//       case 'Success Drive':
//         if (score >= 75) {
//           return 'Your dedication to personal excellence and goal achievement is remarkable.';
//         } else if (score >= 50) {
//           return 'You have good ambition but could improve consistency in pursuing long-term objectives.';
//         } else {
//           return 'Focus on defining clear goals and building the discipline to achieve them.';
//         }
//       default:
//         return 'Analyze your score and identify areas for improvement.';
//     }
//   }
// }

//2

import 'package:flutter/material.dart';
import 'package:sigma_path/theme/app_theme.dart';

class DisciplineTracker extends StatelessWidget {
  final List<DateTime> checkInDates;
  final int currentStreak;
  final int longestStreak;
  final Function()? onCheckIn;
  final bool canCheckInToday;

  const DisciplineTracker({
    super.key,
    required this.checkInDates,
    required this.currentStreak,
    required this.longestStreak,
    this.onCheckIn,
    this.canCheckInToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DISCIPLINE TRACKER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn(
                  icon: Icons.local_fire_department,
                  value: currentStreak.toString(),
                  label: 'CURRENT\nSTREAK',
                  color: Colors.orange,
                ),
                _buildStatColumn(
                  icon: Icons.emoji_events,
                  value: longestStreak.toString(),
                  label: 'BEST\nSTREAK',
                  color: Colors.amber,
                ),
                _buildStatColumn(
                  icon: Icons.calendar_today,
                  value: checkInDates.length.toString(),
                  label: 'TOTAL\nDAYS',
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'LAST 7 DAYS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = DateTime.now().subtract(Duration(days: 6 - index));
                final isCheckedIn = _isDateCheckedIn(date);

                return _buildDayCircle(
                  dayOfWeek: _getDayOfWeek(date.weekday),
                  date: date.day.toString(),
                  isCheckedIn: isCheckedIn,
                  isToday: index == 6,
                );
              }),
            ),
            const SizedBox(height: 24),
            if (canCheckInToday && onCheckIn != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCheckIn,
                  icon: const Icon(Icons.check),
                  label: const Text('CHECK IN TODAY'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppTheme.successColor,
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check),
                  label: Text(
                    checkInDates.isEmpty
                        ? 'START YOUR STREAK'
                        : 'ALREADY CHECKED IN',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    disabledBackgroundColor: Colors.grey[800],
                    disabledForegroundColor: Colors.grey[400],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDayCircle({
    required String dayOfWeek,
    required String date,
    required bool isCheckedIn,
    required bool isToday,
  }) {
    return Column(
      children: [
        Text(
          dayOfWeek,
          style: TextStyle(
            fontSize: 12,
            color:
                isToday ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCheckedIn ? AppTheme.successColor : Colors.transparent,
            border: Border.all(
              color: isToday
                  ? isCheckedIn
                      ? AppTheme.successColor
                      : AppTheme.primaryColor
                  : isCheckedIn
                      ? AppTheme.successColor
                      : Colors.grey[700]!,
              width: isToday ? 2 : 1,
            ),
          ),
          child: Center(
            child: isCheckedIn
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  bool _isDateCheckedIn(DateTime date) {
    final formattedDate = DateTime(date.year, date.month, date.day);

    return checkInDates.any((checkIn) {
      final formattedCheckIn = DateTime(
        checkIn.year,
        checkIn.month,
        checkIn.day,
      );
      return formattedCheckIn.isAtSameMomentAs(formattedDate);
    });
  }

  String _getDayOfWeek(int dayNum) {
    switch (dayNum) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }
}
