import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sigma_path/theme/app_theme.dart';

class SigmaScoreIndicator extends StatelessWidget {
  final int score;
  final double size;
  final Map<String, int>? traitScores;
  final bool showTraits;

  const SigmaScoreIndicator({
    super.key,
    required this.score,
    this.size = 150,
    this.traitScores,
    this.showTraits = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: size / 2,
          lineWidth: size / 10,
          percent: score / 100,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: size / 3,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
              Text(
                'SIGMA SCORE',
                style: TextStyle(
                  fontSize: size / 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey[800]!,
          progressColor: _getScoreColor(score),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1500,
        ),
        if (showTraits && traitScores != null) ...[
          const SizedBox(height: 24),
          ...traitScores!.entries.map((entry) => _buildTraitIndicator(
                context,
                entry.key,
                entry.value,
              )),
        ],
      ],
    );
  }

  Widget _buildTraitIndicator(BuildContext context, String trait, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trait.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  color: _getScoreColor(value),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(value)),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) {
      return AppTheme.primaryColor;
    } else if (score >= 75) {
      return AppTheme.secondaryColor;
    } else if (score >= 60) {
      return Colors.greenAccent;
    } else if (score >= 40) {
      return Colors.amberAccent;
    } else if (score >= 25) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }
}
