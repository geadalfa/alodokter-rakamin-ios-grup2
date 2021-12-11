//
//  ProfileViewController.swift
//  Alodokter
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userBirth: UILabel!
    @IBOutlet weak var loginBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var stackViewOne: UIStackView!
    @IBOutlet weak var stackViewTwo: UIStackView!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    // Variables
    let userDefault = UserDefaults.standard
    let illustrateImage = IlustrateImage()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if userDefault.object(forKey: "userLoginKey") as? String != nil {
            print("token available")
            userName.text = userDefault.object(forKey: "userName") as? String
            userEmail.text = userDefault.object(forKey: "userEmail") as? String
            userBirth.text = userDefault.object(forKey: "userBirthDate") as? String
            loginBarButtonItem.isEnabled = false
            self.navigationItem.setRightBarButton(nil, animated: true)
        } else {
            print("token not available")
            illustrateImage.getImage(view: view)
            stackViewOne.isHidden = true
            stackViewTwo.isHidden = true
            logOutButton.isHidden = true
        }
        
    }

    

    @IBAction func changeProfile(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChangeProfile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ChangeProfile") as! ChangeProfileViewController
        viewController.hidesBottomBarWhenPushed = true
        viewController.changeProfileDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ChangePassword")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        APIManager.shareInstance.callingLogoutAPI(self)
        userDefault.removeObject(forKey: "userName")
        userDefault.removeObject(forKey: "userEmail")
        userDefault.removeObject(forKey: "userAddress")
        userDefault.removeObject(forKey: "userGender")
        userDefault.removeObject(forKey: "userBirthDate")
        userDefault.removeObject(forKey: TokenKey.userLogin)
        
        print("Keluar Pressed")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationItem.hidesBackButton = true
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func loginBarButtonPressed(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginView = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginView.fromHome = true
        loginView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
}

extension ProfileViewController: ChangeProfileDelegate {
    
    func changeUserProfile(name: String, dateOfBirth: String) {
        userName.text = name
        userBirth.text = dateOfBirth
    }

}
