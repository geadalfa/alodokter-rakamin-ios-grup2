//
//  ChangePasswordViewController.swift
//  Alodokter
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmationPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newPassword.isSecureTextEntry = true
        confirmationPassword.isSecureTextEntry = true
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        print("Change Password Pressed")
        guard let safePassword = newPassword.text else { return }
        let userPassword = UserPassword(password: safePassword)
        APIManager.shareInstance.callingUpdateUserAPI(userPassword: userPassword) { (result) in
            switch result {
            case .success(let json):
                print(json)
                
                let alertController = UIAlertController(title: "Berhasil", message:
                                                            "Password Berhasil Diubah", preferredStyle: .alert)
                let action = UIAlertAction(title: "Tutup", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                
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
    

}
