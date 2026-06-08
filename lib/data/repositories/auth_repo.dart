import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AuthRepo({required this.sharedPreferences, required this.apiClient});

  /// Methods to deal with Remote Data ///
  Future<Response> login({required Map<String, dynamic> data}) async => await apiClient.postData(AppConstants.loginUri, data);

  Future<Response> otpVerification({required Map<String, dynamic> data}) async => await apiClient.postData(AppConstants.otpVerifyUri, data);

  Future<Response> getUserData() async => await apiClient.getData(AppConstants.profileUri);

  Future<Response> getLogOut() async => await apiClient.getData(AppConstants.logOutUri);

  Future<Response> registration({required Map<String, dynamic> data}) async => await apiClient.postData(AppConstants.registerUri, FormData(data));

  /// Methods to deal with Local Data ///
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<bool> saveUserId(String id) async {
    log(getUserId());
    return await sharedPreferences.setString(AppConstants.userId, id);
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool isFirstTimeVisit() {
    return !sharedPreferences.containsKey(AppConstants.firstTimeVisit);
  }

  Future<bool> saveFirstTimeVisit() async {
    return await sharedPreferences.setBool(AppConstants.firstTimeVisit, true);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    apiClient.token = null;
    apiClient.updateHeader(null);
    sharedPreferences.clear();
    return true;
  }

  Future<String?> getDeviceID() async {
    try {
      // uncomment this when you implement firebase
      // final String? deviceId = await FirebaseMessaging.instance.getToken();
      final String deviceId = "";
      return deviceId;
    } catch (e) {
      return 'DeviceIDNotFound';
    }
  }
}
