//
//  ViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 30/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func skipPressed(_ sender: UIBarButtonItem) {
        print("Skip Pressed")
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Bt pressed")
        guard let safeEmail = emailTextField.text else { return }
        guard let safePassword = passwordTextField.text else { return }
        let loginModel = LoginModel(login: safeEmail, password: safePassword)
        APIManager.shareInstance.callingLoginAPI(login: loginModel) { (result) in
            switch result {
            case .success(let json):
                print(json)
                let name = (json as! ResponseModel).name
                let email = (json as! ResponseModel).email
//                print(json as AnyObject)
//                let email = (json as AnyObject).value(forKey: "email") as! String
//                let name = (json as AnyObject).value(forKey: "name") as! String
//                let loginResponseModel = LoginResponseModel(name: name, email: email)
//                print(loginResponseModel)
                self.performSegue(withIdentifier: "goToHome", sender: self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("BT prssed")
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
}

