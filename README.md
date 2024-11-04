# File Downloader

## Setup
- path_provider : https://pub.dev/packages/path_provider

## Example
```dart
import 'package:flutter/material.dart';
import 'package:your_package/download_file_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileDownloadPage(),
    );
  }
}

class FileDownloadPage extends StatefulWidget {
  @override
  _FileDownloadPageState createState() => _FileDownloadPageState();
}

class _FileDownloadPageState extends State<FileDownloadPage> {
  String status = 'Idle';

  Future<void> downloadFromUrl() async {
    setState(() => status = 'Downloading file...');
    final file = await DownloadFileService.downloadFileIntoTemp(
      'https://example.com/file.pdf',
      'file.pdf',
    );
    setState(() => status = file != null ? 'File downloaded successfully' : 'Download failed');
  }

  Future<void> downloadFromBase64() async {
    const base64String = '...'; // Your base64-encoded string here
    setState(() => status = 'Decoding Base64 and saving file...');
    final file = await DownloadFileService.downloadFileFromBase64(
      base64String: base64String,
      fileName: 'decoded_file.pdf',
    );
    setState(() => status = file != null ? 'File decoded and saved' : 'Decoding failed');
  }

  Future<void> downloadToSpecificPath() async {
    setState(() => status = 'Downloading file to specific path...');
    await DownloadFileService.downloadFile(
      'my_file.pdf',
      'https://example.com/file.pdf',
    );
    setState(() => status = 'Download to specific path complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Download Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status),
            ElevatedButton(
              onPressed: downloadFromUrl,
              child: Text('Download from URL (Temp)'),
            ),
            ElevatedButton(
              onPressed: downloadFromBase64,
              child: Text('Download from Base64 (Temp)'),
            ),
            ElevatedButton(
              onPressed: downloadToSpecificPath,
              child: Text('Download to Specific Path'),
            ),
          ],
        ),
      ),
    );
  }
}

```