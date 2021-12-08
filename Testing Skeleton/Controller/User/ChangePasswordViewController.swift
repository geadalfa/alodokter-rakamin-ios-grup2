//
//  ChangePasswordViewController.swift
//  Testing Skeleton
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
    }
    

}
