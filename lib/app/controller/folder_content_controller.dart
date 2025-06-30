import 'dart:io';
import 'package:get/get.dart';

class FolderContentsController extends GetxController {
  final String folderPath;
  var files = <FileSystemEntity>[].obs;

  FolderContentsController(this.folderPath);

  @override
  void onInit() {
    super.onInit();
    loadFiles();
  }

  void loadFiles() async {
    final directory = Directory(folderPath);
    if (await directory.exists()) {
      final allFiles = directory.listSync();
      files.value = allFiles.where((item) =>
      item.path.toLowerCase().endsWith('.jpg') ||
          item.path.toLowerCase().endsWith('.jpeg') ||
          item.path.toLowerCase().endsWith('.png') ||
          item.path.toLowerCase().endsWith('.mp4') ||
          item.path.toLowerCase().endsWith('.mov') ||
          item.path.toLowerCase().endsWith('.avi')).toList();
    }
  }
}
