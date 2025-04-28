import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projek_absen/service/auth_service.dart';
import 'package:projek_absen/service/pref_handler.dart';
import 'package:projek_absen/views/cekin_page.dart';
import 'package:projek_absen/views/history_page.dart';
import 'package:projek_absen/views/profile_tab.dart';

class HomeAbsen extends StatefulWidget {
  const HomeAbsen({super.key});

  @override
  State<HomeAbsen> createState() => _HomeAbsenState();
}

class _HomeAbsenState extends State<HomeAbsen> {
  int _selectedIndex = 0;

  // Daftar konten tiap tab
  final List<Widget> _tabViews = [
    const HomeTabContent(),
    const HistoryAbsenPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await PreferenceHandler.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 22, 46),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: _logout,
          ),
        ],
      ),
      body: _tabViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 60, 141, 255),
        unselectedItemColor: Colors.grey[300],
        backgroundColor: const Color.fromARGB(255, 4, 22, 46),
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  Position? _currentPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final day = weekdays[now.weekday % 7];
    final date = now.day;
    final month = months[now.month - 1];
    final year = now.year;

    return '$day, $date $month $year';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: Column(
            children: [
              Container(
                height: 90,
                width: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/AppSenceLogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: AnalogClock(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          width: 5.0,
                          color: const Color.fromARGB(255, 60, 141, 255),
                        ),
                        shape: BoxShape.circle,
                      ),
                      width: 150.0,
                      height: 150.0,
                      isLive: true,
                      showSecondHand: true,
                      hourHandColor: const Color.fromARGB(255, 60, 141, 255),
                      minuteHandColor: const Color.fromARGB(255, 60, 141, 255),
                      showNumbers: true,
                      numberColor: const Color.fromARGB(255, 60, 141, 255),
                      textScaleFactor: 1.4,
                      showTicks: true,
                      tickColor: const Color.fromARGB(255, 60, 141, 255),
                      datetime: DateTime.now(),
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(227, 79, 227, 255),
                      border: Border.all(
                        width: 5.0,
                        color: const Color.fromARGB(255, 60, 141, 255),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.waving_hand,
                          size: 50,
                          color: Color.fromARGB(255, 4, 22, 46),
                        ),
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 22, 46),
                          ),
                        ),
                        Text(
                          'di AppSence!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 22, 46),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(227, 79, 227, 255),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color.fromARGB(255, 60, 141, 255),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 24,
                    ),
                    child: Center(
                      child: Text(
                        _formattedDate(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 4, 22, 46),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white),
                ),
                child:
                    _currentPosition == null
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: GoogleMap(
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              zoom: 16,
                            ),
                            myLocationEnabled: true,
                            markers: {
                              Marker(
                                markerId: const MarkerId('me'),
                                position: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                infoWindow: const InfoWindow(
                                  title: 'Lokasi Anda',
                                ),
                              ),
                            },
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckInPage()),
                    );
                    // Get.to(
                    //   const CheckInPage(),
                    // ); // pastikan CheckInPage sudah diimport
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 4, 22, 46),
                    ),
                    child: const Center(
                      child: Text(
                        "Absensi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController alasanController =
                            TextEditingController();
                        return AlertDialog(
                          title: const Text('Form Izin'),
                          content: TextField(
                            controller: alasanController,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan alasan izin',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final alasanIzin = alasanController.text.trim();
                                if (alasanIzin.isEmpty) {
                                  // Tambahkan validasi alasan kosong
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Alasan izin tidak boleh kosong.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  // Panggil fungsi izin di sini
                                  await AuthService().checkInPermission(
                                    lat:
                                        -6.2, // Ganti dengan posisi latitude realtime
                                    lng:
                                        106.8, // Ganti dengan posisi longitude realtime
                                    address:
                                        'Jakarta', // Ganti dengan address realtime
                                    alasanIzin: alasanIzin,
                                  );

                                  Navigator.of(
                                    context,
                                  ).pop(); // Tutup dialog setelah berhasil

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Izin berhasil dicatat.'),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Tutup dialog kalau mau
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal mencatat izin: $e'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Kirim'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text(
                        "Izin",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
