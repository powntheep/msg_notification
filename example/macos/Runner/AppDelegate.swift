import Cocoa
import FlutterMacOS
import UserNotifications
import Foundation
import Intents

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  let un = UNUserNotificationCenter.current()

  override func applicationDidFinishLaunching(_ notification: Notification) {
      UNUserNotificationCenter.current().delegate = self
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent response: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.sound, .list, .badge])
    }
    
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       print("user tap notification")
       completionHandler()
   }
}