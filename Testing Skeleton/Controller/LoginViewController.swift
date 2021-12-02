//
//  ViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 30/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func skipPressed(_ sender: UIBarButtonItem) {
        print("Skip Pressed")
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Bt pressed")
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("BT prssed")
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
}

