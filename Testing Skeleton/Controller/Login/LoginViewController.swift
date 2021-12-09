//
//  ViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 30/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    // Variables
    let userDefault = UserDefaults.standard
    var fromHome: Bool = false
    let udService = UserDefaultService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        if (fromHome) {
            skipButton.isEnabled = true
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !udService.isFirstLaunched {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
            let welcomeVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.present(welcomeVC, animated:true, completion:nil)
            return
        }
    }
    

    @IBAction func skipPressed(_ sender: UIBarButtonItem) {
        print("Skip Pressed")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Bt pressed")
        guard let safeEmail = emailTextField.text else { return }
        guard let safePassword = passwordTextField.text else { return }
        let loginModel = LoginModel(login: safeEmail, password: safePassword)
        APIManager.shareInstance.callingLoginAPI(login: loginModel) { (result) in
            switch result {
            case .success(let json):
//                print(json)
                let userName = (json as! LoginResponseModel).name
                let userEmail = (json as! LoginResponseModel).email
                let userAddress = (json as! LoginResponseModel).address
                let userGender = (json as! LoginResponseModel).gender
                let userBirthDate = (json as! LoginResponseModel).birthDate
                let userToken = (json as! LoginResponseModel).userToken
                let userID = (json as! LoginResponseModel).objectID
                
                self.userDefault.set(userName, forKey: "userName")
                self.userDefault.set(userEmail, forKey: "userEmail")
                self.userDefault.set(userAddress, forKey: "userAddress")
                self.userDefault.set(userGender, forKey: "userGender")
                self.userDefault.set(userBirthDate, forKey: "userBirthDate")
                self.userDefault.set(userID, forKey: "userID")
                
                
                Token.tokenInstance.saveToken(token: userToken)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
                
            case .failure(let error):
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "Terjadi Kesalahan", message:
                                                            "Mohon Periksa Kembali Data dan Jaringan Internet Anda", preferredStyle: .alert)
                let action = UIAlertAction(title: "Tutup", style: .default)
                
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("BT prssed")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

