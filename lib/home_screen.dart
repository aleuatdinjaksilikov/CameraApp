import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        _image = imagePermanent;
      });
    }on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker App')),
      body: Center(
        child: Column(
          children: [
            _image != null
                ? Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Image.network('https://picsum.photos/250?image=9'),
            SizedBox(height: 10),
            customButton(
              title: 'Get from Gallery',
              icon: Icons.photo,
              onPressed: () => getImage(ImageSource.gallery),
            ),
            SizedBox(height: 10),
            customButton(
              title: 'Get from Camera',
              icon: Icons.camera,
              onPressed: () => getImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Widget customButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(children: [Icon(icon), SizedBox(width: 5), Text(title)]),
      ),
    );
  }
}
