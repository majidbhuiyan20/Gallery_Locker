import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/home_controller.dart';
import 'folder_contents_view.dart';
import '../const/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: const Text("Gallery Locker"),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: controller.folders
                .map((folder) => _buildCard(
              icon: folder.icon,
              label: folder.name,
              folderPath: folder.path,
              context: context,
              onTap: () async {
                print("Tapped on folder: ${folder.name} with path: ${folder.path}");
                await PreferenceService.saveLastOpenedFolder(folder.path);
                Get.to(() => FolderContentsView(folderName: folder.name, folderPath: folder.path));
              },
            ))
                .toList(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context);
        },
        backgroundColor: AppColors.appBarColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    controller.folderNameController.clear();
    Get.defaultDialog(
      title: "Create New Folder",
      content: TextField(
        controller: controller.folderNameController,
        decoration: const InputDecoration(hintText: "Folder Name"),
      ),
      textCancel: "Cancel",
      textConfirm: "Done",
      onConfirm: () {
        if (controller.folderNameController.text.isNotEmpty) {
          controller.addFolder(controller.folderNameController.text);
          Get.back();
        }
      },
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required String folderPath,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        // Handle rename action
                        _showRenameFolderDialog(context, folderPath, label);
                      } else if (value == 'delete') {
                        // Handle delete action
                        controller.deleteFolder(folderPath);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Rename', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice.toLowerCase(),
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    icon: Icon(Icons.more_vert, color: AppColors.appBarColor),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 50.0, color: AppColors.appBarColor),
                      const SizedBox(height: 10.0),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameFolderDialog(BuildContext context, String oldPath, String oldName) {
    controller.folderNameController.text = oldName;
    Get.defaultDialog(
      title: "Rename Folder",
      content: TextField(
        controller: controller.folderNameController,
        decoration: const InputDecoration(hintText: "New Folder Name"),
      ),
      textCancel: "Cancel",
      textConfirm: "Rename",
      onConfirm: () {
        if (controller.folderNameController.text.isNotEmpty) {
          controller.renameFolder(oldPath, controller.folderNameController.text);
          Get.back();
        }
      },
    );
  }
}

class PreferenceService {
  static Future<void> saveLastOpenedFolder(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastOpenedFolder', path);
  }

  static Future<String?> getLastOpenedFolder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastOpenedFolder');
  }
}
