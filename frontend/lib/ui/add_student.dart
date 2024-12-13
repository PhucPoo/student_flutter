import 'package:flutter/material.dart';
import 'package:frontend/models/students_model.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _msvController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Sinh Viên')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _msvController,
              decoration: const InputDecoration(labelText: 'MSV'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _classController,
              decoration: const InputDecoration(labelText: 'Lớp'),
            ),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra nếu các trường nhập không trống
                if (_nameController.text.isEmpty ||
                    _msvController.text.isEmpty ||
                    _classController.text.isEmpty) {
                  // Hiển thị thông báo lỗi nếu có trường nào trống
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin!')),
                  );
                } else {
                  final newStudent = StudentModel(
                    msv: int.parse(_msvController.text),
                    name: _nameController.text,
                    className: _classController.text,
                  );
                  Navigator.pop(
                      context, newStudent); // Trả lại dữ liệu sinh viên mới
                }
              },
              child: const Text('Thêm Sinh Viên'),
            ),
          ],
        ),
      ),
    );
  }
}
