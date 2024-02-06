import 'package:flutter/scheduler.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'msg_notification_method_channel.dart';

abstract class MsgNotificationPlatform extends PlatformInterface {
  /// Constructs a MsgNotificationPlatform.
  MsgNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static MsgNotificationPlatform _instance = MethodChannelMsgNotification();

  /// The default instance of [MsgNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelMsgNotification].
  static MsgNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MsgNotificationPlatform] when
  /// they register themselves.
  static set instance(MsgNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  bool isNotificationPermissionGranted = false;
  bool isNotificationPermissionRequested = false;

  bool get isForeground => false;

  Future<void> createNewMessageNotification({
    required String avatarUrl,
    required String displayName,
    required String sender,
    required String conversationId,
    required String message,
    required String data,
    String? largeImage,
  });

  Future<void> requestNotificationPermission();
}

extension AppLifecycleStateExt on AppLifecycleState {
  bool get isResumed => this == AppLifecycleState.resumed;
  bool get isPaused => this == AppLifecycleState.paused;
  bool get isInactive => this == AppLifecycleState.inactive;
  bool get isDetached => this == AppLifecycleState.detached;
  bool get isBackground => !isResumed;
}
