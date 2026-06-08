import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  static bool isProduction = true;
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;
  static const String liveUrl = 'baseurl';
  static const String localUrl = 'http://192.168.1.113:8003/';
  static String baseUrl = (kReleaseMode || isProduction) ? liveUrl : localUrl;

  static String appName = 'StressFree365';
  static String version = '';
  static String buildNumber = '';
  static const String agoraAppId = '826885ab8b29497cba24b7a1f5be80de';

  //-----------Auth---------------
  static const String loginUri = 'api/user/auth/otp/send';
  static const String otpVerifyUri = 'api/user/auth/otp/verify';
  static const String profileUri = 'api/user/auth/profile';
  static const String logOutUri = 'api/user/auth/logout';
  static const String registerUri = 'api/user/auth/register';

  //-----------Basic--------------
  static const String businessSettingUri = 'api/basic/business-setting';
  static const String bannerUri = 'api/basic/banner';
  static const String citiesUri = 'api/basic/cities';
  static const String updatebusinessSeetingValue = 'api/basic/set-app-versions';

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String firstTimeVisit = 'first_time_visit';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';

  static double screenheight = MediaQuery.of(navigatorKey.currentState!.context).size.height;
  static double screenwidth = MediaQuery.of(navigatorKey.currentState!.context).size.width;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
}
