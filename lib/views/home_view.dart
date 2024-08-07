import 'package:doc_scanner/widgets/custom_row.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

bool _isScanning = false;
List<String> _scannedImagesPaths = [];

class _HomeViewState extends State<HomeView> {
  scanPictures() async {
    try {
      final imagesPath = await CunningDocumentScanner.getPictures(
        noOfPages: 100, // Limit the number of pages to 1
        isGalleryImportAllowed:
            true, // Allow the user to also pick an image from his gallery
      );

      if (imagesPath != null && imagesPath.isNotEmpty) {
        setState(() {
          _scannedImagesPaths.addAll(imagesPath);
        });
      }
    } catch (e) {
      print(e);
    }
    print("image path ----------> $_scannedImagesPaths");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scanned Images",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xfffefae0),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff283618),
      ),
      backgroundColor: Color(0xfffefae0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _scannedImagesPaths.isEmpty
                  ? const Text("No Scanned Images Yet")
                  : ListView.builder(
                      itemCount: _scannedImagesPaths.length,
                      itemBuilder: (context, index) {
                        return CustomRow(
                            index: index,
                            scannedImagesPaths: _scannedImagesPaths);
                      }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      scanPictures();
                    },
                    label: const Text('Scan a picture'),
                    icon: const Icon(Icons.document_scanner_outlined),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xfffefae0),
                        backgroundColor: Color(0xff283618)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
