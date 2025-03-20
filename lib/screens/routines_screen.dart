import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';
import 'package:sigma_path/utils/constants.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);
    final routines = routineProvider.routines;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Routines'),
        centerTitle: true,
      ),
      body: routines.isEmpty
          ? const _EmptyRoutinesState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routines.length,
              itemBuilder: (context, index) {
                return _RoutineCard(routine: routines[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoutineBuilderScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyRoutinesState extends StatelessWidget {
  const _EmptyRoutinesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Routines Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create your first Sigma routine to structure your day and maximize productivity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoutineBuilderScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('CREATE ROUTINE'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;

  const _RoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    final completedTasksCount = routine.tasks.where((task) => task.isCompleted).length;
    final progress = routine.tasks.isEmpty ? 0.0 : completedTasksCount / routine.tasks.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          _showRoutineDetails(context, routine);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(routine.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(routine.category),
                          color: _getCategoryColor(routine.category),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              routine.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getCategoryColor(routine.category),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: routine.isActive,
                    onChanged: (value) async {
                      await MockApi().updateRoutine(
                        routine.copyWith(isActive: value),
                      );
                      
                      // Refresh routines
                      final routines = await MockApi().getRoutines();
                      Provider.of<RoutineProvider>(context, listen: false)
                          .setRoutines(routines);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                routine.description,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              if (routine.isActive) ...[
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedTasksCount/${routine.tasks.length} tasks completed',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                  ),.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    if (routine.currentStreak > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                  Text(
                    _formatWeekdays(routine.weekdays),
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWeekdays(List<String> weekdays) {
    if (weekdays.length == 7) {
      return 'Every day';
    } else if (weekdays.isEmpty) {
      return 'Not scheduled';
    } else {
      return weekdays.join(', ');
    }
  }
}

void _showRoutineDetails(BuildContext context, Routine routine) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              
              // Routine title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      routine.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: routine.isActive,
                    onChanged: (value) async {
                      await MockApi().updateRoutine(
                        routine.copyWith(isActive: value),
                      );
                      
                      // Refresh routines
                      final routines = await MockApi().getRoutines();
                      Provider.of<RoutineProvider>(context, listen: false)
                          .setRoutines(routines);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(routine.category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(routine.category),
                      color: _getCategoryColor(routine.category),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      routine.category.toUpperCase(),
                      style: TextStyle(
                        color: _getCategoryColor(routine.category),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                routine.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Days
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Scheduled days: ${_formatWeekdays(routine.weekdays)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Stats
              if (routine.isActive) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current streak: ${routine.currentStreak} days',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
                      'Longest streak: ${routine.longestStreak} days',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Times completed: ${routine.completionCount}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // Tasks
              const Text(
                'TASKS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              
              // Task list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: routine.tasks.length,
                  itemBuilder: (context, index) {
                    final task = routine.tasks[index];
                    return _TaskItem(
                      task: task,
                      onToggle: (value) async {
                        if (routine.isActive) {
                          Provider.of<RoutineProvider>(context, listen: false)
                              .completeRoutineTask(routine.id, task.id);
                          
                          // Check if all tasks are completed
                          final updatedRoutine = Provider.of<RoutineProvider>(
                            context, 
                            listen: false,
                          ).routines.firstWhere((r) => r.id == routine.id);
                          
                          if (updatedRoutine.isCompleted) {
                            await MockApi().completeRoutine(routine.id);
                            
                            // Refresh routines
                            final routines = await MockApi().getRoutines();
                            Provider.of<RoutineProvider>(context, listen: false)
                                .setRoutines(routines);
                                
                            // Show success message
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Routine completed! +50 Sigma Points'),
                                  backgroundColor: AppTheme.successColor,
                                ),
                              );
                            }
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutineBuilderScreen(
                                routine: routine,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('EDIT'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: routine.isActive
                            ? () {
                                Navigator.pop(context);
                              }
                            : () async {
                                await MockApi().updateRoutine(
                                  routine.copyWith(isActive: true),
                                );
                                
                                // Refresh routines
                                final routines = await MockApi().getRoutines();
                                Provider.of<RoutineProvider>(context, listen: false)
                                    .setRoutines(routines);
                                    
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Routine activated!'),
                                      backgroundColor: AppTheme.successColor,
                                    ),
                                  );
                                }
                              },
                        icon: Icon(
                          routine.isActive ? Icons.visibility : Icons.play_arrow,
                        ),
                        label: Text(
                          routine.isActive ? 'CLOSE' : 'ACTIVATE',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: routine.isActive
                              ? AppTheme.secondaryColor
                              : AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _TaskItem extends StatelessWidget {
  final RoutineTask task;
  final Function(bool)? onToggle;

  const _TaskItem({
    required this.task,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: task.isCompleted 
              ? AppTheme.successColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              task.time,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              task.activity,
              style: TextStyle(
                fontSize: 16,
                decoration: task.isCompleted 
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? AppTheme.textSecondaryColor
                    : AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Checkbox(
            value: task.isCompleted,
            onChanged: onToggle != null ? (value) => onToggle!(value!) : null,
            activeColor: AppTheme.successColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatWeekdays(List<String> weekdays) {
  if (weekdays.length == 7) {
    return 'Every day';
  } else if (weekdays.isEmpty) {
    return 'Not scheduled';
  } else {
    return weekdays.join(', ');
  }
}

Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'productivity':
      return AppTheme.primaryColor;
    case 'fitness':
      return Colors.green;
    case 'mindset':
      return AppTheme.secondaryColor;
    case 'learning':
      return Colors.orange;
    case 'career':
      return Colors.amber;
    default:
      return AppTheme.primaryColor;
  }
}

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'productivity':
      return Icons.speed;
    case 'fitness':
      return Icons.fitness_center;
    case 'mindset':
      return Icons.psychology;
    case 'learning':
      return Icons.book;
    case 'career':
      return Icons.work;
    default:
      return Icons.schedule;
  }
}

class RoutineBuilderScreen extends StatefulWidget {
  final Routine? routine;

  const RoutineBuilderScreen({
    super.key,
    this.routine,
  });

  @override
  State<RoutineBuilderScreen> createState() => _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends State<RoutineBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _activityController = TextEditingController();
  
  String _selectedCategory = 'productivity';
  final List<RoutineTask> _tasks = [];
  final List<String> _selectedWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  final List<String> _categories = ['productivity', 'fitness', 'mindset', 'learning', 'career'];
  final List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.routine != null) {
      _isEditing = true;
      _titleController.text = widget.routine!.title;
      _descriptionController.text = widget.routine!.description;
      _selectedCategory = widget.routine!.category;
      _tasks.addAll(widget.routine!.tasks);
      _selectedWeekdays.clear();
      _selectedWeekdays.addAll(widget.routine!.weekdays);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_timeController.text.isNotEmpty && _activityController.text.isNotEmpty) {
      setState(() {
        _tasks.add(
          RoutineTask(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            time: _timeController.text,
            activity: _activityController.text,
          ),
        );
        _timeController.clear();
        _activityController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate() && _tasks.isNotEmpty) {
      if (_isEditing) {
        final updatedRoutine = widget.routine!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          tasks: _tasks,
          weekdays: _selectedWeekdays,
        );
        
        await MockApi().updateRoutine(updatedRoutine);
      } else {
        final newRoutine = Routine(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          tasks: _tasks,
          weekdays: _selectedWeekdays,
        );
        
        await MockApi().addRoutine(newRoutine);
      }
      
      // Refresh routines
      final routines = await MockApi().getRoutines();
      if (context.mounted) {
        Provider.of<RoutineProvider>(context, listen: false)
            .setRoutines(routines);
            
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Routine updated!' : 'Routine created!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } else if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one task to your routine'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _toggleWeekday(String weekday) {
    setState(() {
      if (_selectedWeekdays.contains(weekday)) {
        _selectedWeekdays.remove(weekday);
      } else {
        _selectedWeekdays.add(weekday);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Routine' : 'Create Routine'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _saveRoutine,
            icon: const Icon(Icons.save),
            label: const Text('SAVE'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title input
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Routine Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description input
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Category selector
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(category.capitalize()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Weekdays selector
            const Text(
              'Schedule Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _weekdays.map((day) {
                final isSelected = _selectedWeekdays.contains(day);
                return InkWell(
                  onTap: () => _toggleWeekday(day),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey[600]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Tasks header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_tasks.length} tasks',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Add task form
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      hintText: '08:00',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: _activityController,
                    decoration: const InputDecoration(
                      labelText: 'Activity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Task list
            if (_tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No tasks added yet',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      _removeTask(index);
                    },
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.time,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(task.activity),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTask(index),
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            
            // Submit button
            ElevatedButton.icon(
              onPressed: _saveRoutine,
              icon: Icon(_isEditing ? Icons.save : Icons.add),
              label: Text(_isEditing ? 'UPDATE ROUTINE' : 'CREATE ROUTINE'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
                          Text(
                            'Streak: ${routine.currentStreak}',
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
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${routine.tasks.length} tasks',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme