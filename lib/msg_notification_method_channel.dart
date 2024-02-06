import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

import 'msg_notification_platform_interface.dart';

/// An implementation of [MsgNotificationPlatform] that uses method channels.
class MethodChannelMsgNotification extends MsgNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('msg_notification');

  late WindowsNotification _winNotifyPlugin;

  MethodChannelMsgNotification() {
    if (TargetPlatform.windows == defaultTargetPlatform) {
      _winNotifyPlugin = WindowsNotification(applicationId: r"Soda");
      _winNotifyPlugin.initNotificationCallBack((details) {
        print(details);
        // final proxyMessage = ProxyMessage.fromBuffer(
        //     base64Decode(details.message.payload['payload']));

        // onClickNotification.add(details.message.payload['payload']);
      });
    }
    if (TargetPlatform.android == defaultTargetPlatform) {
      AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          null,
          [
            NotificationChannel(
                channelGroupKey: 'basic_channel_group',
                channelKey: 'basic_channel',
                channelName: 'Basic notifications',
                channelDescription: 'Notification channel for basic tests',
                defaultColor: const Color(0xFF9D50DD),
                ledColor: Colors.white)
          ],
          // Channel groups are only visual and are not required
          channelGroups: [
            NotificationChannelGroup(
                channelGroupKey: 'basic_channel_group',
                channelGroupName: 'Basic group')
          ],
          debug: true);

      AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
      );
    }
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'notificationDidReceive':
          print(call);
          // final proxyMessage =
          //     ProxyMessage.fromBuffer(base64Decode(call.arguments['payload']));
          // print(proxyMessage);
          // onClickNotification.add(proxyMessage);
          break;
        default:
      }
    });
  }

  String? _tempDir;
  Future<String> getTempDir() async {
    _tempDir ??= (await getApplicationDocumentsDirectory()).path;
    return _tempDir!;
  }

  Future<String> downloadTempImage({required String url}) async {
    final fileName = '${url.hashCode}.png';
    final baseDownloadDir = await getTempDir();
    final filePath = '$baseDownloadDir/temp_images/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    final task = DownloadTask(
      url: url,
      directory: 'temp_images',
      filename: fileName,
      retries: 5,
    );
    await FileDownloader().download(task);

    return filePath;
  }

  @override
  Future<void> createNewMessageNotification({
    required String avatarUrl,
    required String displayName,
    required String sender,
    required String conversationId,
    required String message,
    required String data,
    String? largeImage,
  }) async {
    if (isForeground) {
      return;
    }
    await requestNotificationPermission();
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        final url = await downloadTempImage(url: avatarUrl);
        NotificationMessage notificationMessage =
            NotificationMessage.fromPluginTemplate(
                conversationId, displayName, message,
                largeImage: largeImage, image: url, payload: {"payload": data});
        _winNotifyPlugin.showNotificationPluginTemplate(notificationMessage);
        break;
      case TargetPlatform.android:
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: conversationId.hashCode,
                channelKey: 'basic_channel',
                title: displayName,
                body: message,
                displayOnForeground: true,
                category: NotificationCategory.Message,
                largeIcon: avatarUrl,
                roundedBigPicture: false,
                roundedLargeIcon: true,
                backgroundColor: Colors.deepPurpleAccent,
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: largeImage,
                payload: {}));
        break;
      default:
        final url = await downloadTempImage(url: avatarUrl);
        final largeImageUrl = largeImage != null
            ? await downloadTempImage(url: largeImage)
            : null;
        print('createNewMessageNotification: $url, $largeImageUrl');
        methodChannel.invokeMethod<String>('createNewMessageNotification', {
          "url": url,
          "body": message,
          "displayName": displayName,
          "sender": sender,
          "conversationId": conversationId,
          "payload": data,
          "largeImage": largeImageUrl
        });
    }
  }

  @override
  Future<void> requestNotificationPermission() async {
    if (isNotificationPermissionRequested) {
      return;
    }
    isNotificationPermissionRequested = true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        break;
      case TargetPlatform.android:
        final status = await Permission.notification.request();
        isNotificationPermissionGranted = status.isGranted;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        isNotificationPermissionGranted = (await methodChannel
                .invokeMethod<bool>('requestNotificationPermission')) ??
            false;
        break;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        break;
    }
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('receivedAction: $receivedAction');
  }
}
