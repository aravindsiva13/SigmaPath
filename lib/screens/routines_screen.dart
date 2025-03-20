// import 'package:flutter/material.dart';
// import 'package:sigma_path/models/app_models.dart';
// import 'package:sigma_path/api/mock_api.dart';
// import 'package:sigma_path/theme/app_theme.dart';

// import 'package:sigma_path/utils/constants.dart';

// class RoutinesScreen extends StatefulWidget {
//   const RoutinesScreen({Key? key}) : super(key: key);

//   @override
//   _RoutinesScreenState createState() => _RoutinesScreenState();
// }

// class _RoutinesScreenState extends State<RoutinesScreen> {
//   bool _isLoading = true;
//   List<Routine> _routines = [];
//   final MockApi _api = MockApi();

//   @override
//   void initState() {
//     super.initState();
//     _loadRoutines();
//   }

//   Future<void> _loadRoutines() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final routines = await _api.getRoutines();
//       setState(() {
//         _routines = routines.cast<Routine>();
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading routines: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sigma Routines'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadRoutines,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _routines.isEmpty
//                 ? _buildEmptyState()
//                 : _buildRoutinesList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _navigateToCreateRoutine(),
//         backgroundColor: AppTheme.primaryColor,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.fitness_center,
//               size: 80,
//               color: AppTheme.primaryColor.withOpacity(0.5),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Build Your Sigma Routine',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Create structured routines to maximize your productivity and build discipline. Start your journey to becoming a Sigma.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () => _navigateToCreateRoutine(),
//               icon: const Icon(Icons.add),
//               label: const Text('CREATE ROUTINE'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primaryColor,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoutinesList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _routines.length,
//       itemBuilder: (context, index) {
//         final routine = _routines[index];
//         return RoutineCard(
//           routine: routine,
//           onTap: () => _navigateToRoutineDetail(routine),
//           onEdit: () => _navigateToCreateRoutine(routine),
//           onToggleActive: () => _toggleRoutineActive(routine),
//           onDelete: () => _deleteRoutine(routine),
//         );
//       },
//     );
//   }

//   void _navigateToCreateRoutine([Routine? routine]) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateRoutineScreen(routine: routine),
//       ),
//     );

//     if (result == true) {
//       _loadRoutines();
//     }
//   }

//   void _navigateToRoutineDetail(Routine routine) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RoutineDetailScreen(routine: routine),
//       ),
//     ).then((_) => _loadRoutines());
//   }

//   Future<void> _toggleRoutineActive(Routine routine) async {
//     final updatedRoutine = routine.copyWith(isActive: !routine.isActive);
//     await _api.saveRoutine(updatedRoutine);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(updatedRoutine.isActive
//             ? 'Routine activated!'
//             : 'Routine deactivated!'),
//       ),
//     );

//     _loadRoutines();
//   }

//   Future<void> _deleteRoutine(Routine routine) async {
//     // Show confirmation dialog
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Routine'),
//         content: Text('Are you sure you want to delete "${routine.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('DELETE'),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await _api.deleteRoutine(routine.id);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Routine deleted')),
//       );

//       _loadRoutines();
//     }
//   }
// }

// class RoutineCard extends StatelessWidget {
//   final Routine routine;
//   final VoidCallback onTap;
//   final VoidCallback onEdit;
//   final VoidCallback onToggleActive;
//   final VoidCallback onDelete;

//   const RoutineCard({
//     Key? key,
//     required this.routine,
//     required this.onTap,
//     required this.onEdit,
//     required this.onToggleActive,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: routine.isActive
//             ? BorderSide(color: AppTheme.primaryColor, width: 2)
//             : BorderSide.none,
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     _getCategoryIcon(routine.category),
//                     color: routine.isActive
//                         ? AppTheme.primaryColor
//                         : Colors.grey[600],
//                     size: 28,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           routine.name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         Text(
//                           routine.category,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (routine.currentStreak > 0)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.amber.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.local_fire_department,
//                               color: Colors.orange, size: 16),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${routine.currentStreak}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 routine.description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Chip(
//                     label: Text('${routine.tasks.length} tasks'),
//                     backgroundColor: Colors.grey[200],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: onEdit,
//                     tooltip: 'Edit Routine',
//                     color: Colors.grey[600],
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       routine.isActive ? Icons.toggle_on : Icons.toggle_off,
//                       size: 28,
//                     ),
//                     onPressed: onToggleActive,
//                     tooltip: routine.isActive ? 'Deactivate' : 'Activate',
//                     color: routine.isActive
//                         ? AppTheme.primaryColor
//                         : Colors.grey[600],
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: onDelete,
//                     tooltip: 'Delete Routine',
//                     color: Colors.red[400],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'fitness':
//         return Icons.fitness_center;
//       case 'health':
//         return Icons.health_and_safety;
//       case 'learning':
//         return Icons.school;
//       case 'mindfulness':
//         return Icons.self_improvement;
//       case 'productivity':
//       default:
//         return Icons.schedule;
//     }
//   }
// }

