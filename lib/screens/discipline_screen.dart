import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/components/challenge_card.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';

class DisciplineScreen extends StatefulWidget {
  const DisciplineScreen({super.key});

  @override
  State<DisciplineScreen> createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends State<DisciplineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Challenges'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'ACTIVE'),
            Tab(text: 'AVAILABLE'),
            Tab(text: 'COMPLETED'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ActiveChallengesTab(),
          AvailableChallengesTab(),
          CompletedChallengesTab(),
        ],
      ),
    );
  }
}

class ActiveChallengesTab extends StatelessWidget {
  const ActiveChallengesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final activeChallenges = challengeProvider.activeChallenges;

    if (activeChallenges.isEmpty) {
      return const _EmptyChallengeState(
        title: 'No Active Challenges',
        message:
            'Start a challenge to build your Sigma mindset and discipline.',
        icon: Icons.fitness_center,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: activeChallenges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ChallengeCard(
              challenge: activeChallenges[index],
              onTap: () {
                // Show challenge details
                _showChallengeDetails(context, activeChallenges[index]);
              },
              onCheckIn: activeChallenges[index].canCheckInToday()
                  ? () async {
                      await MockApi()
                          .checkInChallenge(activeChallenges[index].id);

                      // Refresh challenges
                      final challenges = await MockApi().getChallenges();
                      Provider.of<ChallengeProvider>(context, listen: false)
                          .setChallenges(challenges);

                      // Show success message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully checked in!'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      }
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class AvailableChallengesTab extends StatelessWidget {
  const AvailableChallengesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final availableChallenges = challengeProvider.availableChallenges;

    if (availableChallenges.isEmpty) {
      return const _EmptyChallengeState(
        title: 'No Available Challenges',
        message: 'All challenges are either active or completed. Great job!',
        icon: Icons.check_circle,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: availableChallenges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ChallengeCard(
              challenge: availableChallenges[index],
              onTap: () {
                // Show challenge details
                _showChallengeDetails(context, availableChallenges[index]);
              },
              onStart: () async {
                await MockApi().startChallenge(availableChallenges[index].id);

                // Refresh challenges
                final challenges = await MockApi().getChallenges();
                Provider.of<ChallengeProvider>(context, listen: false)
                    .setChallenges(challenges);

                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Challenge started!'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class CompletedChallengesTab extends StatelessWidget {
  const CompletedChallengesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final completedChallenges = challengeProvider.completedChallenges;

    if (completedChallenges.isEmpty) {
      return const _EmptyChallengeState(
        title: 'No Completed Challenges',
        message:
            'Complete challenges to earn points and build your Sigma discipline.',
        icon: Icons.emoji_events,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: completedChallenges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ChallengeCard(
              challenge: completedChallenges[index],
              onTap: () {
                // Show challenge details
                _showChallengeDetails(context, completedChallenges[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyChallengeState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _EmptyChallengeState({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showChallengeDetails(BuildContext context, Challenge challenge) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              // Header with drag indicator
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              // Challenge title
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Challenge difficulty
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          _getDifficultyText(challenge.difficulty),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: AppTheme.secondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.sigmaPoints} Points',
                          style: const TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Challenge description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Challenge stats
              const Text(
                'Challenge Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatRow('Duration', '${challenge.duration} days'),
              const SizedBox(height: 8),
              _buildStatRow(
                'Start Date',
                challenge.startDate != null
                    ? _formatDate(challenge.startDate!)
                    : 'Not started',
              ),
              const SizedBox(height: 8),
              _buildStatRow(
                'Completion Date',
                challenge.completionDate != null
                    ? _formatDate(challenge.completionDate!)
                    : 'In progress',
              ),
              const SizedBox(height: 8),
              _buildStatRow(
                  'Current Streak', '${challenge.currentStreak} days'),
              const SizedBox(height: 8),
              _buildStatRow(
                  'Longest Streak', '${challenge.longestStreak} days'),
              const SizedBox(height: 24),

              // Progress
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: challenge.progressPercentage / 100,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(challenge.progressPercentage),
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Text(
                '${challenge.progressPercentage.toStringAsFixed(0)}% Complete',
                style: TextStyle(
                  color: _getProgressColor(challenge.progressPercentage),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              if (challenge.isActive && !challenge.isCompleted)
                ElevatedButton(
                  onPressed: challenge.canCheckInToday()
                      ? () async {
                          await MockApi().checkInChallenge(challenge.id);

                          // Refresh challenges
                          final challenges = await MockApi().getChallenges();
                          Provider.of<ChallengeProvider>(context, listen: false)
                              .setChallenges(challenges);

                          // Close the modal and show success message
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully checked in!'),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.successColor,
                  ),
                  child: const Text('CHECK IN TODAY'),
                )
              else if (!challenge.isActive && !challenge.isCompleted)
                ElevatedButton(
                  onPressed: () async {
                    await MockApi().startChallenge(challenge.id);

                    // Refresh challenges
                    final challenges = await MockApi().getChallenges();
                    Provider.of<ChallengeProvider>(context, listen: false)
                        .setChallenges(challenges);

                    // Close the modal and show success message
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Challenge started!'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('START CHALLENGE'),
                ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildStatRow(String label, String value) {
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

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
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
