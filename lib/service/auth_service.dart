import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_absen/model/model_cekin.dart';
import 'package:projek_absen/model/model_cekot.dart';
import 'package:projek_absen/model/model_history.dart';
import 'package:projek_absen/model/model_izin.dart';
import 'package:projek_absen/model/model_login.dart';
import 'package:projek_absen/model/model_profile.dart' as profile;
import 'package:projek_absen/model/model_register.dart';
import 'package:projek_absen/service/endpoint.dart';
import 'package:projek_absen/service/pref_handler.dart';

class AuthService {
  static const String baseUrl = 'https://absen.quidi.id/api';

  Future<ModelLogin> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return ModelLogin.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Login gagal');
    }
  }

  Future<ModelRegister> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password, // jika backend butuh konfirmasi
      },
    );

    if (response.statusCode == 200) {
      return ModelRegister.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Registrasi gagal');
    }
  }

  Future<profile.ModelProfil> getProfile() async {
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return profile.welcomeFromJson(response.body);
    } else {
      throw Exception('Gagal memuat profil');
    }
  }

  Future<ModelCheckIn> checkIn({
    required double lat,
    required double lng,
    required String address,
  }) async {
    final token = await PreferenceHandler.getToken();
    print('📡 Body request absen:');
    print({
      'check_in_lat': lat,
      'check_in_lng': lng,
      'check_in_address': address,
      'status': 'masuk',
    });

    final response = await http.post(
      Uri.parse('$baseUrl/absen/check-in'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_in_lat': lat.toString(),
        'check_in_lng': lng.toString(),
        'check_in_address': address,
        'status': 'masuk',
      },
    );

    if (response.statusCode == 200) {
      return ModelCheckIn.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal melakukan absen masuk');
    }
  }

  //izin
  // Future<ModelCheckIn> izin({required String alasan}) async {
  //   final token = await PreferenceHandler.getToken();
  //   final url = Uri.parse('${Endpoint.baseUrl}${Endpoint.checkIn}');

  //   final response = await http.post(
  //     url,
  //     headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  //     body: {'alasan_izin': alasan},
  //   );

  //   if (response.statusCode == 200) {
  //     return ModelCheckIn.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Gagal mengajukan izin');
  //   }
  // }

  // Future<IzinAbsenModel> izin({
  //     required double lat,
  //     required double lng,
  //     required String address,
  //     required String alasan,
  //   }) async {
  //     final token = await PreferenceHandler.getToken();
  //     print('📡 Body request absen:');
  //     print({
  //       'check_in_lat': lat,
  //       'check_in_lng': lng,
  //       'check_in_address': address,
  //       'status': 'izin',
  //       'alasan_izin': alasan,
  //     });

  //     final response = await http.post(
  //       Uri.parse('$baseUrl/absen/check-in'),
  //       headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  //       body: {
  //         'check_in_lat': lat.toString(),
  //         'check_in_lng': lng.toString(),
  //         'check_in_address': address,
  //         'status': 'izin',
  //         'alasan_izin': alasan,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return IzinAbsenModel.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Gagal melakukan absen masuk');
  //     }
  //   }

  Future<IzinAbsenModel> getIzin({
    required double lat,
    required double lng,
    required String address,
    required String alasanIzin,
    required String status,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(
      '${Endpoint.baseUrl}/absen/check-in',
    ); // <- Pasti pakai baseUrl rapi
    print('📡 Body request izin:');
    print({
      'check_in_lat': lat,
      'check_in_lng': lng,
      'check_in_address': address,
      'status': 'izin',
      'alasan_izin': alasanIzin,
    });

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_in_lat': lat.toString(),
        'check_in_lng': lng.toString(),
        'check_in_address': address,
        'status': 'izin', // <-- statusnya izin
        'alasan_izin': alasanIzin, // <-- tambahan alasan izin
      },
    );

    if (response.statusCode == 200) {
      print('✅ Izin berhasil dicatat.');
      return IzinAbsenModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print('❌ Gagal izin: ${error['message']}');
      throw Exception(error['message'] ?? 'Gagal mencatat izin');
    }
  }

  Future<ModelCheckIn> checkInPermission({
    required double lat,
    required double lng,
    required String address,
    required String alasanIzin,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse(
      '${Endpoint.baseUrl}/absen/check-in',
    ); // <- Pasti pakai baseUrl rapi
    print('📡 Body request izin:');
    print({
      'check_in_lat': lat,
      'check_in_lng': lng,
      'check_in_address': address,
      'status': 'izin',
      'alasan_izin': alasanIzin,
    });

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_in_lat': lat.toString(),
        'check_in_lng': lng.toString(),
        'check_in_address': address,
        'status': 'izin', // <-- statusnya izin
        'alasan_izin': alasanIzin, // <-- tambahan alasan izin
      },
    );

    if (response.statusCode == 200) {
      print('✅ Izin berhasil dicatat.');
      return ModelCheckIn.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print('❌ Gagal izin: ${error['message']}');
      throw Exception(error['message'] ?? 'Gagal mencatat izin');
    }
  }

  Future<ModelCheckOut> checkOut({
    required double lat,
    required double lng,
    required String address,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/absen/check-out');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_out_lat': lat.toString(),
        'check_out_lng': lng.toString(),
        'check_out_address': address,
        'status': 'keluar',
      },
    );

    final data = jsonDecode(response.body);
    return ModelCheckOut.fromJson(data);
  }

  Future<ModelHistory> getHistory() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/absen/history');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    return ModelHistory.fromJson(data);
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('${Endpoint.baseUrl}${Endpoint.profile}');
    print('📡 Body request update profile:');

    final response = await http.put(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'name': name, 'email': email},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Gagal memperbarui profil');
    }
  }

  Future<bool> deleteHistory(int id) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse('$baseUrl/absen/$id');

    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menghapus data');
    }
  }
}
