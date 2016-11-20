//
//  AppDelegate.swift
//  day
//
//  Created by Tony Dinh on 2016-11-03.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var rootController = UINavigationController()
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        applyAppearanceProxies()
        requestAppPermissions()

        let mainView = SettingsController()
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        rootController.navigationBar.titleTextAttributes = titleTextAttributes
        rootController.pushViewController(mainView, animated: false)

        window!.rootViewController = rootController
        window!.makeKeyAndVisible()

        if WCSession.isSupported() {
            session = WCSession.default()
        }

        return true
    }

    private func applyAppearanceProxies() {
        let primaryColor = Utils.color().UIColorFrom(hex: 0xCC6D65)
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = primaryColor
    }

    private func requestAppPermissions() {
        let eventManager = EventManager.sharedInstance
        if !eventManager.accessGranted {
            eventManager.requestAccess()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(["hello": "world"])
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Called when the activation session finishes.
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Called when the session prepares to stop communicating with the current Apple Watch.
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Called after data from the previous session has been delivered and communication with the Apple Watch has ended.
    }
}

