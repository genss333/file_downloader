import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileService {
  static Future<File?> downloadFileIntoTemp(String url, String fileName) async {
    if (url.isEmpty) {
      debugPrint('URL is empty');
      return null;
    }

    try {
      // Get the temporary directory of the device.
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Create the full path for the file.
      String fullPath = '$tempPath/$fileName';

      // Make the HTTP request to download the file.
      HttpClient client = HttpClient();
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      // Check if the request was successful.
      if (response.statusCode == HttpStatus.ok) {
        // Write the file to the local file system.
        File file = File(fullPath);
        List<int> bytes = await response.fold<List<int>>(
            <int>[],
            (List<int> previous, List<int> element) =>
                previous..addAll(element));
        await file.writeAsBytes(bytes);
        return file;
      } else {
        debugPrint("Failed to download file: ${response.statusCode}'");
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }

  static Future<File?> downloadFileFromBase64(
      {required String base64String, required String fileName}) async {
    if (base64String.isEmpty) {
      debugPrint('Base64 string is empty');
      return null;
    }

    //Validate the base64 string
    final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    if (!base64RegExp.hasMatch(base64String)) {
      debugPrint('Invalid Base64 string');
      return null;
    }

    try {
      // Get the temporary directory of the device.
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Create the full path for the file.
      String fullPath = '$tempPath/$fileName';

      // Write the file to the local file system.
      File file = File(fullPath);
      List<int> bytes = base64Decode(base64String);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }

  static Future<void> downloadFile(String name, String link) async {
    try {
      String fileName = name;

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Downloads');
        if (!await directory.exists()) {
          directory = (await getExternalStorageDirectory())!;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }
      String savePath = '${directory!.path}/$fileName';

      HttpClient client = HttpClient();
      HttpClientRequest request = await client.getUrl(Uri.parse(link));
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        File file = File(savePath);
        List<int> bytes = await response.fold<List<int>>(
            <int>[],
            (List<int> previous, List<int> element) =>
                previous..addAll(element));
        await file.writeAsBytes(bytes);
      } else {
        debugPrint("Failed to download file: ${response.statusCode}'");
      }
    } catch (e) {
      debugPrint('Error downloading file: $e');
    }
  }
}
