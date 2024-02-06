import Flutter
import UIKit
import UserNotifications
import Foundation
import Intents

func createNewMessageNotification(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Dispatch the task to a background queue
    DispatchQueue.global().async {
        let args = call.arguments as? Dictionary<String, Any>
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        var content = UNMutableNotificationContent()
        content.title = "test 1"
        content.body = (args?["body"] as? String)!
        content.sound = UNNotificationSound.default
        content.userInfo = ["payload": (args?["payload"] as? String)]

        let largeImage = (args?["largeImage"] as? String?) ?? nil;

        do {
          if largeImage != nil {
              let largeImageURL = URL(fileURLWithPath: largeImage!)
              let attachment = try! UNNotificationAttachment.init(identifier: UUID().uuidString, url: largeImageURL, options: .none)
              content.attachments = [attachment]
          }
        } catch {
            print(error.localizedDescription as Any)
        }

        print("sending notification")
        
        let pngURL = URL(fileURLWithPath: (args?["url"] as? String)!)
        do {
            let data = try Data(contentsOf: pngURL)
            let handle = INPersonHandle(value: (args?["sender"] as? String)!, type: .unknown)
            let avatar = INImage.init(imageData: data)
            let sender = INPerson(personHandle: handle,
                                  nameComponents: nil,
                                  displayName: (args?["displayName"] as? String)!,
                                  image: avatar,
                                  contactIdentifier: nil,
                                  customIdentifier: nil)
            
            let intent = INSendMessageIntent(recipients: nil,
                                             outgoingMessageType: .outgoingMessageText,
                                             content: (args?["body"] as? String)!,
                                             speakableGroupName: INSpeakableString(spokenPhrase: (args?["sender"] as? String)!),
                                             conversationIdentifier: (args?["conversationId"] as? String)!,
                                             serviceName: nil,
                                             sender: sender,
                                             attachments: nil)
            
            let interaction = INInteraction(intent: intent, response: nil)
            interaction.direction = .incoming
            interaction.donate(completion: nil)
            
            do {
                content = try content.updating(from: intent) as! UNMutableNotificationContent
            } catch let error {
                print(error.localizedDescription as Any)
            }
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        } catch {
            print(error.localizedDescription as Any)
        }
    }
}

public class MsgNotificationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "msg_notification", binaryMessenger: registrar.messenger())
    let instance = MsgNotificationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "requestNotificationPermission":
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if granted {
              print("Notification permission granted")
              result(true)
          } else {
              print("Notification permission denied")
              result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
          }
      }
    case "createNewMessageNotification":
        createNewMessageNotification(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
