//
//  ProfileViewController.swift
//  Testing Skeleton
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Variables
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeProfile(_ sender: Any) {
        let profile = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        
        guard profile.instantiateViewController(withIdentifier: "changeProfile") is
                ChangeProfileViewController else {
                    print("couldn't find the view controller")
                    return
                }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let password = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        
        guard password.instantiateViewController(withIdentifier: "changePassword") is
                ChangePasswordViewController else {
                    print("couldn't find the view controller")
                    return
                }
    }
    
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        APIManager.shareInstance.callingLogoutAPI(self)
        userDefault.removeObject(forKey: "userName")
        print("Keluar Pressed")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        viewController.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

