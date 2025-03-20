import 'package:flutter/material.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/components/sigma_score_indicator.dart';
import 'package:sigma_path/theme/app_theme.dart';

class SigmaProfileWidget extends StatelessWidget {
  final User user;
  final VoidCallback? onTakeTest;

  const SigmaProfileWidget({
    super.key,
    required this.user,
    this.onTakeTest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${user.level} Sigma',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLevelProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(
                icon: Icons.workspace_premium,
                value: user.sigmaPoints.toString(),
                label: 'POINTS',
                color: Colors.amber,
              ),
              _buildStatColumn(
                icon: Icons.emoji_events,
                value: user.achievements.length.toString(),
                label: 'ACHIEVEMENTS',
                color: AppTheme.secondaryColor,
              ),
              _buildStatColumn(
                icon: Icons.calendar_today,
                value: user.daysActive.toString(),
                label: 'DAYS ACTIVE',
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SIGMA SCORE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              if (onTakeTest != null)
                TextButton.icon(
                  onPressed: onTakeTest,
                  icon: const Icon(Icons.analytics, size: 16),
                  label: const Text('TAKE TEST'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: SigmaScoreIndicator(
              score: user.sigmaScore,
              size: 120,
              traitScores: user.traitScores,
              showTraits: true,
            ),
          ),
          const SizedBox(height: 24),
          if (user.achievements.isNotEmpty) ...[
            const Text(
              'RECENT ACHIEVEMENTS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: user.achievements.length.clamp(0, 5),
                itemBuilder: (context, index) {
                  final achievement = user.achievements[index];
                  return _buildAchievementItem(achievement);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          user.username.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelProgressIndicator() {
    // Mock progress calculation
    final levelProgress = (user.sigmaPoints % 1000) / 1000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level ${user.level}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            Text(
              'Level ${user.level + 1}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: levelProgress,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          minHeight: 5,
          borderRadius: BorderRadius.circular(2.5),
        ),
        const SizedBox(height: 4),
        Text(
          '${(levelProgress * 100).toInt()}% to Level ${user.level + 1}',
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 10,
          ),
        ),
      ],
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
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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
        ),
      ],
    );
  }

  Widget _buildAchievementItem(SigmaAchievement achievement) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
