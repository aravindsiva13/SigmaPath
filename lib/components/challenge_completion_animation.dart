import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';

class ChallengeCompletionAnimation extends StatefulWidget {
  final Challenge challenge;
  final VoidCallback onAnimationComplete;

  const ChallengeCompletionAnimation({
    super.key,
    required this.challenge,
    required this.onAnimationComplete,
  });

  @override
  State<ChallengeCompletionAnimation> createState() =>
      _ChallengeCompletionAnimationState();
}

class _ChallengeCompletionAnimationState
    extends State<ChallengeCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _controller.value,
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            );
          },
        ),

        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/animations/challenge_complete.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                    _controller.forward();
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Title
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: child,
                  );
                },
                child: const Text(
                  'CHALLENGE COMPLETED!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Challenge name
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value * 0.9,
                    child: child,
                  );
                },
                child: Text(
                  widget.challenge.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Points earned
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value * 0.8,
                    child: child,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        color: Colors.amber,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'POINTS EARNED',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '+${widget.challenge.sigmaPoints}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Continue button
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value * 0.7,
                    child: child,
                  );
                },
                child: ElevatedButton(
                  onPressed: widget.onAnimationComplete,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper method to show the challenge completion animation
void showChallengeCompletionAnimation(
  BuildContext context,
  Challenge challenge,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Challenge Completion',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return ChallengeCompletionAnimation(
        challenge: challenge,
        onAnimationComplete: () {
          Navigator.of(context).pop();
        },
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
