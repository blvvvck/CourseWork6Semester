//
//  UserNotificationsManager.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 02/01/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationsManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Nested Properties

        static let notificationTitle = "Отлично"
        static let notificationBody = "Вы катаетесь уже час!"
        static let badgeCount: NSNumber = 1
        static let categoryIdentifier = "UserActionsIdentifier"
        static let localNotificationIdentifier = "LocalNotificationIdentifier"
    }

    static let shared = UserNotificationsManager()

    let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        self.notificationCenter.delegate = self
    }

    func userRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        self.notificationCenter.requestAuthorization(options: options, completionHandler: { isAllow, error in
            Log.i("isAllow: \(isAllow)")
            Log.i("error: \(String(describing: error))")
        })
    }

    func scheduleNotification(inSeconds seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = Constants.notificationTitle
        content.body = Constants.notificationBody
        content.sound = UNNotificationSound.default
        content.badge = Constants.badgeCount
        content.categoryIdentifier = Constants.categoryIdentifier

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: Constants.localNotificationIdentifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    func removeAllPendingNotificationRequests() {
        self.notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
