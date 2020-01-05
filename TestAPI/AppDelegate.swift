//
//  AppDelegate.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let viewController:ViewController = ViewController()
        let navigation:UINavigationController = UINavigationController(rootViewController: viewController)
        
        self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
        return true
    }
    


}

