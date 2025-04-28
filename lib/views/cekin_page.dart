import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projek_absen/service/auth_repo.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final AuthRepository _repo = AuthRepository();
  bool isLoading = false;
  bool isCheckedIn = false;
  String? statusMessage;
  String? locationText;

  Future<void> handleCheckIn() async {
    setState(() => isLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await _repo.checkIn(
        position.latitude,
        position.longitude,
        'Alamat otomatis',
      );

      Get.snackbar(
        'Sukses',
        response.message ?? 'Berhasil absen masuk',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );

      setState(() {
        statusMessage = 'Sudah absen masuk';
        locationText = '${position.latitude}, ${position.longitude}';
        isCheckedIn = true;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );

      setState(() {
        statusMessage = 'Gagal absen masuk';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleCheckOut() async {
    setState(() => isLoading = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await _repo.checkOut(
        position.latitude,
        position.longitude,
        'Alamat otomatis',
      );

      Get.snackbar(
        'Sukses',
        response.message ?? 'Berhasil absen keluar',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );

      setState(() {
        statusMessage = 'Sudah absen keluar';
        locationText = '${position.latitude}, ${position.longitude}';
        isCheckedIn = false;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );

      setState(() {
        statusMessage = 'Gagal absen keluar';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF04162E),
        title: const Text('Absen Masuk/Keluar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.location_on, size: 90, color: Colors.blueAccent),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Status Absensi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          statusMessage ?? 'Belum melakukan absen',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                statusMessage == null
                                    ? Colors.grey
                                    : (statusMessage == 'Sudah absen masuk'
                                        ? Colors.green
                                        : (statusMessage == 'Sudah absen keluar'
                                            ? Colors.blue
                                            : Colors.red)),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const Divider(thickness: 1),
                        const SizedBox(height: 16),
                        Text(
                          'Lokasi Terkini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            locationText ?? 'Lokasi belum tersedia',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        isCheckedIn ? null : handleCheckIn,
                                    icon: const Icon(Icons.login),
                                    label: const Text('Absen Masuk'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      textStyle: const TextStyle(fontSize: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        isCheckedIn ? handleCheckOut : null,
                                    icon: const Icon(Icons.logout),
                                    label: const Text('Absen Keluar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      textStyle: const TextStyle(fontSize: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ],
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
}
