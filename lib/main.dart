import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(tasks:[
      Task(id:1, label: 'First app'),
      Task(id:2, label: 'Something fancy'),
      Task(id:3, label: 'Make it pretty'),
      Task(id:4, label: 'Learn more'),
      Task(id:5, label: ''),
      Task(id:6, label: ''),
      Task(id:7, label: ''),
      Task(id:8, label: ''),
      Task(id:9, label: ''),
      Task(id:10, label: ''),
  ]);
});

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Flutter!', 
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is my first Flutter app!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Progress(),
          Row(
            children: [
              TaskList(),
              if(true)
                HiddenButton(), 
            ],
          ),
        ],
      ),
    );
  }
}


class HiddenButton extends StatefulWidget {
  const HiddenButton({super.key});

  @override
  State<HiddenButton> createState() => _ButtonState();
}

class _ButtonState extends State<HiddenButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = FilledButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.amber,
      );

    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 5,
      runSpacing: 5, 
      children:[
          FilledButton(
            style: style,
            onPressed: () {},
            child: const Text('Venture forth'),
          ),
        ]
      );

  }
}

class Progress extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);

    var numCompletedTasks = tasks.where((task) {
      return task.completed == true;
    }).length;

    return Column(
      children: [
        Text("I've learned this much Flutter so far:"), 
        LinearProgressIndicator(
          value: numCompletedTasks / tasks.length, 
          color: numCompletedTasks >= 4 ? Colors.amber : Colors.purple,
        ),
      ],
    );
  }
}

class TaskList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);

    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 5,
      runSpacing: 5, 
      children: tasks.map((task) => TaskItem(task:task),).toList(),
    );
  }
}

class TaskItem extends ConsumerWidget {
  final Task task;

  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          onChanged: (newValue) =>
            ref.read(tasksProvider.notifier).toggle(task.id),
            value: task.completed,
          ),
          Text(task.label),
      ],
    );
  }
}

/*
class _TaskItemState extends State<TaskItem> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value, 
          onChanged: (newValue) => setState(() => _value = newValue),
        ),
        Text(widget.label),
      ],
    );
  }
}
*/

@immutable
class Task {
  final int id;
  final String label;
  final bool completed;

  Task({required this.id, required this.label, this.completed = false});

  Task copyWith({int? id, String? label, bool? completed}) {
    return Task(
      id: id ?? this.id,
      label: label ?? this.label,
      completed: completed ?? this.completed,
    );
  }
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier({tasks}) : super(tasks);

  void add (Task task) {
    state = [... state, task];
  }

  void toggle(int taskId) {
    state = [
      for(final item in state)
        if(taskId == item.id)
          item.copyWith(completed: !item.completed)
        else
          item
    ];
  }
}
