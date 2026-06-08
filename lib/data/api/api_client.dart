// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raigadkar/services/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../services/constants.dart';
import '../../views/screens/auth_screens/login_screen.dart';
import '../models/response/error_response.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    try {
      baseUrl = appBaseUrl;
      timeout = const Duration(seconds: 30);
      token = sharedPreferences.getString(AppConstants.token) ?? '';
      if (kDebugMode) {
        print('Token: $token');
      }
      _mainHeaders = {'Accept': 'application/json', 'Authorization': 'Bearer $token', 'x-api-version': AppConstants.buildNumber};
    } catch (e) {
      log('******** ${e.toString()} ********+', name: "ERROR AT ApiClient()");
    }
  }

  void updateHeader(String? token) {
    _mainHeaders = {'Accept': 'application/json', 'Authorization': 'Bearer $token', 'x-api-version': AppConstants.buildNumber};
  }

  // ---------------------------------------------------------------------------
  // 🔵 RETRY LOGIC FOR GETX REQUESTS
  // ---------------------------------------------------------------------------
  Future<Response> _retryGetxRequest(Future<Response> Function() requestFn, {int retries = 3, Duration delay = const Duration(milliseconds: 50)}) async {
    int attempt = 0;

    while (true) {
      try {
        Response response = await requestFn();

        if (response.statusCode != null) return response;

        if (attempt >= retries) return response;
      } catch (e) {
        if (attempt >= retries) {
          rethrow;
        }
      }

      await Future.delayed(delay);
      attempt++;
      log(attempt.toString(), name: "CheckZoneRetry");
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 RETRY LOGIC FOR HTTP PACKAGE
  // ---------------------------------------------------------------------------
  Future<http.Response> _retryHttp(Future<http.Response> Function() requestFn, {int retries = 2, Duration delay = const Duration(milliseconds: 700)}) async {
    int attempt = 0;

    while (true) {
      try {
        return await requestFn();
      } catch (e) {
        if (attempt >= retries) rethrow;

        if (e is SocketException || e is HttpException || e.toString().contains("Connection closed") || e.toString().contains("HandshakeException")) {
          await Future.delayed(delay);
          attempt++;
          continue;
        }

        rethrow;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 GET DATA
  // ---------------------------------------------------------------------------
  Future<Response> getData(String uri, {Map<String, dynamic>? query, String? contentType, Map<String, String>? headers, Function(dynamic)? decoder}) async {
    try {
      Response response = await _retryGetxRequest(() {
        return get(uri, contentType: contentType, query: query, headers: headers ?? _mainHeaders, decoder: decoder);
      });

      if (response.statusCode != 200) {
        markError(url: uri, method: "GET", respon: response);
      }

      log("Base Url: ${AppConstants.baseUrl}\nmainUrl: $uri \nTOKEN: $token \nstatusCode: ${response.statusCode}", name: "URI");
      log(headers?.toString() ?? _mainHeaders.toString(), name: "URIheaders");
      return handleResponse(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 POST DATA
  // ---------------------------------------------------------------------------
  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      Response response = await _retryGetxRequest(() {
        return post(uri, body, query: query, contentType: contentType, headers: headers ?? _mainHeaders, decoder: decoder, uploadProgress: uploadProgress);
      });

      if (response.statusCode != 200) {
        markError(url: uri, method: "POST", respon: response);
      }

      log("Base Url: ${AppConstants.baseUrl}\nmainUrl: $uri \nTOKEN: $token \nstatusCode: ${response.statusCode}", name: "POST URI");
      log(body.toString(), name: "POST URI");
      return handleResponse(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 PUT DATA
  // ---------------------------------------------------------------------------
  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      Response response = await _retryGetxRequest(() {
        return put(uri, body, query: query, contentType: contentType, headers: headers ?? _mainHeaders, decoder: decoder, uploadProgress: uploadProgress);
      });

      if (response.statusCode != 200) {
        markError(url: uri, method: "PUT", respon: response);
      }
      log("Base Url: ${AppConstants.baseUrl}\nmainUrl: $uri \nTOKEN: $token \nstatusCode: ${response.statusCode}", name: "PUT URI");

      return handleResponse(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 PATCH DATA
  // ---------------------------------------------------------------------------
  Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      Response response = await _retryGetxRequest(() {
        return patch(uri, body, query: query, contentType: contentType, headers: headers ?? _mainHeaders, decoder: decoder, uploadProgress: uploadProgress);
      });

      if (response.statusCode != 200) {
        markError(url: uri, method: "PATCH", respon: response);
      }

      log("Base-Url: ${AppConstants.baseUrl}\nmain-Url: $uri \nTOKEN: $token \nstatusCode: ${response.statusCode}", name: "PATCH URI");

      return handleResponse(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 DELETE DATA
  // ---------------------------------------------------------------------------
  Future<Response> deleteData(String uri, {Map<String, dynamic>? query, String? contentType, Map<String, String>? headers, Function(dynamic)? decoder}) async {
    try {
      Response response = await _retryGetxRequest(() {
        return delete(uri, headers: headers ?? _mainHeaders, contentType: contentType, query: query, decoder: decoder);
      });

      if (response.statusCode != 200) {
        markError(url: uri, method: "DELETE", respon: response);
      }
      log("Base Url: ${AppConstants.baseUrl}\nmainUrl: $uri \nTOKEN: $token \nstatusCode: ${response.statusCode}", name: "Delete URI");

      return handleResponse(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 HANDLE RESPONSE
  // ---------------------------------------------------------------------------
  Response handleResponse(Response response, {String? url, String? method}) {
    if (response.statusCode == null) return response;

    Response result = response;

    if (response.hasError && response.body != null && response.body is! String) {
      if (response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response.body);
        result = Response(statusCode: response.statusCode, body: response.body, statusText: errorResponse.errors[0].message);
      } else if (response.body.toString().startsWith('{message')) {
        result = Response(statusCode: response.statusCode, body: response.body, statusText: response.body['message']);
      }
    } else if (response.hasError && response.body == null) {
      result = const Response(statusCode: 0, statusText: 'Connection to API server failed due to internet connection');
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // 🔵 NORMAL HTTP POST WITH RETRY
  // ---------------------------------------------------------------------------
  Future<dynamic> commonApiCall(String urlR, Map<String, dynamic> body) async {
    final postUri = Uri.parse(urlR);
    try {
      final response = await _retryHttp(() {
        return http.post(postUri, body: body, headers: _mainHeaders);
      });

      return response;
    } catch (e) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔵 NORMAL HTTP GET WITH RETRY
  // ---------------------------------------------------------------------------
  Future<dynamic> commonApiCallGet(String url) async {
    final postUri = Uri.parse(url);
    try {
      final response = await _retryHttp(() {
        return http.get(postUri, headers: _mainHeaders);
      });

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response?> markError({required String url, required String method, required Response respon}) async {
    try {
      if (respon.statusCode == 401) {
        handleUnauthorize();
      }
      if (kDebugMode) return null;

      final uri = Uri.parse("https://automation.appdid.work/webhook/1feffbf3-8094-4b58-9b62-8e0a5f56b5a6").replace(
        queryParameters: {
          'project_name': AppConstants.appName,
          'api_url': url,
          "method": method,
          "status_code": respon.statusCode.toString(),
          "error_message": getErrorMessage(respon),
        },
      );

      log('Sending request to $uri');

      final response = await http.post(uri);

      log('Response: ${response.statusCode} ${response.body}');
      return response;
    } catch (e) {
      log('Error at markError: $e');
      return null;
    }
  }

  String getErrorMessage(Response respon) {
    String message;

    if (respon.body != null && respon.body.toString().isNotEmpty) {
      message = respon.body.toString();
      if (message.length > 1000) {
        message = message.substring(0, 1000);
      }
    } else if (respon.statusText != null) {
      message = respon.statusText!;
    } else {
      message = "Unknown error";
    }
    return message;
  }

  void handleUnauthorize() {
    navigatorKey.currentState?.context.pushAndRemoveUntil(LoginScreen());
  }
}
