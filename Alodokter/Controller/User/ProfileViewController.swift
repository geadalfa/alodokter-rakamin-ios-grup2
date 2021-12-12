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
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    var userID: String = ""
    var userToken: String = ""
    
    let illustrationImage = UIImage(named: "loginImage.png")
    
    let myImageView:UIImageView = UIImageView()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefault.object(forKey: "userLoginKey") as? String != nil {
            print("token available")
            userName.text = userDefault.object(forKey: "userName") as? String
            userEmail.text = userDefault.object(forKey: "userEmail") as? String
            userBirth.text = userDefault.object(forKey: "userBirthDate") as? String
        } else {
            print("token not available")
            getImage()
            stackViewOne.isHidden = true
            stackViewTwo.isHidden = true
            logOutButton.isHidden = true
        }
    }
    
    
    func getImage() {
        
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myImageView.frame.size.width = 300
        myImageView.frame.size.height = 300
        myImageView.image = illustrationImage
        
        
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Harap login dahulu untuk menikmati fitur ini"

        //imageview constraint
        view.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        //label constraint
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    

    @IBAction func changeProfile(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChangeProfile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ChangeProfile") as! ChangeProfileViewController
        viewController.hidesBottomBarWhenPushed = true
        viewController.changeProfileDelegate = self
        viewController.userId = userID
        viewController.userToken = userToken
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
        loginView.userTokenAndIdDelegate = self
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
}

extension ProfileViewController: ChangeProfileDelegate {
    
    func changeUserProfile(name: String, dateOfBirth: String) {
        userName.text = name
        userBirth.text = dateOfBirth
    }

}

extension ProfileViewController: UserTokenAndIdDelegate {
    
    func userTokenAndId(userToken: String, userID: String) {
        self.userToken = userToken
        self.userID = userID
        print("User tokennya adalah: \(userToken) dan user ID nya adalah: \(userID)")
    }
    
    func loginHidden(login: Bool) {
        loginBarButtonItem.isEnabled = login
        navigationItem.setRightBarButton(nil, animated: true)
        stackViewOne.isHidden = login
        stackViewTwo.isHidden = login
        logOutButton.isHidden = login
        myImageView.isHidden = !login
        label.isHidden = !login
    }
    
    
}
