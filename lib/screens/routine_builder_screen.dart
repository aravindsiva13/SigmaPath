import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/models/app_models.dart';
import 'package:sigma_path/theme/app_theme.dart';

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
  final List<String> _selectedWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  final List<String> _categories = [
    'productivity',
    'fitness',
    'mindset',
    'learning',
    'career'
  ];
  final List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

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
    if (_timeController.text.isNotEmpty &&
        _activityController.text.isNotEmpty) {
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
                          color: isSelected ? Colors.white : Colors.grey[600],
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
