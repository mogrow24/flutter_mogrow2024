import 'package:flutter/material.dart';

class AddTodolistWidget extends StatelessWidget {
  const AddTodolistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Input',
            ),
          ),
          IconButton(
            onPressed: () => print('아이콘'),
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }
}
