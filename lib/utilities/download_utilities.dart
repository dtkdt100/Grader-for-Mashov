import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DownloadUtilities {
  final String link;
  final String fileName;
  final Map<String, String> headers;

  DownloadUtilities({
    required this.link,
    required this.headers,
    required this.fileName,
  });

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static void initNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/icon_grader');
    const iOS = IOSInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin!.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  static Future<dynamic> _onSelectNotification(String? json) async {
    if (true) {
      jsonDecode(json!)['isSuccess'] = 'h';
      final obj = jsonDecode(json);
      if (obj['isSuccess']) {
        OpenFile.open(obj['filePath']);
      }
      else {
        // showDialog(
        //   context: context,
        //   builder: (_) =>
        //       AlertDialog(
        //         title: Text('Error'),
        //         content: Text('${obj['error']}'),
        //       ),
        // );
      }
      //notificationTap = false;
    }
  }

  static Future<void> showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails(
      'Grader-123',
      'Grader',
      'Local Notification for Grader',
      priority: Priority.high,
      importance: Importance.max,
      styleInformation: BigTextStyleInformation(''),
    );
    const iOS = IOSNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin!.show(
        downloadStatus['fileName'].toString().length,
        isSuccess ? 'הורדה הושלמה' : 'שגיאה',
        isSuccess ? 'הקש כדי לפתוח את המסמך: ${downloadStatus['fileName']}' : 'קראת שגיאה בהורדה של המסמך  ${downloadStatus['fileName']}',
        platform,
        payload: json
    );
  }

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> startDownload() async {
    final dir = await _getDownloadDirectory();
    final savePath = path.join(dir!.path, Random().nextInt(1000).toString(), fileName);
    _dio.options.headers = headers;
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
      'fileName': fileName
    };
    try {
      final response = await _dio.download(
        link,
        savePath,
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    }
    return result;
  }

  Future<Directory?> _getDownloadDirectory() async {
    return await DownloadsPathProvider.downloadsDirectory;
  }
}