// class RoutineDetailScreen extends StatefulWidget {
//   final Routine routine;

//   const RoutineDetailScreen({Key? key, required this.routine})
//       : super(key: key);

//   @override
//   _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
// }

// class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
//   late Routine _routine;
//   final MockApi _api = MockApi();
//   bool _isCompleting = false;

//   @override
//   void initState() {
//     super.initState();
//     _routine = widget.routine;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_routine.name),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _navigateToEdit,
//           ),
//         ],
//       ),
//       body: _isCompleting
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildRoutineHeader(),
//                   const SizedBox(height: 24),
//                   _buildTasksList(),
//                   const SizedBox(height: 24),
//                   _buildActionButtons(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildRoutineHeader() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   _getCategoryIcon(_routine.category),
//                   color: AppTheme.primaryColor,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _routine.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                         ),
//                       ),
//                       Text(
//                         _routine.category,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (_routine.isActive)
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppTheme.primaryColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.check_circle,
//                             color: AppTheme.primaryColor, size: 16),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Active',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _routine.description,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[800],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Chip(
//                   label: Text('${_routine.tasks.length} tasks'),
//                   backgroundColor: Colors.grey[200],
//                 ),
//                 const SizedBox(width: 16),
//                 if (_routine.currentStreak > 0)
//                   Chip(
//                     avatar: const Icon(Icons.local_fire_department,
//                         color: Colors.orange, size: 16),
//                     label: Text('Streak: ${_routine.currentStreak}'),
//                     backgroundColor: Colors.amber.withOpacity(0.2),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTasksList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Tasks',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ..._routine.tasks.asMap().entries.map((entry) {
//           final index = entry.key;
//           final task = entry.value;
//           return Card(
//             margin: const EdgeInsets.only(bottom: 8),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor:
//                     task.completed ? Colors.green : Colors.grey[300],
//                 child: Icon(
//                   task.completed ? Icons.check : Icons.hourglass_empty,
//                   color: task.completed ? Colors.white : Colors.grey[700],
//                 ),
//               ),
//               title: Text(
//                 task.activity,
//                 style: TextStyle(
//                   decoration:
//                       task.completed ? TextDecoration.lineThrough : null,
//                   color: task.completed ? Colors.grey[600] : Colors.black,
//                   fontWeight:
//                       task.completed ? FontWeight.normal : FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text('Duration: ${task.duration} minutes'),
//               trailing: Checkbox(
//                 value: task.completed,
//                 activeColor: AppTheme.primaryColor,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     final updatedTasks = List<RoutineTask>.from(_routine.tasks);
//                     updatedTasks[index] =
//                         task.copyWith(completed: value ?? false);
//                     _routine = _routine.copyWith(tasks: updatedTasks);
//                   });
//                 },
//               ),
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     final allTasksCompleted = _routine.tasks.every((task) => task.completed);

