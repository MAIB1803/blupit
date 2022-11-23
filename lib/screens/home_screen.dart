import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:blupit/screens/edit_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(
            Icons.camera_alt,
            size: 30,
          ),
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(
              preferredCameraDevice: CameraDevice.rear,
              source: ImageSource.camera,
            );
            if (file != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditImageScreen(
                    selectedImage: file.path,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
