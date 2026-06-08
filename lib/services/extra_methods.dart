import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Download using http
// import 'package:http/http.dart' as http;
//
// Future<File> downloadFile({required String url}) async {
// final http.Response imgResponse = await http.get(Uri.parse(url));
// final Directory directory = await getTemporaryDirectory();
// File requiredImageFile = await File('${directory.path}/Image.png')
// .writeAsBytes(imgResponse.bodyBytes);

// return requiredImageFile;
// }

// class DownloadFiles {
//   bool isDownloading = true;
//   String progress = '';
//
//   Future<void> downloadAndOpenFile({required int assignedVehicleId}) async {
//     log('${AppConstants.baseUrl}${AppConstants.downloadPdf}');
//     try {
//       isDownloading = true;
//
//       progress = "Starting download...";
//       Fluttertoast.showToast(msg: 'Downloading...');
//
//       Directory? appDirectory = await createAppDirectory();
//       if (appDirectory == null) {
//         Fluttertoast.showToast(msg: 'Failed to create directory');
//         isDownloading = false;
//         progress = "Error: Directory creation failed";
//         return;
//       }
//
//       String filePath = '${appDirectory.path}/vehicle-$assignedVehicleId.pdf';
//       log(filePath, name: 'FilePath');
//
//       var response = await GetIt.instance.get<Dio>().download(
//         '${AppConstants.baseUrl}${AppConstants.downloadPdf}?assign_vehicle_id=$assignedVehicleId',
//         queryParameters: {
//           'assign_vehicle_id': assignedVehicleId,
//         },
//         filePath,
//       );
//       if (response.statusCode == 200) {
//         log('${response.data}', name: 'Response');
//
//         isDownloading = false;
//         progress = "Download complete";
//
//         Fluttertoast.showToast(msg: 'Download Completed');
//         OpenFile.open(filePath);
//       } else {
//         isDownloading = false;
//         progress = "Error: File not found";
//         Fluttertoast.showToast(msg: 'File not found');
//       }
//     } catch (e) {
//       isDownloading = false;
//       progress = "Error: $e";
//       Fluttertoast.showToast(msg: 'Error while Downloading file');
//     }
//   }
//
//   Future<Directory?> createAppDirectory() async {
//
//     // ------ For Saving in Directory --------
//     if (Platform.isAndroid) {
//       // Directory? externalDir = await getExternalStorageDirectory();
//       String newPath = "/storage/emulated/0/Download/Amara Realty";
//       Directory appDir = Directory(newPath);
//       if (!await appDir.exists()) {
//         await appDir.create(recursive: true);
//       }
//       return appDir;
//     } else if (Platform.isIOS) {
//       //
//       Directory iosDir = await getApplicationDocumentsDirectory();
//       String newPath = path.join(iosDir.path, 'Amara Realty');
//       Directory appDir = Directory(newPath);
//       if (!await appDir.exists()) {
//         await appDir.create(recursive: true);
//       }
//       return appDir;
//     }
//     return null;
//
//   // import 'package:path/path.dart' as path;
//   // ---- For No Saving ------
//   //   Directory appDir = await getTemporaryDirectory();
//   //   if (!await appDir.exists()) {
//   //     await appDir.create(recursive: true);
//   //   }
//   //   return appDir;
//   }
// }

class ExtraMethods {
  String getWhatsAppUrl(String number, [String msg = '']) {
    return 'https://wa.me/91$number?text=$msg';
  }

  /// Also Add Queries in AndroidManifest Refer Url Launcher Package Documentation
  void makeCall(String number) async {
    final url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    }
  }

  /* void makeCall(String number) {
    if (number.startsWith('+91')) {
      launchInBrowser("tel:$number");
    } else {
      launchInBrowser("tel:+91$number");
    }
  }*/

  // static Future<void> openGoogleMaps(LatLng latLng) async {
  //   final Uri googleMapsUri = Uri.parse(
  //       "https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}");

  //   if (await canLaunchUrl(googleMapsUri)) {
  //     await launchUrl(googleMapsUri);
  //   } else {
  //     throw 'Could not launch Google Maps';
  //   }
  // }

  // static makeAddressString({required AddressModel? address}) {
  //   List<String?> adds = [
  //     address?.addressLineOne,
  //     address?.addressLineTwo,
  //     address?.landmark,
  //     address?.city,
  //     address?.state,
  //     address?.pincode?.toString(),
  //   ].where((part) => part != null && part.isNotEmpty).toList();

  //   return adds.join(', ');
  // }

  // static drawGoogleRoute(
  //     {required LatLng source, required LatLng destination}) {
  //   try {
  //     launchUrl(
  //       Uri.parse(
  //           'https://www.google.com/maps/dir/?api=1&origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving&dir_action=navigate'),
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } catch (ex) {
  //     Fluttertoast.showToast(msg: 'Incorrect Address');
  //   }
  // }

  void makeMail(String email, [String subject = '']) {
    try {
      Uri emailLaunchUri = Uri(
          scheme: 'mailto', path: email, queryParameters: {'subject': subject});
      var url = emailLaunchUri.toString().replaceAll('+', ' ');
      launchInBrowser(url);
    } catch (e) {
      log(e.toString(), name: "Error at makeMail");
    }
  }

  static Future<void> launchInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'},
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'Invalid url {$url}');
      log('Could not launch $url');
    }
  }

  static Future<void> launchWebsite(String url) async {
    if (!(url.startsWith('http'))) {
      if (!(url.startsWith('https://'))) {
        url = 'https://$url';
      }
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      log('Could not launch $url');
    }
  }
}

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}
