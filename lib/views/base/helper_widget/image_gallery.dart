// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as pathData;
import 'package:path_provider/path_provider.dart';

import '../../../services/constants.dart';
import '../custom_widget.dart/custom_appbar.dart';
import '../custom_widget.dart/custom_image.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({Key? key, required this.images, this.number, this.repeat = false}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
  final List<dynamic> images;
  final int? number;
  final bool repeat;
}

class _ImageGalleryState extends State<ImageGallery> {
  int currentPage = 0;

  Future<Directory?> createAppDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      log("Base External Dir: ${dir?.path}", name: "Storage");

      final subDir = Directory(pathData.join(dir!.path, AppConstants.appName));

      if (!await subDir.exists()) {
        await subDir.create(recursive: true);
      }

      log("Final App Directory: ${subDir.path}", name: "Storage");
      return subDir;
    } else if (Platform.isIOS) {
      final baseDir = await getApplicationDocumentsDirectory();
      log("iOS Base Dir: ${baseDir.path}", name: "Storage");

      final iosPath = pathData.join(baseDir.path, AppConstants.appName);
      final dir = Directory(iosPath);

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      log("Final App Directory: ${dir.path}", name: "Storage");
      return dir;
    }
    return null;
  }

  Future<void> downloadImage() async {
    try {
      String imageUrl = "${widget.images[currentPage % widget.images.length]}";

      imageUrl = imageUrl.replaceAll('\\', '/');

      // Create request
      final request = await HttpClient().getUrl(Uri.parse(imageUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        // Get Downloads directory (Android)
        // Directory? directory;

        Directory? directory = await createAppDirectory();
        if (directory == null) {
          Fluttertoast.showToast(msg: 'Failed to create directory');
          return;
        }
        final filePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final file = File(filePath);
        await file.create(recursive: true);

        await response.pipe(file.openWrite());
        log(filePath.toString());
        await OpenFile.open(filePath);

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved to: $filePath")));
      } else {
        throw Exception("Failed to download");
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download failed")));
    }
  }

  // List<dynamic> images;
  // _ImageGalleryState({required this.images});
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.number != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (controller.hasClients) {
          controller.animateToPage(widget.number!, curve: Curves.ease, duration: const Duration(milliseconds: 500));
          currentPage = widget.number ?? 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Images',
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: downloadImage,
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              allowImplicitScrolling: false,
              pageSnapping: true,
              controller: controller,
              itemCount: widget.repeat ? null : widget.images.length,
              physics: widget.images.length > 1 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InteractiveViewer(child: CustomImage(path: "${widget.images[index % widget.images.length]}"));
              },
            ),
            if (widget.images.length > 1)
              Positioned(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    child: Container(
                      height: 70,
                      width: 50,
                      color: Colors.grey.withOpacity(0.5),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (widget.images.length > 1)
              Positioned(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    child: Container(
                      height: 70,
                      width: 50,
                      color: Colors.grey.withOpacity(0.5),
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
