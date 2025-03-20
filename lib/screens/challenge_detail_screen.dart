import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/components/challenge_completion_animation.dart';
import 'package:sigma_path/components/discipline_tracker.dart';
import 'package:sigma_path/components/sigma_confirmation_dialog.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({
    super.key,
    required this.challenge,
  }
});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> with SingleTickerProviderStateMixin {
  late Challenge _challenge;
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startChallenge() async {
    final result = await SigmaConfirmationDialog.show(
      context: context,
      title: 'Start Challenge',
      message: 'Are you ready to start the "${_challenge.title}" challenge? This requires daily commitment for ${_challenge.duration} days.',
      confirmText: 'START',
      cancelText: 'NOT YET',
      icon: Icons.fitness_center,
      onConfirm: () async {
        setState(() {
          _isLoading = true;
        });

        try {
          await MockApi().startChallenge(_challenge.id);
          final challenges = await MockApi().getChallenges();
          
          if (context.mounted) {
            Provider.of<ChallengeProvider>(context, listen: false)
                .setChallenges(challenges);
                
            final updatedChallenge = challenges.firstWhere((c) => c.id == _challenge.id);
            setState(() {
              _challenge = updatedChallenge;
              _isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
    
    if (result == true) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _checkInChallenge() async {
    final result = await SigmaConfirmationDialog.show(
      context: context,
      title: 'Daily Check-in',
      message: 'Confirm you\'ve completed today\'s challenge activities?',
      confirmText: 'CHECK IN',
      cancelText: 'NOT YET',
      icon: Icons.check_circle,
      iconColor: AppTheme.successColor,
      onConfirm: () async {
        setState(() {
          _isLoading = true;
        });

        try {
          await MockApi().checkInChallenge(_challenge.id);
          final challenges = await MockApi().getChallenges();
          
          if (context.mounted) {
            Provider.of<ChallengeProvider>(context, listen: false)
                .setChallenges(challenges);
                
            final updatedChallenge = challenges.firstWhere((c) => c.id == _challenge.id);
            
            // Check if challenge was completed with this check-in
            final wasJustCompleted = 
                !_challenge.isCompleted && updatedChallenge.isCompleted;
            
            setState(() {
              _challenge = updatedChallenge;
              _isLoading = false;
            });
            
            // Show completion animation if challenge was just completed
            if (wasJustCompleted && context.mounted) {
              showChallengeCompletionAnimation(context, _challenge);
            }
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
    
    if (result == true) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Details'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge header
                  _buildChallengeHeader(),
                  const SizedBox(height: 24),
                  
                  // Progress and tracker
                  if (_challenge.isActive || _challenge.isCompleted) ...[
                    _buildProgressSection(),
                    const SizedBox(height: 24),
                    DisciplineTracker(
                      checkInDates: _challenge.checkInDates,
                      currentStreak: _challenge.currentStreak,
                      longestStreak: _challenge.longestStreak,
                      canCheckInToday: _challenge.canCheckInToday(),
                      onCheckIn: _challenge.isActive && !_challenge.isCompleted && _challenge.canCheckInToday()
                          ? _checkInChallenge
                          : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Challenge description
                  const Text(
                    'ABOUT THIS CHALLENGE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _challenge.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Challenge details
                  const Text(
                    'CHALLENGE DETAILS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Duration', '${_challenge.duration} days'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Difficulty', 
                    _getDifficultyText(_challenge.difficulty),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Reward', 
                    '${_challenge.sigmaPoints} Sigma Points',
                  ),
                  const SizedBox(height: 24),
                  
                  // Benefits section
                  const Text(
                    'BENEFITS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._getChallengeBenefits().map((benefit) => _buildBenefitItem(benefit)),
                  const SizedBox(height: 32),
                  
                  // Action button
                  if (!_challenge.isActive && !_challenge.isCompleted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _startChallenge,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('START CHALLENGE'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  else if (_challenge.isActive && !_challenge.isCompleted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _challenge.canCheckInToday() ? _checkInChallenge : null,
                        icon: const Icon(Icons.check),
                        label: Text(_challenge.canCheckInToday() 
                            ? 'CHECK IN TODAY' 
                            : 'ALREADY CHECKED IN'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.successColor,
                          disabledBackgroundColor: Colors.grey[700],
                          disabledForegroundColor: Colors.grey[400],
                        ),
                      ),
                    )
                  else if (_challenge.isCompleted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('CHALLENGE COMPLETED'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.successColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildChallengeHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          )),
          child: FadeTransition(
            opacity: _animationController,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _challenge.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getDifficultyText(_challenge.difficulty),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          )),
          child: FadeTransition(
            opacity: _animationController,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROGRESS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_challenge.progressPercentage.toStringAsFixed(0)}% Complete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _getProgressColor(_challenge.progressPercentage),
                      ),
                    ),
                    Text(
                      '${_challenge.checkInDates.length}/${_challenge.duration} days',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _challenge.progressPercentage / 100,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(_challenge.progressPercentage),
                  ),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _challenge.startDate != null
                          ? 'Started on ${_formatDate(_challenge.startDate!)}'
                          : 'Not started yet',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (_challenge.isCompleted && _challenge.completionDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Completed on ${_formatDate(_challenge.completionDate!)}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'EASY';
      case 2:
        return 'MEDIUM';
      case 3:
        return 'HARD';
      case 4:
        return 'SIGMA';
      case 5:
        return 'EXTREME';
      default:
        return 'UNKNOWN';
    }
  }

  String _getStatusText() {
    if (_challenge.isCompleted) {
      return 'COMPLETED';
    } else if (_challenge.isActive) {
      return 'IN PROGRESS';
    } else {
      return 'NOT STARTED';
    }
  }

  IconData _getStatusIcon() {
    if (_challenge.isCompleted) {
      return Icons.check_circle;
    } else if (_challenge.isActive) {
      return Icons.access_time;
    } else {
      return Icons.play_circle_outline;
    }
  }

  Color _getStatusColor() {
    if (_challenge.isCompleted) {
      return AppTheme.successColor;
    } else if (_challenge.isActive) {
      return Colors.orange;
    } else {
      return AppTheme.secondaryColor;
    }
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 100) {
      return AppTheme.successColor;
    } else if (percentage >= 75) {
      return Colors.greenAccent;
    } else if (percentage >= 50) {
      return Colors.amberAccent;
    } else if (percentage >= 25) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<String> _getChallengeBenefits() {
    // This would typically come from the API or a more comprehensive model
    // For now, we'll generate some benefits based on the challenge title
    final title = _challenge.title.toLowerCase();
    
    if (title.contains('social media')) {
      return [
        'Reduced digital distraction and improved focus',
        'More time for meaningful, real-world activities',
        'Better mental health and reduced anxiety',
        'Improved sleep quality by reducing blue light exposure',
        'Greater awareness of how you spend your time',
      ];
    } else if (title.contains('cold shower')) {
      return [
        'Increased alertness and energy levels',
        'Improved circulation and immune function',
        'Enhanced mental resilience and willpower',
        'Reduced muscle soreness after workouts',
        'Lower stress levels and improved mood',
      ];
    } else if (title.contains('wake up') || title.contains('5 am')) {
      return [
        'More productive morning hours with fewer distractions',
        'Better alignment with natural circadian rhythms',
        'Increased discipline and self-mastery',
        'More time for personal development before work',
        'Greater sense of control over your day',
      ];
    } else if (title.contains('book')) {
      return [
        'Expanded knowledge and perspective',
        'Improved vocabulary and communication skills',
        'Enhanced critical thinking and analysis',
        'Better focus and longer attention span',
        'Reduced stress through mental engagement',
      ];
    } else {
      return [
        'Increased self-discipline and willpower',
        'Greater self-awareness and personal growth',
        'Enhanced resilience in facing challenges',
        'Improved ability to set and achieve goals',
        'Development of the true Sigma mindset',
      ];
    }
  }