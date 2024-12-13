import 'package:flutter/material.dart';
import 'package:frontend/models/students_model.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel student;

  const EditStudentScreen({super.key, required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _msvController;
  late TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _msvController = TextEditingController(text: widget.student.msv.toString());
    _classController = TextEditingController(text: widget.student.className);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa Sinh Viên')),
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
                  final updatedStudent = StudentModel(
                    msv: int.parse(_msvController.text),
                    name: _nameController.text,
                    className: _classController.text,
                  );
                  Navigator.pop(
                      context, updatedStudent); // Trả lại sinh viên đã sửa
                }
              },
              child: const Text('Lưu Thay Đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
