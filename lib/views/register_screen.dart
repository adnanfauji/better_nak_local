import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();
  bool isLoading = false;

  // Fungsi untuk registrasi
  void register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar("Semua kolom wajib diisi!", Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await authController.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (!mounted) return; // Hindari context setelah widget di-dispose

      final isSuccess = response['status'] == 'success';
      _showSnackBar(response['message'], isSuccess ? Colors.green : Colors.red);

      // Jika berhasil, navigasi ke halaman login
      if (isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fungsi untuk menampilkan SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('images/LogoBetter-nak.png', height: 80),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Registrasi untuk Better-Nak",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Isikan data-data dibawah ini dengan benar.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(nameController, "Nama"),
                const SizedBox(height: 10),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 10),
                _buildTextField(passwordController, "Password",
                    isPassword: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk TextField
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