//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: _completeRoutine,
//             icon: const Icon(Icons.done_all),
//             label: const Text('COMPLETE ROUTINE'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               disabledBackgroundColor: Colors.grey[300],
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         IconButton(
//           onPressed: () {
//             // Reset all tasks to incomplete
//             setState(() {
//               final updatedTasks = _routine.tasks
//                   .map((task) => task.copyWith(completed: false))
//                   .toList();
//               _routine = _routine.copyWith(tasks: updatedTasks);
//             });
//           },
//           icon: const Icon(Icons.refresh),
//           tooltip: 'Reset Tasks',
//         ),
//       ],
//     );
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'fitness':
//         return Icons.fitness_center;
//       case 'health':
//         return Icons.health_and_safety;
//       case 'learning':
//         return Icons.school;
//       case 'mindfulness':
//         return Icons.self_improvement;
//       case 'productivity':
//       default:
//         return Icons.schedule;
//     }
//   }

//   Future<void> _navigateToEdit() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateRoutineScreen(routine: _routine),
//       ),
//     );

//     if (result == true) {
//       // Reload routine data
//       final routines = await _api.getRoutines();
//       final updatedRoutine = routines.firstWhere((r) => r.id == _routine.id);
//       setState(() {
//         _routine = updatedRoutine;
//       });
//     }
//   }

//   Future<void> _completeRoutine() async {
//     if (_isCompleting) return;

//     setState(() {
//       _isCompleting = true;
//     });

//     try {
//       // Mark all tasks as completed
//       final completedTasks =
//           _routine.tasks.map((task) => task.copyWith(completed: true)).toList();

//       // Increment streak
//       final updatedRoutine = _routine.copyWith(
//         tasks: completedTasks,
//         currentStreak: _routine.currentStreak + 1,
//       );

//       await _api.saveRoutine(updatedRoutine);

//       // Update local state
//       setState(() {
//         _routine = updatedRoutine;
//         _isCompleting = false;
//       });

//       // Update user with sigma points
//       final user = await _api.getUser();
//       final updatedUser = user.copyWith(
//         sigmaPoints:
//             user.sigmaPoints + 50, // Award points for completing routine
//       );
//       await _api.updateUser(updatedUser);

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Routine completed! +50 Sigma Points'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isCompleting = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error completing routine: $e')),
//       );
//     }
//   }
// }

// class CreateRoutineScreen extends StatefulWidget {
//   final Routine? routine;

//   const CreateRoutineScreen({Key? key, this.routine}) : super(key: key);

//   @override
//   _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
// }

// class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late String _selectedCategory;
//   List<RoutineTask> _tasks = [];
//   bool _isEditing = false;
//   bool _isSaving = false;
//   final MockApi _api = MockApi();

