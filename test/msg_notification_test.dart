import 'package:flutter_test/flutter_test.dart';
import 'package:msg_notification/msg_notification.dart';
import 'package:msg_notification/msg_notification_platform_interface.dart';
import 'package:msg_notification/msg_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMsgNotificationPlatform
    with MockPlatformInterfaceMixin
    implements MsgNotificationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MsgNotificationPlatform initialPlatform = MsgNotificationPlatform.instance;

  test('$MethodChannelMsgNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMsgNotification>());
  });

  test('getPlatformVersion', () async {
    MsgNotification msgNotificationPlugin = MsgNotification();
    MockMsgNotificationPlatform fakePlatform = MockMsgNotificationPlatform();
    MsgNotificationPlatform.instance = fakePlatform;

    expect(await msgNotificationPlugin.getPlatformVersion(), '42');
  });
}
