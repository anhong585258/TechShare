//
//  AppDelegate.swift
//  CircleLoading
//
//  Created by JHunter on 2019/5/23.
//  Copyright © 2019 com.jhunter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tests: [TestWindow] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let w1 = TestWindow.create(name: "A", color: .blue, delegate: self)
//        let w2 = TestWindow.create(name: "B", color: .white, delegate: self)
//        let w3 = TestWindow.create(name: "C", color: .red, delegate: self)
//        tests = [w1, w2, w3]
//        w1.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
//        w2.frame = CGRect(x: 50, y: 200, width: 200, height: 200)
//        w3.frame = CGRect(x: 200, y: 50, width: 200, height: 200)
//        w1.windowLevel = UIWindow.Level(100.0)
//        w2.windowLevel = UIWindow.Level(200.0)
//        w3.windowLevel = UIWindow.Level(300.0)
//
//        makeKeyWindow(index: 0)
        
        return true
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

    private func makeKeyWindow(index: Int) {
        for i in 0..<3 {
            let w = tests[i]
            if i == index {
                w.makeKeyAndVisible()
            } else {
                w.isHidden = false
            }
        }
    }

}

extension AppDelegate: TestDelegate {
    func wantSwitch(senderName: String) {
        switch senderName {
        case "A":
            makeKeyWindow(index: 0)
        case "B":
            makeKeyWindow(index: 1)
        case "C":
            makeKeyWindow(index: 2)
        default:
            return
        }
    }
}
