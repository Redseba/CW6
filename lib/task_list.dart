import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'task_model.dart'; // Import the Task model
import 'task_detail.dart';

class TaskListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addTask(BuildContext context) async {
    // Implement task creation logic here (could be a form to add a new task)
    await _firestore.collection('tasks').add({
      'title': 'New Task',
      'description': 'Task Description',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> _deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      print("Invalid task ID");
      return;
    }

    try {
      // Deleting the task from Firestore
      await _firestore.collection('tasks').doc(taskId).delete();
      print("Task deleted successfully.");
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addTask(context), // Add a new task
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks available.'));
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                onTap: () {
                  // Navigate to task details screen, passing the task.id
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(taskId: task.id),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTask(task.id), // Delete task
                ),
              );
            },
          );
        },
      ),
    );
  }
}
