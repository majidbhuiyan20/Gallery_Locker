import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/media_folder.dart';

class HomeController extends GetxController {
  var folders = <MediaFolder>[].obs;
  final folderNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize with default folders
    folders.addAll([
      MediaFolder(name: 'image', icon: Icons.image, path: '/image'),
      MediaFolder(name: 'video', icon: Icons.video_library, path: '/video'),
    ]);
  }

  void addFolder(String name) {
    final path = '/${name.toLowerCase().replaceAll(' ', '_')}';
    folders.add(MediaFolder(
      name: name,
      icon: Icons.folder,
      path: path,
    ));
  }

  void deleteFolder(String path) {
    folders.removeWhere((folder) => folder.path == path);
    Get.snackbar("Deleted", "Folder has been removed", snackPosition: SnackPosition.BOTTOM);
  }

  void renameFolder(String oldPath, String newName) {
    final newPath = '/${newName.toLowerCase().replaceAll(' ', '_')}';
    final index = folders.indexWhere((folder) => folder.path == oldPath);
    if (index != -1) {
      folders[index] = MediaFolder(
        name: newName,
        icon: folders[index].icon,
        path: newPath,
      );
      folders.refresh();  // Notify GetX that list has changed
      Get.snackbar("Renamed", "Folder renamed to $newName", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
