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

class _TodoState extends State<Todo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // start off-screen to the left
      end: Offset.zero, // end at normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 18),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    widget.task.completed
                        ? Colors.green[600]
                        : Colors.indigo[400],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // label
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          right: 4,
                        ),
                        child: Text(
                          widget.task.name,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle:
                                widget.task.completed
                                    ? FontStyle.italic
                                    : FontStyle.normal,
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
                                  ? Colors.grey
                                  : Colors.indigo,
                          onPressed: markAsDone,
                          child: Icon(
                            widget.task.completed
                                ? Icons.arrow_back
                                : Icons.done,
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
      ),
    );
  }
}
