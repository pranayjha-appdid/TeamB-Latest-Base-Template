import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raigadkar/services/extensions.dart';

import '../data/api/api_checker.dart';
import '../data/models/basic_model/business_setting_model.dart';
import '../data/models/response/response_model.dart';
import '../data/repositories/basic_repo.dart';
import '../main.dart';
import '../services/enums/bussiness_setting_enum.dart';
import '../views/screens/auth_screens/login_screen.dart';

class BasicController extends GetxController implements GetxService {
  final BasicRepo basicRepo;
  BasicController({required this.basicRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //----get bussiness setting ----
  int? appVersion;
  String? androidAppLink;
  List<BussinessSetting> bussinessSettings = [];
  Future<ResponseModel> getBussinessSetting() async {
    log("getBussinessSettingData called");
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await basicRepo.getBussinessSettingData();
      if (response.statusCode == 200 && response.body['success']) {
        log(response.bodyString.toString(), name: "getBussinessSettingData");
        bussinessSettings = (response.body['data'] as List<dynamic>).map((response) => BussinessSetting.fromJson(response)).toList();
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT getBussinessSetting()");
      responseModel = ResponseModel(false, "$e");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  //
  String getHtmlContent(BussinessSettingName name) {
    for (int i = 0; i < bussinessSettings.length; i++) {
      if (name == BussinessSettingName.privacyPolicy) {
        if (bussinessSettings[i].key == 'privacy_policy') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.contactUs) {
        if (bussinessSettings[i].key == 'contact_us') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.aboutUs) {
        if (bussinessSettings[i].key == 'about_us') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.helpCenter) {
        if (bussinessSettings[i].key == 'help_center') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.termsAndCondition) {
        if (bussinessSettings[i].key == 'terms_and_condition') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.credits) {
        if (bussinessSettings[i].key == 'credits') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.support) {
        if (bussinessSettings[i].key == 'support') {
          return bussinessSettings[i].value ?? 'NA';
        }
      } else if (name == BussinessSettingName.cancelationPolicy) {
        if (bussinessSettings[i].key == 'cancellation_policy') {
          return bussinessSettings[i].value ?? 'NA';
        }
      }
    }
    return 'NA';
  }

  String? getBusinessSettingValue(String key) {
    return bussinessSettings.firstWhere((setting) => setting.key == key, orElse: () => BussinessSetting()).value;
  }

  // onboarding screen
  final PageController pageController = PageController();
  int currentPage = 0;
  final int totalPages = 3;

  bool isForward = true;
  double currentProgress = 1 / 3;

  void nextPage(BuildContext context) {
    if (currentPage < totalPages - 1) {
      currentPage++;
      currentProgress = (currentPage + 1) / totalPages;

      pageController.animateToPage(currentPage, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      update();
    } else {
      skipToLogin(context);
    }
  }

  void onPageChanged(int page) {
    currentPage = page;
    currentProgress = (currentPage + 1) / totalPages;
    update();
    if (currentPage >= totalPages) {
      skipToLogin(navigatorKey.currentState!.context);
    }
  }

  void skipToLogin(BuildContext context) {
    context.pushAndRemoveUntil(LoginScreen());
  }

  Future<ResponseModel> updateBusinessseetingValue(dynamic data) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    try {
      Response response = await basicRepo.updateBusinessseetingValue(data);
      log(response.bodyString.toString(), name: "updateBusinessseetingValue");
      log(response.statusCode.toString());
      if (response.statusCode == 200 && response.body['success'] == true) {
        responseModel = ResponseModel(true, '${response.body}', response.body);
      } else {
        responseModel = ResponseModel(false, '${response.body}', response.body);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");

      log('++++ ${e.toString()} +++++++', name: "ERROR AT updateBusinessseetingValue()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool _isifscLoading = false;

  bool get isifscLoading => _isifscLoading;

  Future<ResponseModel> verifyIfscCode(String ifsccode) async {
    log('verifyIfscCode CALLED');
    ResponseModel responseModel;
    _isifscLoading = true;
    update();
    try {
      final url = "https://ifsc.razorpay.com/$ifsccode";
      final response = await http.get(Uri.parse(url));
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body, name: 'verifyIfscCode');
        final data = jsonDecode(response.body);
        var returndata = {'bank_name': data["BANK"], 'branch_name': data["BRANCH"], 'address': data["ADDRESS"]};
        responseModel = ResponseModel(true, "SUCCESS", returndata);
      } else {
        log(response.body, name: 'verifyIfscCode');
        Fluttertoast.showToast(msg: "Enter Valid IFSC Code");
        responseModel = ResponseModel(false, response.toString(), "UNSUCCESSFUL");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "UNSUCCESSFUL");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT fetchPlaceDetailsById()");
    }
    _isifscLoading = false;
    update();
    return responseModel;
  }
}
