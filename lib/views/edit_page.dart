import 'package:flutter/material.dart';
import 'package:projek_absen/model/model_profile.dart';
import 'package:projek_absen/service/auth_repo.dart';

class EditProfilePage extends StatefulWidget {
  final ModelProfil userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _authRepo = AuthRepository();

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.name);
    _emailController = TextEditingController(text: widget.userData.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _message = null;
      });

      try {
        final response = await _authRepo.updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );

        if (response) {
          if (!mounted) return;
          Navigator.pop(context, true); // <-- kembali dan kasih tanda berhasil
        } else {
          setState(() {
            _message = "Gagal memperbarui profil.";
          });
        }
      } catch (e) {
        setState(() {
          _message = "Terjadi kesalahan: $e";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _message!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Email tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text("Simpan"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
