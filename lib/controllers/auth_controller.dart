import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raigadkar/services/extensions.dart';

import '../data/api/api_checker.dart';
import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../services/constants.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _acceptTerms = true;

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get acceptTerms => _acceptTerms;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  void updateisLoading(bool val) {
    _isLoading = val;
    update();
  }

  //-------------Login-------------------
  Future<ResponseModel> login({required Map<String, dynamic> data}) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    log("response.body.toString()${AppConstants.baseUrl}${AppConstants.loginUri}", name: "login");
    try {
      Response response = await authRepo.login(data: data);
      if (response.statusCode == 200 && response.body['success']) {
        responseModel = ResponseModel(true, '${response.body['message']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT login()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  //-------------OTP Verification------------------
  String? type;
  Future<ResponseModel> verifyOTP(Map<String, dynamic> data) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await authRepo.otpVerification(data: data);
      log(response.body.toString());
      if (response.statusCode == 200) {
        if (response.body['success'] == true && response.body['otp_verified'] == true && response.body['token'] != null) {
          setUserToken(id: response.body['token']);
          type = response.body['user_type'];
          responseModel = ResponseModel(true, '${response.body['user_type']}', response.body);
        } else {
          responseModel = ResponseModel(false, '${response.body['message']}', response.body);
        }
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT verifyOTP()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  //
  Future<ResponseModel> logOut() async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await authRepo.getLogOut();

      if (response.statusCode == 200) {
        clearSharedData();
        log(response.bodyString!, name: "logOut");

        update();
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT logOut()");
      responseModel = ResponseModel(false, "$e");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  //
  Future<ResponseModel> getUserProfileData() async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await authRepo.getUserData();
      if (response.statusCode == 200 && response.body['success']) {
        log(response.bodyString.toString(), name: "UserModel");
        _userModel = UserModel.fromJson(response.body['data'] as Map<String, dynamic>);

        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT getUserProfileData()");
      responseModel = ResponseModel(false, "$e");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool isRegisterLoading = false;
  Future<ResponseModel> registerUser({required Map<String, dynamic> data}) async {
    ResponseModel responseModel;
    isRegisterLoading = true;
    update();
    log("response.body.toString()${AppConstants.baseUrl}${AppConstants.registerUri}", name: "login");
    try {
      Response response = await authRepo.registration(data: data);
      if (response.statusCode == 200 && response.body['success']) {
        responseModel = ResponseModel(true, '${response.body['message']}', response.body);
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++', name: "ERROR AT registerUser()");
    }
    isRegisterLoading = false;
    update();
    return responseModel;
  }

  //-------------------------------------------------------------------------------------------------\\
  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  void setUserToken({required String id}) async {
    await authRepo.saveUserToken(id);
    // getUserProfileData();
  }

  bool isFirstTimeVisit() {
    return authRepo.isFirstTimeVisit();
  }

  void setFirstTimeVisit() async {
    await authRepo.saveFirstTimeVisit();
  }

  Future<String?> getDeviceId() async {
    return await authRepo.getDeviceID();
  }

  /// DOB Calculator
  DateTime? selectedBirthDate;
  String? calculatedAge;
  final dobController = TextEditingController();

  void calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    selectedBirthDate = birthDate;
    int years = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      years--;
    }

    if (years > 0) {
      calculatedAge = "$years ${years == 1 ? 'year' : 'years'}";
    } else {
      int months = (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
      if (today.day < birthDate.day) {
        months--;
      }

      if (months > 0) {
        calculatedAge = "$months ${months == 1 ? 'month' : 'months'}";
      } else {
        int days = today.difference(birthDate).inDays;
        if (days <= 0) {
          calculatedAge = "0 days";
        } else {
          calculatedAge = "$days ${days == 1 ? 'day' : 'days'}";
        }
      }
    }

    dobController.text = birthDate.dMonthYear;
    update();
  }

  @override
  void onClose() {
    dobController.dispose();
    super.onClose();
  }
}
