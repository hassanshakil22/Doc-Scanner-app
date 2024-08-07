import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomRow extends StatefulWidget {
  final int index;
  final List<String> scannedImagesPaths;
  const CustomRow(
      {super.key, required this.index, required this.scannedImagesPaths});

  @override
  State<CustomRow> createState() => _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {
  @override

//save image
  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isDenied) {
        throw "Storage Permission Denied";
      }
    }
  }

  Widget build(BuildContext context) {
    void saveImage(imagePath) async {
      await requestPermissions();
      try {
        if (imagePath != null && imagePath.isNotEmpty) {
          final result = await ImageGallerySaver.saveFile(imagePath);
          print(result);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image saved successfully")));
        }
      } catch (e) {
        print(e);
      }
    }

    {
      return Container(
        color: Color(0xff606c38),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${widget.index + 1} ",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffefae0)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xff283618),
                      title: Row(
                        children: [
                          Text(
                            imageName(widget.scannedImagesPaths[widget.index]),
                            style: TextStyle(
                                fontSize: 20, color: Color(0xfffefae0)),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close))
                        ],
                      ),
                      content: Image.file(
                        File(widget.scannedImagesPaths[widget.index]),
                      ),
                    );
                  }),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(widget.scannedImagesPaths[widget.index]),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 80,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              imageName(widget.scannedImagesPaths[widget.index]),
              style: TextStyle(color: Color(0xfffefae0), fontSize: 15),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  saveImage(widget.scannedImagesPaths[widget.index]);
                },
                icon: const Icon(
                  Icons.save_alt,
                  color: Color(0xfffefae0),
                ))
          ],
        ),
      );
    }
  }

  String imageName(String ImagePath) {
    if (ImagePath.endsWith('.jpg')) {
      return ImagePath.substring(ImagePath.lastIndexOf('/') + 1);
    }
    return "";
  }
}
