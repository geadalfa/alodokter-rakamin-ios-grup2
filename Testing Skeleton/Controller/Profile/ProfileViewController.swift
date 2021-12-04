//
//  ProfileViewController.swift
//  Testing Skeleton
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

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
    
    

}
