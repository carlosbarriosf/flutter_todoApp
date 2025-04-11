import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class Todo extends StatefulWidget {
  final Task task;
  final int index;
  final Function(int) handleDelete;
  final Function(int) handleDone;

  const Todo({
    super.key,
    required this.task,
    required this.index,
    required this.handleDone,
    required this.handleDelete,
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  void deleteTask() {
    widget.handleDelete(widget.index);
  }

  void markAsDone() {
    widget.handleDone(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteTask();
      },
      // background: Container(
      //   color: Colors.red,
      //   alignment: Alignment.centerRight,
      //   child: const Icon(Icons.delete, color: Colors.white),
      // ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 18),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  widget.task.completed ? Colors.grey[400] : Colors.indigo[400],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // label
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        widget.task.name,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color:
                              widget.task.completed
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 18,
                          fontStyle:
                              widget.task.completed
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                          decoration:
                              widget.task.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),

                  // button
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: SizedBox(
                      width: 40,
                      height: 30,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        color:
                            widget.task.completed
                                ? Colors.orange
                                : Colors.indigo,
                        onPressed: markAsDone,
                        child: Icon(
                          widget.task.completed ? Icons.arrow_back : Icons.done,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
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