//   @override
//   void initState() {
//     super.initState();
//     _isEditing = widget.routine != null;
//     _nameController = TextEditingController(text: widget.routine?.name ?? '');
//     _descriptionController =
//         TextEditingController(text: widget.routine?.description ?? '');
//     _selectedCategory = widget.routine?.category ?? 'Productivity';
//     _tasks = widget.routine?.tasks.toList() ?? [];
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isEditing ? 'Edit Routine' : 'Create Routine'),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           TextButton(
//             onPressed: _isSaving ? null : _saveRoutine,
//             child: const Text('SAVE'),
//             style: TextButton.styleFrom(foregroundColor: Colors.white),
//           ),
//         ],
//       ),
//       body: _isSaving
//           ? const Center(child: CircularProgressIndicator())
//           : Form(
//               key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Routine Name',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.edit),
//                     ),
//                     validator: (value) =>
//                         value!.isEmpty ? 'Please enter a name' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: _selectedCategory,
//                     decoration: const InputDecoration(
//                       labelText: 'Category',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.category),
//                     ),
//                     items: [
//                       'Productivity',
//                       'Fitness',
//                       'Health',
//                       'Learning',
//                       'Mindfulness'
//                     ]
//                         .map((category) => DropdownMenuItem(
//                               value: category,
//                               child: Row(
//                                 children: [
//                                   Icon(_getCategoryIcon(category)),
//                                   const SizedBox(width: 8),
//                                   Text(category),
//                                 ],
//                               ),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedCategory = value!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.description),
//                     ),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 24),
//                   // Tasks section
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Tasks',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '${_tasks.length} tasks added',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   ..._buildTasksList(),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: _showAddTaskDialog,
//                     icon: const Icon(Icons.add),
//                     label: const Text('ADD TASK'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[200],
//                       foregroundColor: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: _saveRoutine,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primaryColor,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child:
//                         Text(_isEditing ? 'UPDATE ROUTINE' : 'CREATE ROUTINE'),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   List<Widget> _buildTasksList() {
//     if (_tasks.isEmpty) {
//       return [
//         Card(
//           color: Colors.grey[100],
//           child: const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(
//               child: Text(
//                 'No tasks added yet. Tap "ADD TASK" to create your first task.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       ];
//     }

//     return _tasks.asMap().entries.map((entry) {
//       final index = entry.key;
//       final task = entry.value;
//       return Card(
//         margin: const EdgeInsets.only(bottom: 8),
//         child: ListTile(
//           leading: CircleAvatar(
//             backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
//             child: Text('${index + 1}'),
//           ),
//           title: Text(task.activity),
//           subtitle: Text('Duration: ${task.duration} minutes'),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.edit, color: Colors.blue),
//                 onPressed: () => _showEditTaskDialog(index),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   setState(() {
//                     _tasks.removeAt(index);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }

//   Future<void> _showAddTaskDialog() async {
//     final TextEditingController activityController = TextEditingController();
//     final TextEditingController durationController =
//         TextEditingController(text: '30');

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Task'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: activityController,
//                 decoration: const InputDecoration(
//                   labelText: 'Activity',
//                   hintText: 'e.g., Read a book, Meditate, Exercise',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: durationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Duration (minutes)',
//                   hintText: 'e.g., 30',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (activityController.text.isNotEmpty &&
//                   durationController.text.isNotEmpty) {
//                 setState(() {
//                   _tasks.add(
//                     RoutineTask(
//                       id: DateTime.now().millisecondsSinceEpoch.toString(),
//                       activity: activityController.text,
//                       duration: int.tryParse(durationController.text) ?? 30,
//                       completed: false,
//                     ),
//                   );
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('ADD'),
//           ),
//         ],
//       ),
//     );

//     activityController.dispose();
//     durationController.dispose();
//   }

//   Future<void> _showEditTaskDialog(int index) async {
//     final task = _tasks[index];
//     final TextEditingController activityController =
//         TextEditingController(text: task.activity);
//     final TextEditingController durationController =
//         TextEditingController(text: task.duration.toString());

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Task'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: activityController,
//                 decoration: const InputDecoration(
//                   labelText: 'Activity',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: durationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Duration (minutes)',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (activityController.text.isNotEmpty &&
//                   durationController.text.isNotEmpty) {
//                 setState(() {
//                   _tasks[index] = task.copyWith(
//                     activity: activityController.text,
//                     duration:
//                         int.tryParse(durationController.text) ?? task.duration,
//                   );
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('UPDATE'),
//           ),
//         ],
//       ),
//     );

//     activityController.dispose();
//     durationController.dispose();
//   }

//   Future<void> _saveRoutine() async {
//     if (_formKey.currentState!.validate()) {
//       if (_tasks.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please add at least one task to your routine'),
//           ),
//         );
//         return;
//       }

//       setState(() {
//         _isSaving = true;
//       });

//       try {
//         final routine = Routine(
//           id: widget.routine?.id ??
//               DateTime.now().millisecondsSinceEpoch.toString(),
//           name: _nameController.text,
//           category: _selectedCategory,
//           description: _descriptionController.text,
//           tasks: _tasks,
//           isActive: widget.routine?.isActive ?? false,
//           currentStreak: widget.routine?.currentStreak ?? 0,
//         );

//         await _api.saveRoutine(routine);

//         setState(() {
//           _isSaving = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_isEditing ? 'Routine updated!' : 'Routine created!'),
//             backgroundColor: Colors.green,
//           ),
//         );

//         Navigator.pop(context, true);
//       } catch (e) {
//         setState(() {
//           _isSaving = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving routine: $e')),
//         );
//       }
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'fitness':
//         return Icons.fitness_center;
//       case 'health':
//         return Icons.health_and_safety;
//       case 'learning':
//         return Icons.school;
//       case 'mindfulness':
//         return Icons.self_improvement;
//       case 'productivity':
//       default:
//         return Icons.schedule;
//     }
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }

//2

