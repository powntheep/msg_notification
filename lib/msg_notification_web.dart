// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

import 'msg_notification_platform_interface.dart';

/// A web implementation of the MsgNotificationPlatform of the MsgNotification plugin.
class MsgNotificationWeb extends MsgNotificationPlatform {
  /// Constructs a MsgNotificationWeb
  MsgNotificationWeb();

  static void registerWith(Registrar registrar) {
    MsgNotificationPlatform.instance = MsgNotificationWeb();
  }

  @override
  Future<void> createNewMessageNotification(
      {required String avatarUrl,
      required String displayName,
      required String sender,
      required String conversationId,
      required String message,
      String? largeImage,
      required String data}) async {
    if (isForeground) {
      return;
    }
    await requestNotificationPermission();
    final notification = Notification(
      displayName,
      NotificationOptions(
        body: message,
        data: data.toJS,
        image: largeImage ?? '',
        icon: avatarUrl,
      ),
    );
    notification.onclick = (Event event) {
      print('notification clicked: $event');
      // onClickNotification.add(data);
    }.toJS;
  }

  @override
  Future<void> requestNotificationPermission() async {
    if (isNotificationPermissionRequested) {
      return;
    }
    isNotificationPermissionRequested = true;
    final result = await Notification.requestPermission().toDart;

    switch (result.toString()) {
      case 'granted':
        isNotificationPermissionGranted = true;
        break;
      default:
        isNotificationPermissionGranted = false;
        break;
    }
  }
}
