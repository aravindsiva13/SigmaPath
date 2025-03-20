import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/components/challenge_card.dart';
import 'package:sigma_path/components/sigma_score_indicator.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/screens/personality_test_screen.dart';
import 'package:sigma_path/screens/routines_screen.dart';
import 'package:sigma_path/screens/discipline_screen.dart';
import 'package:sigma_path/screens/knowledge_base_screen.dart';
import 'package:sigma_path/screens/focus_mode_screen.dart';
import 'package:sigma_path/theme/app_theme.dart';
import 'package:sigma_path/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final challengeProvider =
        Provider.of<ChallengeProvider>(context, listen: false);
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);
    final focusProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

    try {
      // Load data from MockApi
      final user = await MockApi().getUser();
      userProvider.setUser(user);

      final challenges = await MockApi().getChallenges();
      challengeProvider.setChallenges(challenges);

      final routines = await MockApi().getRoutines();
      routineProvider.setRoutines(routines);

      final focusSessions = await MockApi().getFocusSessions();
      focusProvider.setSessions(focusSessions);
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          DashboardPage(),
          DisciplineScreen(),
          RoutinesScreen(),
          KnowledgeBaseScreen(),
          FocusModeScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.cardColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Knowledge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _initializeData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final challengeProvider =
        Provider.of<ChallengeProvider>(context, listen: false);
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);
    final focusProvider =
        Provider.of<FocusSessionProvider>(context, listen: false);

    try {
      // Load data from MockApi
      final user = await MockApi().getUser();
      userProvider.setUser(user);

      final challenges = await MockApi().getChallenges();
      challengeProvider.setChallenges(challenges);

      final routines = await MockApi().getRoutines();
      routineProvider.setRoutines(routines);

      final focusSessions = await MockApi().getFocusSessions();
      focusProvider.setSessions(focusSessions);
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final activeChallenges = challengeProvider.activeChallenges;
    final routineProvider = Provider.of<RoutineProvider>(context);
    final activeRoutines = routineProvider.activeRoutines;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.username,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${user.sigmaPoints}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sigma Score
              Center(
                child: Column(
                  children: [
                    SigmaScoreIndicator(
                      score: user.sigmaScore,
                      size: 160,
                      traitScores: user.traitScores,
                      showTraits: false,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonalityTestScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text('TAKE SIGMA TEST'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context: context,
                    icon: Icons.trending_up,
                    label: 'Level',
                    value: user.level.toString(),
                    color: AppTheme.primaryColor,
                  ),
                  _buildStatCard(
                    context: context,
                    icon: Icons.calendar_today,
                    label: 'Days Active',
                    value: user.daysActive.toString(),
                    color: AppTheme.secondaryColor,
                  ),
                  _buildStatCard(
                    context: context,
                    icon: Icons.emoji_events,
                    label: 'Achievements',
                    value: user.achievements.length.toString(),
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Active Challenges Section
              const SectionHeader(
                title: 'ACTIVE CHALLENGES',
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 16),
              if (activeChallenges.isEmpty)
                const EmptyStateCard(
                  message:
                      'No active challenges. Start a challenge to build your Sigma mindset.',
                  actionText: 'BROWSE CHALLENGES',
                  icon: Icons.fitness_center,
                  navigateTo: 1, // Discipline screen index
                )
              else
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activeChallenges.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ChallengeCard(
                            challenge: activeChallenges[index],
                            onTap: () {
                              // Navigate to challenge details
                            },
                            onCheckIn: () async {
                              await MockApi()
                                  .checkInChallenge(activeChallenges[index].id);
                              await _initializeData(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),

              // Active Routines Section
              const SectionHeader(
                title: 'ACTIVE ROUTINES',
                icon: Icons.schedule,
              ),
              const SizedBox(height: 16),
              if (activeRoutines.isEmpty)
                const EmptyStateCard(
                  message:
                      'No active routines. Create a routine to structure your day like a Sigma.',
                  actionText: 'CREATE ROUTINE',
                  icon: Icons.schedule,
                  navigateTo: 2, // Routines screen index
                )
              else
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activeRoutines.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildRoutineCard(activeRoutines[index]),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),

              // Motivational Quote
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Constants.sigmaQuotes[
                          DateTime.now().day % Constants.sigmaQuotes.length],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'SIGMA MINDSET',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(Routine routine) {
    final completedTasksCount =
        routine.tasks.where((task) => task.isCompleted).length;
    final progress = routine.tasks.isEmpty
        ? 0.0
        : completedTasksCount / routine.tasks.length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Tasks: ${routine.tasks.length}',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? AppTheme.successColor : AppTheme.primaryColor,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text(
              '$completedTasksCount/${routine.tasks.length} tasks completed',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to routine details
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppTheme.secondaryColor,
                ),
                child: const Text('VIEW ROUTINE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final String message;
  final String actionText;
  final IconData icon;
  final int navigateTo;

  const EmptyStateCard({
    super.key,
    required this.message,
    required this.actionText,
    required this.icon,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (context.findAncestorStateOfType<_HomeScreenState>() !=
                    null) {
                  context
                      .findAncestorStateOfType<_HomeScreenState>()!
                      ._changePage(navigateTo);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
}
