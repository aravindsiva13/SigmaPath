import 'package:flutter/material.dart';
import 'package:sigma_path/theme/app_theme.dart';

class StreakProgressIndicator extends StatelessWidget {
  final int totalDays;
  final int completedDays;
  final int streakGoal;
  final bool animate;

  const StreakProgressIndicator({
    super.key,
    required this.totalDays,
    required this.completedDays,
    this.streakGoal = 0,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = maxWidth / totalDays;

        return SizedBox(
          height: 50,
          child: Stack(
            children: [
              // Progress background
              Container(
                height: 10,
                width: maxWidth,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              // Progress fill
              if (completedDays > 0)
                AnimatedContainer(
                  duration: animate
                      ? const Duration(milliseconds: 800)
                      : Duration.zero,
                  curve: Curves.easeOutQuart,
                  height: 10,
                  width: (completedDays / totalDays) * maxWidth,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

              // Day indicators
              ...List.generate(totalDays, (index) {
                final isCompleted = index < completedDays;
                final isStreak =
                    streakGoal > 0 && (index + 1) % streakGoal == 0;

                return Positioned(
                  left: index * itemWidth + (itemWidth / 2) - 12,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: animate
                            ? const Duration(milliseconds: 500)
                            : Duration.zero,
                        curve: Curves.easeOutBack,
                        width: isStreak ? 28 : 24,
                        height: isStreak ? 28 : 24,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? isStreak
                                  ? Colors.amber
                                  : AppTheme.primaryColor
                              : Colors.grey[700],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isStreak
                                ? Colors.amber
                                : isCompleted
                                    ? AppTheme.primaryColor
                                    : Colors.grey[600]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  isStreak
                                      ? Icons.workspace_premium
                                      : Icons.check,
                                  color: Colors.white,
                                  size: isStreak ? 16 : 14,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (isStreak && (index + 1) <= totalDays) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${index + 1}d',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
