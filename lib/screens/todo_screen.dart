import 'package:billsplit/helpers/database_helper.dart';
import 'package:billsplit/modals/task_modal.dart';
import 'package:billsplit/screens/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  Future<List<Task>> _taskList;
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTasksList();
    });
  }

  Widget _buildTaskWidget(Task task) {
    return Column(
      children: [
        ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text('${dateFormat.format(task.date)} - ${task.priority}'),
          trailing: Checkbox(
            onChanged: (value) {
              task.status = value ? 1 : 0;
              DatabaseHelper.instance.updateTask(task);
              _updateTaskList();
            },
            value: task.status == 1 ? true : false,
            activeColor: Colors.red,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return AddTaskScreen(
                task: task,
                updateTask: _updateTaskList,
              );
            }));
          },
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          print('Open add Task Screen');
          Get.to(AddTaskScreen(
            updateTask: _updateTaskList,
          ));
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _taskList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final int completedTasks = snapshot.data
                  .where((Task task) => task.status == 1)
                  .toList()
                  .length;

              return ListView.builder(
                itemCount: 1 + snapshot.data.length,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                itemBuilder: (BuildContext ctx, int index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$completedTasks of ${snapshot.data.length}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        )
                      ],
                    );
                  }
                  return _buildTaskWidget(snapshot.data[index - 1]);
                },
              );
            }),
      ),
    );
  }
}
