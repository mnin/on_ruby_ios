//
//  AppDelegate.swift
//  onruby
//
//  Created by Martin Wilhelmi on 24.09.14.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ZeroPushDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSURLCache.setSharedURLCache(NSURLCache(memoryCapacity: 2 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil))
        Crashlytics.startWithAPIKey(CRASHLYTICS_API_KEY)
        UserGroup.preloadData()

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        ZeroPush.engageWithAPIKey(ZEROPUSH_KEY, delegate: self)
        ZeroPush.shared().registerForRemoteNotifications()
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let apsNotification = userInfo["aps"] as NSDictionary!
        let apsString       = apsNotification["alert"] as String
        let alertView       = UIAlertView(title: nil, message: apsString, delegate: nil, cancelButtonTitle: "OK")

        if application.applicationState == UIApplicationState.Background {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})

                UserGroup.current().reloadJSONFile()
                UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
            })
        } else if application.applicationState == UIApplicationState.Active {
            UserGroup.current().reloadJSONFile()
            alertView.show()
        }

        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        ZeroPush.shared().registerDeviceToken(deviceToken, channel: UserGroup.current().key)
    }
}
