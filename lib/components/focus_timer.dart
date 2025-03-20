import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sigma_path/theme/app_theme.dart';

class FocusTimer extends StatefulWidget {
  final int durationMinutes;
  final int breakIntervalMinutes;
  final int breakDurationMinutes;
  final Function() onComplete;
  final Function() onCancel;

  const FocusTimer({
    super.key,
    required this.durationMinutes,
    this.breakIntervalMinutes = 0,
    this.breakDurationMinutes = 0,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  late Timer _timer;
  late int _totalSeconds;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isBreak = false;
  int _sessionCount = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();

          if (_isBreak) {
            // Break is over, start new session if we have a break interval
            _isBreak = false;
            _remainingSeconds = widget.durationMinutes * 60;
            _startTimer();
          } else {
            _sessionCount++;

            // Check if we should take a break
            if (widget.breakIntervalMinutes > 0 &&
                _sessionCount <
                    widget.durationMinutes / widget.breakIntervalMinutes) {
              _isBreak = true;
              _remainingSeconds = widget.breakDurationMinutes * 60;
              _startTimer();
            } else {
              // Session complete
              _isRunning = false;
              widget.onComplete();
            }
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _cancelTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
    widget.onCancel();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 15.0,
          percent: _remainingSeconds / _totalSeconds,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isBreak ? 'BREAK TIME' : 'FOCUSING',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color:
                      _isBreak ? AppTheme.successColor : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          progressColor:
              _isBreak ? AppTheme.successColor : AppTheme.primaryColor,
          backgroundColor: Colors.grey[800]!,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRunning && _remainingSeconds == _totalSeconds)
              ElevatedButton.icon(
                onPressed: _startTimer,
                icon: const Icon(Icons.play_arrow),
                label: const Text('START'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? 'PAUSE' : 'RESUME'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor:
                      _isRunning ? Colors.amber : AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _cancelTimer,
                icon: const Icon(Icons.stop),
                label: const Text('CANCEL'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