import 'package:flutter/material.dart';
import 'package:sigma_path/models/app_models.dart'; // Changed from routine_model.dart
import 'package:sigma_path/api/mock_api.dart';
import 'package:sigma_path/theme/app_theme.dart';
import 'package:sigma_path/utils/constants.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({Key? key}) : super(key: key);

  @override
  _RoutinesScreenState createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  bool _isLoading = true;
  List<Routine> _routines = [];
  final MockApi _api = MockApi();

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final routines = await _api.getRoutines();
      setState(() {
        _routines = routines; // No need to cast
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading routines: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Routines'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRoutines,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _routines.isEmpty
                ? _buildEmptyState()
                : _buildRoutinesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateRoutine(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 80,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Build Your Sigma Routine',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create structured routines to maximize your productivity and build discipline. Start your journey to becoming a Sigma.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateRoutine(),
              icon: const Icon(Icons.add),
              label: const Text('CREATE ROUTINE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutinesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _routines.length,
      itemBuilder: (context, index) {
        final routine = _routines[index];
        return RoutineCard(
          routine: routine,
          onTap: () => _navigateToRoutineDetail(routine),
          onEdit: () => _navigateToCreateRoutine(routine),
          onToggleActive: () => _toggleRoutineActive(routine),
          onDelete: () => _deleteRoutine(routine),
        );
      },
    );
  }

  void _navigateToCreateRoutine([Routine? routine]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(routine: routine),
      ),
    );

    if (result == true) {
      _loadRoutines();
    }
  }

  void _navigateToRoutineDetail(Routine routine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(routine: routine),
      ),
    ).then((_) => _loadRoutines());
  }

  Future<void> _toggleRoutineActive(Routine routine) async {
    final updatedRoutine = routine.copyWith(isActive: !routine.isActive);
    await _api.saveRoutine(updatedRoutine);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(updatedRoutine.isActive
            ? 'Routine activated!'
            : 'Routine deactivated!'),
      ),
    );

    _loadRoutines();
  }

  Future<void> _deleteRoutine(Routine routine) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: Text('Are you sure you want to delete "${routine.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _api.deleteRoutine(routine.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine deleted')),
      );

      _loadRoutines();
    }
  }
}

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const RoutineCard({
    Key? key,
    required this.routine,
    required this.onTap,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: routine.isActive
            ? BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(routine.category),
                    color: routine.isActive
                        ? AppTheme.primaryColor
                        : Colors.grey[600],
                    size: 28,
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
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          routine.category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (routine.currentStreak > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${routine.currentStreak}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                routine.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Chip(
                    label: Text('${routine.tasks.length} tasks'),
                    backgroundColor: Colors.grey[200],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    tooltip: 'Edit Routine',
                    color: Colors.grey[600],
                  ),
                  IconButton(
                    icon: Icon(
                      routine.isActive ? Icons.toggle_on : Icons.toggle_off,
                      size: 28,
                    ),
                    onPressed: onToggleActive,
                    tooltip: routine.isActive ? 'Deactivate' : 'Activate',
                    color: routine.isActive
                        ? AppTheme.primaryColor
                        : Colors.grey[600],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    tooltip: 'Delete Routine',
                    color: Colors.red[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fitness':
        return Icons.fitness_center;
      case 'health':
        return Icons.health_and_safety;
      case 'learning':
        return Icons.school;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'productivity':
      default:
        return Icons.schedule;
    }
  }
}

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({Key? key, required this.routine})
      : super(key: key);

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  late Routine _routine;
  final MockApi _api = MockApi();
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_routine.title),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
          ),
        ],
      ),
      body: _isCompleting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoutineHeader(),
                  const SizedBox(height: 24),
                  _buildTasksList(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildRoutineHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(_routine.category),
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _routine.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        _routine.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_routine.isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.primaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _routine.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text('${_routine.tasks.length} tasks'),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 16),
                if (_routine.currentStreak > 0)
                  Chip(
                    avatar: const Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 16),
                    label: Text('Streak: ${_routine.currentStreak}'),
                    backgroundColor: Colors.amber.withOpacity(0.2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._routine.tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    task.isCompleted ? Colors.green : Colors.grey[300],
                child: Icon(
                  task.isCompleted ? Icons.check : Icons.hourglass_empty,
                  color: task.isCompleted ? Colors.white : Colors.grey[700],
                ),
              ),
              title: Text(
                task.activity,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey[600] : Colors.black,
                  fontWeight:
                      task.isCompleted ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text('Time: ${task.time}'),
              trailing: Checkbox(
                value: task.isCompleted,
                activeColor: AppTheme.primaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    final updatedTasks = List<RoutineTask>.from(_routine.tasks);
                    updatedTasks[index] =
                        task.copyWith(isCompleted: value ?? false);
                    _routine = _routine.copyWith(tasks: updatedTasks);
                  });
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final allTasksCompleted = _routine.tasks.every((task) => task.isCompleted);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _completeRoutine,
            icon: const Icon(Icons.done_all),
            label: const Text('COMPLETE ROUTINE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              disabledBackgroundColor: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            // Reset all tasks to incomplete
            setState(() {
              final updatedTasks = _routine.tasks
                  .map((task) => task.copyWith(isCompleted: false))
                  .toList();
              _routine = _routine.copyWith(tasks: updatedTasks);
            });
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset Tasks',
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fitness':
        return Icons.fitness_center;
      case 'health':
        return Icons.health_and_safety;
      case 'learning':
        return Icons.school;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'productivity':
      default:
        return Icons.schedule;
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(routine: _routine),
      ),
    );

    if (result == true) {
      // Reload routine data
      final routines = await _api.getRoutines();
      final updatedRoutine = routines.firstWhere((r) => r.id == _routine.id);
      setState(() {
        _routine = updatedRoutine;
      });
    }
  }

  Future<void> _completeRoutine() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      // Mark all tasks as completed
      final completedTasks = _routine.tasks
          .map((task) => task.copyWith(isCompleted: true))
          .toList();

      // Increment streak
      final updatedRoutine = _routine.copyWith(
        tasks: completedTasks,
        currentStreak: _routine.currentStreak + 1,
      );

      await _api.saveRoutine(updatedRoutine);

      // Update local state
      setState(() {
        _routine = updatedRoutine;
        _isCompleting = false;
      });

      // Update user with sigma points
      final user = await _api.getUser();
      final updatedUser = user.copyWith(
        sigmaPoints:
            user.sigmaPoints + 50, // Award points for completing routine
      );
      await _api.updateUser(updatedUser);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Routine completed! +50 Sigma Points'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing routine: $e')),
      );
    }
  }
}

