import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/students_model.dart';

// Lớp định nghĩa các route cho các hoạt động CRUD trên Student
class StudentsRouter {
  // Danh sách các sinh viên được quản lý bởi backend
  final _students = <StudentModel>[];

  // Tạo và trả về một router cho các hoạt động CRUD trên Student
  Router get router {
    final router = Router();

    // Endpoint lấy danh sách các sinh viên
    router.get('/students', _getStudentsHandler);

    // Endpoint thêm sinh viên vào danh sách
    router.post('/students', _addStudentHandler);

    // Endpoint xóa sinh viên theo id
    router.delete('/students/<id>', _deleteStudentHandler);

    // Endpoint cập nhật sinh viên theo id
    router.put('/students/<id>', _updateStudentHandler);

    return router;
  }

  // Header mặc định cho dữ liệu trả về dưới dạng JSON
  static final _headers = {'Content-Type': 'application/json'};

  // Xử lý yêu cầu lấy danh sách sinh viên
  Future<Response> _getStudentsHandler(Request req) async {
    try {
      final body =
          json.encode(_students.map((student) => student.toMap()).toList());
      return Response.ok(
        body,
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  // Xử lý yêu cầu thêm sinh viên vào danh sách
  Future<Response> _addStudentHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      final student = StudentModel.fromMap(data);
      _students.add(student);
      return Response.ok(
        student.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  // Xử lý yêu cầu xóa một sinh viên khỏi danh sách
  Future<Response> _deleteStudentHandler(Request req, String msv) async {
    try {
      final index =
          _students.indexWhere((student) => student.msv == int.parse(msv));
      if (index == -1) {
        return Response.notFound('Không tìm thấy msv = $msv');
      }

      final removedStudent = _students.removeAt(index);
      return Response.ok(
        removedStudent.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  // Xử lý yêu cầu cập nhật một sinh viên trong danh sách
  Future<Response> _updateStudentHandler(Request req, String msv) async {
    try {
      final index =
          _students.indexWhere((student) => student.msv == int.parse(msv));
      if (index == -1) {
        return Response.notFound('Không tìm thấy msv = $msv');
      }

      final payload = await req.readAsString();
      final map = json.decode(payload);
      final updatedStudent = StudentModel.fromMap(map);

      _students[index] = updatedStudent;
      return Response.ok(
        updatedStudent.toJson(),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }
}
