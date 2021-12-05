//
//  ViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 30/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Variables
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                print(json)
                let name = (json as! ResponseModel).name
                let email = (json as! ResponseModel).email
                let userToken = (json as! ResponseModel).userToken
                
                self.userDefault.set(name, forKey: "userName")
                
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

