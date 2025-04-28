import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_absen/model/model_history.dart';
import 'package:projek_absen/model/model_izin.dart'; // ⬅️ pastikan file ini ada
import 'package:projek_absen/service/auth_repo.dart';

class HistoryAbsenPage extends StatefulWidget {
  const HistoryAbsenPage({super.key});

  @override
  State<HistoryAbsenPage> createState() => _HistoryAbsenPageState();
}

class _HistoryAbsenPageState extends State<HistoryAbsenPage> {
  final AuthRepository _repo = AuthRepository();
  late Future<ModelHistory> _historyFuture;

  IzinData? _izinData; // ⬅️ data izin
  bool _showIzinCard = false; // ⬅️ apakah ditampilkan atau tidak

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _repo.getHistory();
  }

  Future<void> _deleteHistory(int id) async {
    try {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah yakin ingin menghapus data absen ini?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _repo.deleteHistory(id);
        Get.snackbar(
          'Berhasil',
          'Data berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        setState(() {
          _loadHistory(); // reload data setelah delete
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadIzin() async {
    try {
      final result = await _repo.getIzin(
        0.0, // lat
        0.0, // lng
        'Alamat otomatis', // alamat
        'Alasan izin', // alasan izin
        'izin', // status
      );
      if (result.data != null) {
        setState(() {
          _izinData = result.data;
          _showIzinCard = true;
        });
      } else {
        Get.snackbar(
          'Info',
          'Tidak ada data izin',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.event_note),
        //     tooltip: 'Lihat Izin',
        //     onPressed: _loadIzin,
        //   ),
        // ],
      ),
      body: FutureBuilder<ModelHistory>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data?.data ?? [];

          if (data.isEmpty && !_showIzinCard) {
            return const Center(child: Text('Belum ada data absensi.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_showIzinCard && _izinData != null)
                Card(
                  color: Colors.yellow[100],
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.info, color: Colors.orange),
                    title: const Text('Status: Izin'),
                    subtitle: Text('Alasan: ${_izinData!.alasanIzin ?? '-'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _showIzinCard = false;
                        });
                      },
                    ),
                  ),
                ),
              ...data.map((absen) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      absen.status == 'masuk' ? Icons.login : Icons.logout,
                      color:
                          absen.status == 'masuk' ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      absen.status == 'masuk' ? 'Absen Masuk' : 'Izin Absen',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Check In: ${absen.checkIn?.toLocal().toString().substring(0, 16) ?? '-'}',
                        ),
                        Text(
                          'Check Out: ${absen.checkOut?.toLocal().toString().substring(0, 16) ?? '-'}',
                        ),
                        Text('Status: ${absen.status?.capitalizeFirst ?? '-'}'),
                        Text(
                          'Alasan: ${absen.alasanIzin?.toString().isNotEmpty == true ? absen.alasanIzin : '-'}',
                        ),
                        const SizedBox(height: 4),
                        Text('Lokasi: ${absen.checkInLocation ?? '-'}'),
                      ],
                    ),

                    trailing: IconButton(
                      onPressed: () {
                        if (absen.id != null) {
                          _deleteHistory(absen.id!);
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:projek_absen/model/model_history.dart';
// import 'package:projek_absen/service/auth_repo.dart';

// class HistoryAbsenPage extends StatefulWidget {
//   const HistoryAbsenPage({super.key});

//   @override
//   State<HistoryAbsenPage> createState() => _HistoryAbsenPageState();
// }

// class _HistoryAbsenPageState extends State<HistoryAbsenPage> {
//   final AuthRepository _repo = AuthRepository();
//   late Future<ModelHistory> _historyFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }

//   void _loadHistory() {
//     _historyFuture = _repo.getHistory();
//   }

//   Future<void> _deleteHistory(int id) async {
//     try {
//       final confirm = await Get.dialog<bool>(
//         AlertDialog(
//           title: const Text('Konfirmasi'),
//           content: const Text('Apakah yakin ingin menghapus data absen ini?'),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(result: false),
//               child: const Text('Batal'),
//             ),
//             TextButton(
//               onPressed: () => Get.back(result: true),
//               child: const Text('Hapus'),
//             ),
//           ],
//         ),
//       );

//       if (confirm == true) {
//         await _repo.deleteHistory(id);
//         Get.snackbar(
//           'Berhasil',
//           'Data berhasil dihapus',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         setState(() {
//           _loadHistory(); // reload data setelah delete
//         });
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Riwayat Absensi'), centerTitle: true),
//       body: FutureBuilder<ModelHistory>(
//         future: _historyFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
//           }

//           final data = snapshot.data?.data ?? [];

//           if (data.isEmpty) {
//             return const Center(child: Text('Belum ada data absensi.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final absen = data[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     absen.status == 'masuk' ? Icons.login : Icons.logout,
//                     color: absen.status == 'masuk' ? Colors.green : Colors.red,
//                   ),
//                   title: Text(
//                     absen.status == 'masuk' ? 'Absen Masuk' : 'Absen Keluar',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 4),
//                       Text(
//                         'Check In: ${absen.checkIn?.toLocal().toString().substring(0, 16) ?? '-'}',
//                       ),
//                       Text('Check Out: ${absen.checkOut?.toString() ?? '-'}'),
//                       const SizedBox(height: 4),
//                       Text('Lokasi: ${absen.checkInLocation ?? '-'}'),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     onPressed: () {
//                       if (absen.id != null) {
//                         _deleteHistory(absen.id!);
//                       }
//                     },
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
