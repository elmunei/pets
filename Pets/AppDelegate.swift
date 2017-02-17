    //
//  AppDelegate.swift
//  Pets
//
//  Created by Elvis Tapfumanei on 2017/02/13.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var container : UIView!
    
    
    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    
    }

    
    
    func showActivityIndicator() {
        if let window = window {
            container = UIView()
            container.frame = window.frame
            container.center = window.center
            container.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
            actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            actInd.hidesWhenStopped = true
            actInd.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
            
            container.addSubview(actInd)
            window.addSubview(container)
            
            actInd.startAnimating()
        
        }
    
    }
    
    
    func dismissActivityIndicator() {
    
        if let _ = window {
            container.removeFromSuperview()
        
        }
    
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Firebase
            FIRApp.configure()
        //Facebook
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
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
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

}

