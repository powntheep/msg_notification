#include "include/msg_notification/msg_notification_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "msg_notification_plugin.h"

void MsgNotificationPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  msg_notification::MsgNotificationPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
