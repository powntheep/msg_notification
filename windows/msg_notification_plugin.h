#ifndef FLUTTER_PLUGIN_MSG_NOTIFICATION_PLUGIN_H_
#define FLUTTER_PLUGIN_MSG_NOTIFICATION_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace msg_notification {

class MsgNotificationPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MsgNotificationPlugin();

  virtual ~MsgNotificationPlugin();

  // Disallow copy and assign.
  MsgNotificationPlugin(const MsgNotificationPlugin&) = delete;
  MsgNotificationPlugin& operator=(const MsgNotificationPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace msg_notification

#endif  // FLUTTER_PLUGIN_MSG_NOTIFICATION_PLUGIN_H_
