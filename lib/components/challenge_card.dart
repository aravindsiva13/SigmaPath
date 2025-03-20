import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final Function()? onTap;
  final Function()? onCheckIn;
  final Function()? onStart;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onTap,
    this.onCheckIn,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      challenge.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDifficultyText(challenge.difficulty),
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge.duration} days',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.workspace_premium,
                    size: 16,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge.sigmaPoints} points',
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (challenge.isActive || challenge.isCompleted) ...[
                const SizedBox(height: 16),
                LinearPercentIndicator(
                  lineHeight: 8,
                  percent: challenge.progressPercentage / 100,
                  backgroundColor: Colors.grey[800],
                  progressColor:
                      _getProgressColor(challenge.progressPercentage),
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      challenge.isCompleted
                          ? 'COMPLETED'
                          : '${challenge.progressPercentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _getProgressColor(challenge.progressPercentage),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (challenge.isActive && !challenge.isCompleted)
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Streak: ${challenge.currentStreak}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (!challenge.isActive && !challenge.isCompleted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('START CHALLENGE'),
                  ),
                )
              else if (challenge.isActive &&
                  !challenge.isCompleted &&
                  challenge.canCheckInToday())
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onCheckIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppTheme.successColor,
                    ),
                    child: const Text('CHECK IN TODAY'),
                  ),
                )
              else if (challenge.isActive && !challenge.canCheckInToday())
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.grey[400],
                    ),
                    child: const Text('ALREADY CHECKED IN'),
                  ),
                ),
            ],
          ),
        ),
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
}
