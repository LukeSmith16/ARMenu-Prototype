//
//  AppDelegate.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 15/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApp()
        return true
    }
    
    private func setupApp() {
        window =  UIWindow(frame: UIScreen.main.bounds)
        _ = InitialSetup(window: window!)
    }
}

