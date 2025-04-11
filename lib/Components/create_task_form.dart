import 'package:flutter/material.dart';

class CreateTaskForm extends StatefulWidget {
  final Function(String) onSubmit;

  const CreateTaskForm({super.key, required this.onSubmit});

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final TextEditingController _controller = TextEditingController();

  void handleAdd() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onSubmit(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo[200],
      content: SizedBox(
        width: 300,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //text input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Add new task..",
                filled: true,
                fillColor: Colors.indigo[100],
              ),
            ),

            //controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                // add button
                MaterialButton(
                  onPressed: handleAdd,
                  color: Colors.indigo[400],
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),

                //close button
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.indigo[400],
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
