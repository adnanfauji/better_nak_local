import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final String baseUrl = "http://192.168.253.188/api_local";

  Future<bool> checkServerConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health_check.php'));

      // Cek apakah status 200 dan respons berisi teks atau JSON valid
      if (response.statusCode == 200) {
        print('Server Connected: ${response.body}');
        return true;
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Connection Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {"email": email, "password": password},
      );

      print("Login Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"status": "error", "message": "Gagal menghubungi server"};
      }
    } catch (e) {
      print('Login Error: $e');
      return {"status": "error", "message": "Kesalahan jaringan"};
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "role": role
      },
    );
    return json.decode(response.body);
  }
}
