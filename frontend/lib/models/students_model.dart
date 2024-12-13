import 'dart:convert';

// Lớp đại diện cho sinh viên
class StudentModel {
  // Mã sinh viên
  final int msv;
  // Tên sinh viên
  final String name;
  // Lớp sinh viên
  final String className;

  // Constructor
  StudentModel({
    required this.msv,
    required this.name,
    required this.className, // Sửa từ age thành className
  });

  // Phương thức copyWith cho phép tạo bản sao với các thay đổi của trường
  StudentModel copyWith({
    int? msv,
    String? name,
    String? className, // Sửa từ age thành className
  }) {
    return StudentModel(
      msv: msv ?? this.msv,
      name: name ?? this.name,
      className: className ?? this.className, // Sửa từ age thành className
    );
  }

  // Chuyển đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'msv': msv,
      'name': name,
      'className': className, // Sửa từ age thành className
    };
  }

  // Tạo đối tượng từ Map
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      msv: map['msv'] as int,
      name: map['name'] as String,
      className: map['className'] as String, // Sửa từ age thành className
    );
  }

  // Chuyển đối tượng thành chuỗi JSON
  String toJson() => json.encode(toMap());

  // Tạo đối tượng từ chuỗi JSON
  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentModel(msv: $msv, name: $name, className: $className)';

  @override
  int get hashCode =>
      msv.hashCode ^
      name.hashCode ^
      className.hashCode; // Sửa từ age thành className
}
