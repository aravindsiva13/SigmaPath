import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/components/focus_timer.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';
import 'package:sigma_path/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFocusActive = false;
  FocusSession? _activeSession;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkActiveSession();
  }

  void _checkActiveSession() {
    final focusProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);
    if (focusProvider.activeSession != null) {
      setState(() {
        _isFocusActive = true;
        _activeSession = focusProvider.activeSession;
      });
    }
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
        title: const Text('Sigma Focus Mode'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'FOCUS TIMER'),
            Tab(text: 'HISTORY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _isFocusActive ? _buildActiveSession() : _buildFocusSessionSelector(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildActiveSession() {
    if (_activeSession == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _activeSession!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deep work session to eliminate distractions',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          FocusTimer(
            durationMinutes: _activeSession!.duration,
            breakIntervalMinutes: _activeSession!.breakInterval,
            breakDurationMinutes: _activeSession!.breakDuration,
            onComplete: () async {
              // Session completed
              _activeSession!.complete();

              await MockApi().completeFocusSession(_activeSession!);

              // Update provider
              final focusProvider =
                  Provider.of<FocusSessionProvider>(context, listen: false);
              focusProvider.completeActiveSession();

              setState(() {
                _isFocusActive = false;
                _activeSession = null;
              });

              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Focus session completed! Sigma points earned.'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            onCancel: () async {
              // Session cancelled
              final focusProvider =
                  Provider.of<FocusSessionProvider>(context, listen: false);
              focusProvider.cancelActiveSession();

              setState(() {
                _isFocusActive = false;
                _activeSession = null;
              });
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Focus without distraction for ${_activeSession!.duration} minutes to strengthen your discipline and mental clarity.',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFocusSessionSelector() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Stats row
          _buildStatsRow(),
          const SizedBox(height: 24),

          // Focus Presets
          const Text(
            'FOCUS SESSION PRESETS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),

          // Preset cards
          ...Constants.focusPresets
              .map((preset) => _buildPresetCard(
                    title: preset['title'],
                    duration: preset['duration'],
                    breakInterval: preset['breakInterval'],
                    breakDuration: preset['breakDuration'],
                  ))
              .toList(),

          const SizedBox(height: 32),

          // Custom session button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showCustomSessionDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('CREATE CUSTOM SESSION'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Website blocker section
          const Text(
            'DISTRACTION BLOCKER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),

          _buildDistractionBlockerCard(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final focusProvider = Provider.of<FocusSessionProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          icon: Icons.access_time,
          value: '${focusProvider.totalFocusMinutes}',
          label: 'MINUTES FOCUSED',
          color: AppTheme.primaryColor,
        ),
        _buildStatCard(
          icon: Icons.calendar_today,
          value: '${focusProvider.completedSessions.length}',
          label: 'TOTAL SESSIONS',
          color: AppTheme.secondaryColor,
        ),
        _buildStatCard(
          icon: Icons.today,
          value: '${focusProvider.sessionsToday}',
          label: 'TODAY',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard({
    required String title,
    required int duration,
    required int breakInterval,
    required int breakDuration,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _startFocusSession(
            title: title,
            duration: duration,
            breakInterval: breakInterval,
            breakDuration: breakDuration,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getPresetIcon(title),
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPresetDescription(
                        duration: duration,
                        breakInterval: breakInterval,
                        breakDuration: breakDuration,
                      ),
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistractionBlockerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Website Blocker',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Block distracting websites during focus',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Common distractions to block:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBlockSiteChip('facebook.com'),
                _buildBlockSiteChip('twitter.com'),
                _buildBlockSiteChip('instagram.com'),
                _buildBlockSiteChip('youtube.com'),
                _buildBlockSiteChip('reddit.com'),
                _buildBlockSiteChip('netflix.com'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: Feature available when starting a focus session. This is a mock implementation as Flutter mobile apps cannot actually block websites.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockSiteChip(String site) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.public,
            size: 14,
            color: Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            site,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final focusProvider = Provider.of<FocusSessionProvider>(context);
    final completedSessions = focusProvider.completedSessions;

    if (completedSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Focus Sessions Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Complete your first focus session to start building your focus history.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Focus time chart
          Card(
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
                    'FOCUS TIME THIS WEEK',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: _buildFocusChart(completedSessions),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Session history
          const Text(
            'SESSION HISTORY',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),

          ...completedSessions
              .sorted((a, b) => b.completedAt!.compareTo(a.completedAt!))
              .map((session) => _buildSessionHistoryItem(session))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildFocusChart(List<FocusSession> sessions) {
    // Group sessions by day
    final now = DateTime.now();
    final weekSessions = sessions.where((session) {
      final sessionDate = session.completedAt ?? DateTime.now();
      return now.difference(sessionDate).inDays < 7;
    }).toList();

    // Create a map for days of the week
    final Map<int, int> minutesByDay = {};
    for (var i = 0; i < 7; i++) {
      minutesByDay[i] = 0;
    }

    // Populate the map with session data
    for (final session in weekSessions) {
      if (session.completedAt != null) {
        final dayOfWeek =
            session.completedAt!.weekday - 1; // 0-6, with 0 being Monday
        minutesByDay[dayOfWeek] =
            (minutesByDay[dayOfWeek] ?? 0) + session.actualDurationMinutes;
      }
    }

    // Create bar chart data
    final barGroups = minutesByDay.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: AppTheme.primaryColor,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: _getMaxY(minutesByDay.values.toList()),
        minY: 0,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    days[value.toInt() % 7],
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 30 != 0) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${value.toInt()}m',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 30,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.transparent,
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  double _getMaxY(List<int> values) {
    if (values.isEmpty) return 60;
    final maxValue = values.reduce((max, value) => max > value ? max : value);
    return (((maxValue ~/ 30) + 1) * 30).toDouble();
  }

  Widget _buildSessionHistoryItem(FocusSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getPresetIcon(session.title),
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.completedAt != null
                        ? _formatDateTime(session.completedAt!)
                        : 'Unknown date',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.actualDurationMinutes} min',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startFocusSession({
    required String title,
    required int duration,
    required int breakInterval,
    required int breakDuration,
  }) {
    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      duration: duration,
      breakInterval: breakInterval,
      breakDuration: breakDuration,
      createdAt: DateTime.now(),
      blockedWebsites: const [
        'facebook.com',
        'twitter.com',
        'instagram.com',
        'youtube.com',
        'reddit.com',
      ],
    );

    // Start session in provider
    Provider.of<FocusSessionProvider>(context, listen: false)
        .startSession(session);

    setState(() {
      _isFocusActive = true;
      _activeSession = session;
    });
  }

  void _showCustomSessionDialog() {
    final titleController = TextEditingController(text: 'Custom Focus');
    int duration = 25;
    int breakInterval = 0;
    int breakDuration = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Custom Session'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Session Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Focus Duration (minutes)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: duration.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: duration.toString(),
                    onChanged: (value) {
                      setState(() {
                        duration = value.round();
                      });
                    },
                  ),
                  Text('$duration minutes'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Include Breaks'),
                      Switch(
                        value: breakInterval > 0,
                        onChanged: (value) {
                          setState(() {
                            breakInterval = value ? 25 : 0;
                            breakDuration = value ? 5 : 0;
                          });
                        },
                        activeColor: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                  if (breakInterval > 0) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Break Interval (minutes)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: breakInterval.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      label: breakInterval.toString(),
                      onChanged: (value) {
                        setState(() {
                          breakInterval = value.round();
                        });
                      },
                    ),
                    Text('Every $breakInterval minutes'),
                    const SizedBox(height: 16),
                    const Text(
                      'Break Duration (minutes)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: breakDuration.toDouble(),
                      min: 1,
                      max: 15,
                      divisions: 14,
                      label: breakDuration.toString(),
                      onChanged: (value) {
                        setState(() {
                          breakDuration = value.round();
                        });
                      },
                    ),
                    Text('$breakDuration minutes'),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startFocusSession(
                    title: titleController.text.isNotEmpty
                        ? titleController.text
                        : 'Custom Focus',
                    duration: duration,
                    breakInterval: breakInterval,
                    breakDuration: breakDuration,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('START'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getPresetDescription({
    required int duration,
    required int breakInterval,
    required int breakDuration,
  }) {
    if (breakInterval > 0) {
      return '$duration min focus with $breakDuration min breaks every $breakInterval min';
    } else {
      return '$duration min deep focus without breaks';
    }
  }

  IconData _getPresetIcon(String title) {
    switch (title) {
      case 'Deep Work':
        return Icons.work;
      case 'Pomodoro':
        return Icons.timer;
      case 'Sustained Focus':
        return Icons.psychology;
      default:
        return Icons.timer;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/${dateTime.year} at $hour:$minute';
  }
}

extension ListExtension<T> on List<T> {
  List<T> sorted(int Function(T a, T b) compare) {
    final List<T> copy = List.from(this);
    copy.sort(compare);
    return copy;
  }
}
