import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_absen/model/model_profile.dart';
import 'package:projek_absen/service/auth_repo.dart';
import 'package:projek_absen/service/pref_handler.dart';
import 'package:projek_absen/views/edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthRepository _authRepo = AuthRepository();
  late Future<ModelProfil> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = _authRepo.getUserProfile();
  }

  Future<void> _logout() async {
    await PreferenceHandler.logout();
    Get.offAllNamed('/login');
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
          FutureBuilder<ModelProfil>(
            future: _futureProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat profil: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final user = snapshot.data?.data;
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color.fromARGB(255, 4, 22, 46),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user?.name ?? '-',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user?.email ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Akun dibuat: ${user?.createdAt?.toLocal().toString().split(' ')[0] ?? '-'}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditProfilePage(
                                  userData: snapshot.data!,
                                ), // Pastikan EditProfilePage butuh userData
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            _futureProfile = _authRepo.getUserProfile();
                          });
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profil"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
