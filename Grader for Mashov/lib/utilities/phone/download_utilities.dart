import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

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
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const android = AndroidInitializationSettings('@mipmap/icon_grader');
      const initSettings = InitializationSettings(android: android);

      flutterLocalNotificationsPlugin!
          .initialize(
          initSettings, onDidReceiveNotificationResponse: _onSelectNotification);
    }
  }

  static Future<dynamic> _onSelectNotification(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      final obj = jsonDecode(payload);

      if (obj['isSuccess'] == true && obj['filePath'] != null) {
        await OpenFile.open(obj['filePath']);
      }
    }
  }

  static AndroidNotificationDetails android = const AndroidNotificationDetails(
    'Grader-123',
    'Grader',
    channelDescription: 'Local Notification for Grader',
    priority: Priority.defaultPriority,
    importance: Importance.defaultImportance,
    styleInformation: BigTextStyleInformation(''),
  );

  static Future<void> showNotification(
      Map<String, dynamic> downloadStatus) async {
    if (Platform.isAndroid) {
      NotificationDetails platform = NotificationDetails(android: android);
      final json = jsonEncode(downloadStatus);
      final isSuccess = downloadStatus['isSuccess'];

      await flutterLocalNotificationsPlugin!.show(
          downloadStatus['fileName']
              .toString()
              .length,
          isSuccess ? 'הורדה הושלמה' : 'שגיאה',
          isSuccess
              ? 'הקש כדי לפתוח את המסמך: ${downloadStatus['fileName']}'
              : 'קראת שגיאה בהורדה של המסמך  ${downloadStatus['fileName']}',
          platform,
          payload: json);
    }
    if (downloadStatus['isSuccess']) OpenFile.open(downloadStatus['filePath']);
  }

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> startDownload() async {
    final dir = await _getDownloadDirectory();
    final savePath =
        path.join(dir!.path, Random().nextInt(1000).toString(), fileName);
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
    return await getTemporaryDirectory();
  }
}
