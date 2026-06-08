import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  File? _imageFile;
  bool _isCameraInitialized = false;
  List<CameraDescription>? cameras;
  int _cameraId = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(_cameraId);
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![cameraIndex], ResolutionPreset.high, enableAudio: false);
    await _controller.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      XFile picture = await _controller.takePicture();
      setState(() {
        _imageFile = File(picture.path);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _switchCamera() async {
    if (cameras!.length > 1) {
      _cameraId = _cameraId == 0 ? 1 : 0;
      await _initializeCamera(_cameraId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _imageFile == null
                    ? Stack(
                        children: [
                          CameraPreview(_controller),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                              child: IconButton(
                                style: IconButton.styleFrom(backgroundColor: Colors.white),
                                onPressed: () {
                                  _switchCamera();
                                },
                                icon: Icon(Icons.cameraswitch_outlined, size: 24, color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Image.file(_imageFile!),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Spacer(),
                      _imageFile != null
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          : const SizedBox(),
                      const Spacer(flex: 3),
                      _imageFile == null
                          ? GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const Spacer(flex: 3),
                      _imageFile != null
                          ? IconButton(
                              icon: const Icon(Icons.done, color: Colors.white, size: 30),
                              onPressed: () {
                                Navigator.pop(context, _imageFile);
                              },
                            )
                          : const SizedBox(),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
