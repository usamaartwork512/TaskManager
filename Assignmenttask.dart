import 'dart:convert';
import 'dart:io';

class Task {
  String title;
  String description;
  bool isCompleted;

  Task(this.title, this.description, {this.isCompleted = false});

  @override
  String toString() {
    return 'Title: $title, Description: $description, Completed: $isCompleted';
  }

  // Conversion to map for JSOn save
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  // Creation of task from JSOn
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        isCompleted = json['isCompleted'];
}

class TaskManager {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    print('Task added successfully.');
  }

  void updateTask(int index, Task task) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = task;
      print('Task updated successfully.');
    } else {
      print('Invalid task index.');
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      print('Task deleted successfully.');
    } else {
      print('Invalid task index.');
    }
  }

  void listTasks() {
    if (tasks.isEmpty) {
      print('No tasks available.');
    } else {
      for (int i = 0; i < tasks.length; i++) {
        print('[$i] ${tasks[i]}');
      }
    }
  }

  void listCompletedTasks() {
    var completedTasks = tasks.where((task) => task.isCompleted).toList();
    if (completedTasks.isEmpty) {
      print('No completed tasks.');
    } else {
      print('Completed Tasks:');
      for (int i = 0; i < completedTasks.length; i++) {
        print('[$i] ${completedTasks[i]}');
      }
    }
  }

  void listIncompleteTasks() {
    var incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
    if (incompleteTasks.isEmpty) {
      print('No incomplete tasks.');
    } else {
      print('Incomplete Tasks:');
      for (int i = 0; i < incompleteTasks.length; i++) {
        print('[$i] ${incompleteTasks[i]}');
      }
    }
  }

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      print('Task completion status toggled.');
    } else {
      print('Invalid task index.');
    }
  }

  // Save to JSOn file
  Future<void> saveTasks() async {
    final file = File('tasks.json');
    final jsonData = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await file.writeAsString(jsonData);
    print('Tasks saved to tasks.json');
  }

  // Load data from JSOn
  Future<void> loadTasks() async {
    final file = File('tasks.json');
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final List<dynamic> taskList = jsonDecode(jsonData);
      tasks = taskList.map((json) => Task.fromJson(json)).toList();
      print('Tasks loaded from tasks.json');
    } else {
      print('No saved tasks found.');
    }
  }
}

void main() async {
  TaskManager taskManager = TaskManager();

  await taskManager.loadTasks();

  while (true) {
    print('\nTask Manager Menu:');
    print('1. Add a new task');
    print('2. Update a task');
    print('3. Delete a task');
    print('4. List all tasks');
    print('5. List completed tasks');
    print('6. List incomplete tasks');
    print('7. Toggle task completion status');
    print('8. Save tasks to file');
    print('0. Exit');
    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Enter task title: ');
      String title = stdin.readLineSync() ?? '';
      stdout.write('Enter task description: ');
      String description = stdin.readLineSync() ?? '';
      taskManager.addTask(Task(title, description));
    } else if (choice == '2') {
      stdout.write('Enter task index to update: ');
      int index = int.parse(stdin.readLineSync() ?? '-1');
      stdout.write('Enter new task title: ');
      String newTitle = stdin.readLineSync() ?? '';
      stdout.write('Enter new task description: ');
      String newDescription = stdin.readLineSync() ?? '';
      taskManager.updateTask(index, Task(newTitle, newDescription));
    } else if (choice == '3') {
      stdout.write('Enter task index to delete: ');
      int index = int.parse(stdin.readLineSync() ?? '-1');
      taskManager.deleteTask(index);
    } else if (choice == '4') {
      taskManager.listTasks();
    } else if (choice == '5') {
      taskManager.listCompletedTasks();
    } else if (choice == '6') {
      taskManager.listIncompleteTasks();
    } else if (choice == '7') {
      stdout.write('Enter task index to toggle completion: ');
      int index = int.parse(stdin.readLineSync() ?? '-1');
      taskManager.toggleTaskCompletion(index);
    } else if (choice == '8') {
      await taskManager.saveTasks();
    } else if (choice == '0') {
      print('Exiting!!!');
      break;
    } else {
      print('Invalid option, please try again.');
    }
  }
}
