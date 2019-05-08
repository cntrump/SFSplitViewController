//
//  AppDelegate.swift
//  TestHost
//
//  Created by vvveiii on 2019/5/8.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit
import SFSplitViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootVC = SFSplitViewController(master: UINavigationController(rootViewController: MainViewController()),
                                           detail: UINavigationController(rootViewController: PlaceholderViewController()))
        rootVC.placeholderViewControllerClass = PlaceholderViewController.self

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        return true
    }
}

