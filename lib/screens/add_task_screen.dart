import 'package:billsplit/helpers/database_helper.dart';
import 'package:billsplit/modals/task_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final Function updateTask;
  AddTaskScreen({this.task, this.updateTask});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String priority;
  DateTime date = DateTime.now();
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

  final List<String> priorities = [
    'Low',
    'Medium',
    'High',
  ];

  TextEditingController _dateController = TextEditingController();
  _handleDatePicker() async {
    final DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (dateTime != null && dateTime != date) {
      setState(() {
        date = dateTime;
      });
    }
    _dateController.text = dateFormat.format(date);
  }

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Task task = Task(title: title, date: date, priority: priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTask();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task.title;
      date = widget.task.date;
      priority = widget.task.priority;
    }
    _dateController.text = dateFormat.format(date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTask();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.task == null ? 'Add Tasks' : 'Update Task',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (input) => input.trim().isEmpty
                                ? "Please Enter a valid title"
                                : null,
                            onSaved: (value) => title = value,
                            initialValue: title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: () {
                              _handleDatePicker();
                            },
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              size: 22.0,
                            ),
                            items: priorities.map((String myPriority) {
                              return DropdownMenuItem(
                                value: myPriority,
                                child: Text(
                                  myPriority,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Set Priority',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (input) => priority == null
                                ? "Please select a priority level"
                                : null,
                            onSaved: (value) => priority = value,
                            onChanged: (value) {
                              setState(() {
                                priority = value;
                              });
                            },
                            value: priority,
                          ),
                        ),
                        GestureDetector(
                          onTap: submit,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                widget.task == null ? "Add" : "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.task != null
                            ? GestureDetector(
                                onTap: delete,
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
