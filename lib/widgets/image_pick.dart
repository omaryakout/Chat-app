import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  ImagePick({super.key, required this.onPickImage});
  void Function(File pickedImage) onPickImage;
  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          foregroundImage: pickedImageFile != null ? FileImage(pickedImageFile!):null,
        ),
        Row(
          children: [
            const Text('PICK A PHOTO'),
            IconButton(onPressed: pickImage, icon: const Icon(Icons.photo))
          ],
        )
      ],
    );
  }
}
