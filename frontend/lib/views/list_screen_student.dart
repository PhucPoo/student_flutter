import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/students_model.dart';
import 'package:frontend/ui/add_student.dart';
import 'package:frontend/ui/edit_student.dart'; // Đảm bảo bạn đã tạo màn hình EditStudent

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final String apiUrl =
      'http://localhost:8080/api/v1/students'; // Địa chỉ API của bạn
  List<StudentModel> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Hàm lấy danh sách sinh viên từ server
  Future<void> _fetchStudents() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));

      if (res.statusCode == 200) {
        final List<dynamic> studentList = json.decode(res.body);

        // Kiểm tra nếu dữ liệu trả về là một danh sách
        if (studentList is List) {
          setState(() {
            _students =
                studentList.map((e) => StudentModel.fromMap(e)).toList();
          });
        } else {
          print('Dữ liệu trả về không phải là danh sách');
        }
      } else {
        print('Lỗi khi lấy danh sách sinh viên: ${res.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách sinh viên: $e');
    }
  }

  // Hàm xóa sinh viên
  Future<void> _deleteStudent(int msv) async {
    try {
      final res = await http.delete(Uri.parse('$apiUrl/$msv'));

      if (res.statusCode == 200 || res.statusCode == 204) {
        setState(() {
          _students.removeWhere((student) => student.msv == msv);
        });
        debugPrint('Sinh viên với mã số $msv đã được xóa thành công.');
      } else {
        debugPrint('Delete failed: ${res.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Lỗi khi xóa sinh viên: $e');
    }
  }

  // Hàm thêm sinh viên mới (cập nhật trực tiếp vào danh sách mà không cần tải lại)
  Future<void> _addStudent(StudentModel student) async {
    setState(() {
      _students.add(student); // Thêm sinh viên vào danh sách trực tiếp
    });

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toMap()),
      );

      if (res.statusCode != 201) {
        print('Lỗi khi thêm sinh viên: ${res.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi thêm sinh viên: $e');
    }
  }

  // Hàm sửa thông tin sinh viên
  Future<void> _editStudent(StudentModel student) async {
    final updatedStudent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditStudentScreen(student: student),
      ),
    );

    if (updatedStudent != null) {
      setState(() {
        final index = _students.indexWhere((s) => s.msv == student.msv);
        if (index != -1) {
          _students[index] = updatedStudent;
        }
      });

      try {
        final res = await http.put(
          Uri.parse('$apiUrl/${student.msv}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedStudent.toMap()),
        );

        if (res.statusCode != 200) {
          print('Lỗi khi sửa sinh viên: ${res.statusCode}');
        }
      } catch (e) {
        print('Lỗi khi sửa sinh viên: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sinh Viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Chuyển đến màn hình thêm sinh viên
              final newStudent = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddStudentScreen()),
              );

              if (newStudent != null) {
                _addStudent(
                    newStudent); // Thêm sinh viên vào danh sách ngay lập tức
              }
            },
          ),
        ],
      ),
      body: _students.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('MSV')),
                  DataColumn(label: Text('Tên')),
                  DataColumn(
                      label: Text('Lớp')), // Thay đổi từ 'Tuổi' thành 'Lớp'
                  DataColumn(label: Text('Hành động')),
                ],
                rows: _students.map((student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student.msv.toString())),
                      DataCell(Text(student.name)),
                      DataCell(Text(student
                          .className)), // Thay đổi từ 'age' thành 'className'
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editStudent(student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteStudent(student.msv),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
