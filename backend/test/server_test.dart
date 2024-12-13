import 'dart:io';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://127.0.0.1:$port';
  late Process p;

  // Trước khi chạy test, khởi động server
  setUp(() async {
    p = await Process.start(
      'dart',
      [
        'run',
        'bin/server.dart'
      ], // Đảm bảo rằng bạn có file server.dart trong thư mục bin
      environment: {'PORT': port}, // Thiết lập cổng
    );
    // Chờ server khởi động và xuất ra stdout.
    await p.stdout.forEach((line) {
      print('stdout: ${String.fromCharCodes(line)}');
    });
  });

  // Sau khi chạy test xong, tắt server
  tearDown(() => p.kill());

  test('Root route should return Hello, World!', () async {
    final response = await get(Uri.parse('$host/'));
    expect(response.statusCode, 200);
    final body = response.body;
    expect(body, contains('Hello, World!'));
  });

  test('Echo route should return the same message', () async {
    final response = await get(Uri.parse('$host/api/v1/echo/hello'));
    expect(response.statusCode, 200);
    expect(response.body, 'hello\n');
  });

  test('Submit route with name should return welcome message', () async {
    final payload = '{"name": "John"}';
    final response = await post(
      Uri.parse('$host/api/v1/submit'),
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );
    expect(response.statusCode, 200);
    final body = response.body;
    expect(body, contains('Chào mừng John'));
  });

  test('Submit route without name should return error message', () async {
    final payload = '{"name": ""}';
    final response = await post(
      Uri.parse('$host/api/v1/submit'),
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );
    expect(response.statusCode, 400);
    final body = response.body;
    expect(body, contains('Server không nhận được tên của bạn.'));
  });

  test('Submit route with invalid JSON should return error message', () async {
    final payload = '{"name":}'; // Invalid JSON format
    final response = await post(
      Uri.parse('$host/api/v1/submit'),
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );
    expect(response.statusCode, 400);
    final body = response.body;
    expect(body, contains('Yêu cầu không hợp lệ'));
  });

  test('404 for unknown route should return 404', () async {
    final response = await get(Uri.parse('$host/api/v1/unknown'));
    expect(response.statusCode, 404);
    final body = response.body;
    expect(body, contains('Không tìm thấy đường dẫn'));
  });
}
