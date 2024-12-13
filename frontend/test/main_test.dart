import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/list_screen_student.dart';

void main() {
  testWidgets('Test main screen functionality', (WidgetTester tester) async {
    // Build ListScreen
    await tester.pumpWidget(MaterialApp(home: ListScreen()));

    // Kiểm tra xem danh sách sinh viên có được hiển thị
    expect(find.byType(ListView), findsOneWidget);

    // Kiểm tra có ít nhất một sinh viên trong danh sách
    expect(find.byType(ListTile), findsWidgets);
  });
}
