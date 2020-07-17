//
//  AppDelegate.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.main.bounds)
//    let coreData = CoreDataModel()
    let viewController = HomeViewController()
//    viewController.insert(withModel: coreData)
    window?.rootViewController = UINavigationController(rootViewController: viewController)
    window?.makeKeyAndVisible()
    return true
  }
}
