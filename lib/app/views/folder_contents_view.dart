import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../const/app_colors.dart';

class FolderContentsView extends StatefulWidget {
  final String folderName;
  final String folderPath;

  const FolderContentsView({
    super.key,
    required this.folderName,
    required this.folderPath,
  });

  @override
  State<FolderContentsView> createState() => _FolderContentsViewState();
}

class _FolderContentsViewState extends State<FolderContentsView> {
  final RxList<FileSystemEntity> files = <FileSystemEntity>[].obs;

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  void loadFiles() {
    final dir = Directory(widget.folderPath);
    if (dir.existsSync()) {
      files.value = dir.listSync().where((item) {
        final path = item.path.toLowerCase();
        return path.endsWith('.jpg') ||
            path.endsWith('.jpeg') ||
            path.endsWith('.png') ||
            path.endsWith('.mp4') ||
            path.endsWith('.mov') ||
            path.endsWith('.avi');
      }).toList();
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await PickFromGallery.pickImages();
      if (pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          final targetPath = '${widget.folderPath}${Platform.pathSeparator}$fileName';
          final targetFile = File(targetPath);
          await file.copy(targetFile.path);
        }
        loadFiles(); // Refresh the list after copying
        Get.snackbar('Success', 'Images added successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Obx(() {
        if (files.isEmpty) {
          return const Center(child: Text('There is no image and video'));
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final path = file.path.toLowerCase();
            final isImage = path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png');
            final isVideo = path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.avi');

            if (isImage) {
              return Image.file(File(file.path), fit: BoxFit.cover);
            } else if (isVideo) {
              return GestureDetector(
                onTap: () {
                  Get.snackbar('Video', 'Tapped video file'); // Replace with video player later
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(color: Colors.black26),
                    const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                  ],
                ),
              );
            } else {
              return Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.insert_drive_file)),
              );
            }
          },
        );
      }),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: AppColors.appBarColor,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.redAccent,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.create_new_folder),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Create Sub Folder',
            onTap: () => Get.snackbar('Sub Folder', 'Create Sub Folder tapped'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_photo_alternate),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Add Images',
            onTap: _pickImages,
          ),
        ],
      ),
    );
  }
}

class PickFromGallery {
  static Future<List<File>> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();
    }
    return [];
  }
}
