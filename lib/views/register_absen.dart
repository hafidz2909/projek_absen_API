import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_absen/service/auth_repo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await authRepository.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Get.snackbar('Sukses', 'Registrasi berhasil');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 4, 22, 46),
                  Color.fromARGB(255, 60, 141, 255),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(50),
                    height: 150,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/AppSenceLogo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildInputLabel('Nama'),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Masukkan nama anda',
                          validator: _validateName,
                        ),
                        _buildInputLabel('E-Mail'),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Masukkan email anda',
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildInputLabel('Password'),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Masukkan password',
                          obscureText: true,
                          validator: _validatePassword,
                        ),
                        _buildInputLabel('Konfirmasi Password'),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Ulangi password',
                          obscureText: true,
                          validator: _validateConfirmPassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 22, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child:
                          _loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 38, 222, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    child: const Text(
                      'Sudah punya akun? Login di sini',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable input label
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 22, 46),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Reusable input field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: const Color.fromARGB(255, 38, 222, 255),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
