import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  TaskDetailScreen({required this.taskId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadTaskDetails();
  }

  Future<void> _loadTaskDetails() async {
    try {
      final docSnapshot = await _firestore.collection('tasks').doc(widget.taskId).get();

      if (docSnapshot.exists) {
        final task = Task.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        _titleController.text = task.title;
        _descriptionController.text = task.description;
      } else {
        print("Task not found");
      }
    } catch (e) {
      print("Error loading task details: $e");
    }
  }

  Future<void> _updateTask() async {
    try {
      await _firestore.collection('tasks').doc(widget.taskId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
      });

      Navigator.pop(context); // Go back to the task list screen after updating
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
