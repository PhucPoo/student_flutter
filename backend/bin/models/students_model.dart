// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Lớp đại diện của nhiệm vụ (công việc) cần làm
class StudentModel {
  // Mã của công việc
  int msv;
  // Tên công việc
  String name;
  // Trạng thái công việc
  String className; // className nên là String

  StudentModel({
    required this.msv,
    required this.name,
    required this.className,
  });

  StudentModel copyWith({
    int? msv,
    String? name,
    String? className, // className phải là String
  }) {
    return StudentModel(
      msv: msv ?? this.msv,
      name: name ?? this.name,
      className: className ?? this.className, // className phải là String
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msv': msv,
      'name': name,
      'className': className, // className là String
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      msv: map['msv'] as int,
      name: map['name'] as String? ??
          '', // Nếu 'name' là null, gán giá trị mặc định là ''
      className: map['className'] as String? ??
          '', // Nếu 'className' là null, gán giá trị mặc định là ''
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentModel(msv: $msv, name: $name, className: $className)';

  @override
  bool operator ==(covariant StudentModel other) {
    if (identical(this, other)) return true;

    return other.msv == msv &&
        other.name == name &&
        other.className == className;
  }

  @override
  int get hashCode => msv.hashCode ^ name.hashCode ^ className.hashCode;
}
