//
//  RegisterViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let safeName = nameTextField.text else { return }
        guard let safeEmail = emailTextField.text else { return }
        guard let safePassword = passwordTextField.text else { return }
        
        let register = RegisterModel(name: safeName, email: safeEmail, password: safePassword)
        APIManager.shareInstance.callingRegisterAPI(register: register)
        
    }
    
}
