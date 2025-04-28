import 'package:projek_absen/model/model_cekin.dart';
import 'package:projek_absen/model/model_cekot.dart';
import 'package:projek_absen/model/model_history.dart';
import 'package:projek_absen/model/model_izin.dart';
import 'package:projek_absen/model/model_profile.dart';
import 'package:projek_absen/service/auth_service.dart';
import 'package:projek_absen/service/pref_handler.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    final result = await _authService.login(email, password);

    if (result.data?.token != null) {
      await PreferenceHandler.saveLoginData(
        token: result.data!.token!,
        name: result.data!.user?.name,
        email: result.data!.user?.email,
      );
    } else {
      throw Exception(result.message ?? 'Token tidak ditemukan');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final result = await _authService.register(name, email, password);

    if (result.data?.token != null) {
      await PreferenceHandler.saveLoginData(
        token: result.data!.token!,
        name: result.data!.user?.name,
        email: result.data!.user?.email,
      );
    } else {
      throw Exception(result.message ?? 'Token tidak ditemukan');
    }
  }

  Future<String?> getToken() => PreferenceHandler.getToken();

  Future<ModelProfil> getUserProfile() {
    return _authService.getProfile();
  }

  Future<ModelHistory> getHistory() {
    return _authService.getHistory();
  }

  Future<void> logout() => PreferenceHandler.logout();

  Future<ModelCheckIn> checkIn(double lat, double lng, String address) {
    final response = _authService.checkIn(lat: lat, lng: lng, address: address);
    return response;
  }

  Future<IzinAbsenModel> getIzin(
    double lat,
    double lng,
    String address,
    String alasanIzin,
    String status,
  ) {
    final response = _authService.getIzin(
      lat: lat,
      lng: lng,
      address: address,
      alasanIzin: alasanIzin,
      status: status,
    );
    return response;
  }

  Future<ModelCheckOut> checkOut(double lat, double lng, String address) {
    return _authService.checkOut(lat: lat, lng: lng, address: address);
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final result = await _authService.updateProfile(name: name, email: email);
      return result; // Directly return the boolean result
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<bool> deleteHistory(int id) {
    return _authService.deleteHistory(id);
  }
}
