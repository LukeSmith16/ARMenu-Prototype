//
//  InitialSetup.swift
//  Pizza BuildAR
//
//  Created by Luke Smith on 15/06/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class InitialSetup {
    private let window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
        setupThemes()
        setupRootController()
    }
    
    private func setupThemes() {
        
    }
    
    private func setupRootController() {
        let rootVC = MenuViewController()
        let rootNavController = UINavigationController(rootViewController: rootVC)
        rootNavController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = rootNavController
        window.makeKeyAndVisible()
    }
}
