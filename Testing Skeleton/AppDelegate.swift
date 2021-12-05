//
//  AppDelegate.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 30/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        
        if Token.tokenInstance.checkForLogin() {
            print("Login To Main")
            let rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? UIViewController
            
            let navigationController = UINavigationController(rootViewController: rootViewController!)
            navigationController.isNavigationBarHidden = true
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
            
        } else {
            print("Logout to Login")
            let rootViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController
            
            let navigationController = UINavigationController(rootViewController: rootViewController!)
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
        }
            
        return true
    }

    


}