class CreateRoutineScreen extends StatefulWidget {
  final Routine? routine;

  const CreateRoutineScreen({Key? key, this.routine}) : super(key: key);

  @override
  _CreateRoutineScreenState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  List<RoutineTask> _tasks = [];
  bool _isEditing = false;
  bool _isSaving = false;
  final MockApi _api = MockApi();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.routine != null;
    _nameController = TextEditingController(text: widget.routine?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.routine?.description ?? '');
    _selectedCategory = widget.routine?.category ?? 'Productivity';
    _tasks = widget.routine?.tasks.toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Routine' : 'Create Routine'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveRoutine,
            child: const Text('SAVE'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: [
                      'Productivity',
                      'Fitness',
                      'Health',
                      'Learning',
                      'Mindfulness'
                    ]
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(_getCategoryIcon(category)),
                                  const SizedBox(width: 8),
                                  Text(category),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  // Tasks section
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
                        '${_tasks.length} tasks added',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._buildTasksList(),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showAddTaskDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('ADD TASK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveRoutine,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        Text(_isEditing ? 'UPDATE ROUTINE' : 'CREATE ROUTINE'),
                  ),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildTasksList() {
    if (_tasks.isEmpty) {
      return [
        Card(
          color: Colors.grey[100],
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No tasks added yet. Tap "ADD TASK" to create your first task.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ];
    }

    return _tasks.asMap().entries.map((entry) {
      final index = entry.key;
      final task = entry.value;
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
            child: Text('${index + 1}'),
          ),
          title: Text(task.activity),
          subtitle: Text('Time: ${task.time}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditTaskDialog(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _showAddTaskDialog() async {
    final TextEditingController activityController = TextEditingController();
    final TextEditingController timeController =
        TextEditingController(text: '06:00');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  hintText: 'e.g., Read a book, Meditate, Exercise',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'e.g., 06:00',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (activityController.text.isNotEmpty &&
                  timeController.text.isNotEmpty) {
                setState(() {
                  _tasks.add(
                    RoutineTask(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      activity: activityController.text,
                      time: timeController.text,
                      isCompleted: false,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );

    activityController.dispose();
    timeController.dispose();
  }

  Future<void> _showEditTaskDialog(int index) async {
    final task = _tasks[index];
    final TextEditingController activityController =
        TextEditingController(text: task.activity);
    final TextEditingController timeController =
        TextEditingController(text: task.time);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (activityController.text.isNotEmpty &&
                  timeController.text.isNotEmpty) {
                setState(() {
                  _tasks[index] = task.copyWith(
                    activity: activityController.text,
                    time: timeController.text,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );

    activityController.dispose();
    timeController.dispose();
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      if (_tasks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one task to your routine'),
          ),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        final routine = Routine(
          id: widget.routine?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: _nameController.text,
          category: _selectedCategory,
          description: _descriptionController.text,
          tasks: _tasks,
          isActive: widget.routine?.isActive ?? false,
          currentStreak: widget.routine?.currentStreak ?? 0,
          completionCount: widget.routine?.completionCount ?? 0,
          longestStreak: widget.routine?.longestStreak ?? 0,
          completionDates: widget.routine?.completionDates ?? [],
          weekdays: widget.routine?.weekdays ??
              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        );

        await _api.saveRoutine(routine);

        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Routine updated!' : 'Routine created!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving routine: $e')),
        );
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fitness':
        return Icons.fitness_center;
      case 'health':
        return Icons.health_and_safety;
      case 'learning':
        return Icons.school;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'productivity':
      default:
        return Icons.schedule;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
