import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage(BuildContext context, ImageSource source) async {
    try {
      // Handle permissions
      if (source == ImageSource.camera && Platform.isAndroid) {
        var status = await Permission.camera.status;
        if (status.isPermanentlyDenied) {
          if (context.mounted) {
            _showSettingsDialog(context, "Kamera ruxsati kerak", "Sozlamalarga o'tib kamera ruxsatini yoqing.");
          }
          return null;
        }
        if (!status.isGranted) {
          status = await Permission.camera.request();
          if (!status.isGranted) return null;
        }
      } else if (source == ImageSource.gallery) {
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            var status = await Permission.photos.status;
            if (status.isPermanentlyDenied) {
              if (context.mounted) {
                _showSettingsDialog(context, "Galereya ruxsati kerak", "Sozlamalarga o'tib galereya ruxsatini yoqing.");
              }
              return null;
            }
            if (!status.isGranted) {
              status = await Permission.photos.request();
              if (!status.isGranted) return null;
            }
          } else {
            var status = await Permission.storage.status;
            if (status.isPermanentlyDenied) {
              if (context.mounted) {
                _showSettingsDialog(context, "Xotira ruxsati kerak", "Sozlamalarga o'tib xotira ruxsatini yoqing.");
              }
              return null;
            }
            if (!status.isGranted) {
              status = await Permission.storage.request();
              if (!status.isGranted) return null;
            }
          }
        }
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      return pickedFile?.path;
    } catch (e) {
      debugPrint("Image pick error: $e");
      if (context.mounted) {
        if (e.toString().contains("camera_unavailable")) {
          _showErrorDialog(context, "Kamera mavjud emas", "Qurilmangizda kamera topilmadi yoki u ishlatilmoqda.");
        } else {
          _showErrorDialog(context, "Xatolik", "Rasm tanlashda kutilmagan xatolik yuz berdi.");
        }
      }
      return null;
    }
  }

  static void _showSettingsDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Sozlamalar"),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
