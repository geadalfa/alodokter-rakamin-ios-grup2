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
    
    var userId: String = ""
    var userToken: String = ""
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newPassword.isSecureTextEntry = true
        confirmationPassword.isSecureTextEntry = true
        
        print("apakah kosong userID: \(userId), alternatif: \(userDefault.object(forKey: "userID") as! String)")
        print("apakah kosong userToken: \(userToken), alternatif: \(userDefault.object(forKey: "userLoginKey") as! String)")
        
        if userId == "" {
            userId = userDefault.object(forKey: "userID") as! String
        }
        
        if userToken == "" {
            userToken = userDefault.object(forKey: "userLoginKey") as! String
        }
        
        
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        print("Save Profile Pressed")
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        guard let safePassword = self.newPassword.text else { return }
        
        updateData(password: safePassword)

    }
    
    func updateData(password: String) {
        let url = "https://unitedpaper.backendless.app/api/users/\(userId)"
        
        // Prepare a URL
        let urlString = URL(string: url)
        guard let requestURL = urlString else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(userToken)", forHTTPHeaderField: "user-token")
        
        // Add data to the model
        let uploadDataModel = UploadDataPassword(password: password)
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // Set HTTP Request Body
        request.httpBody = jsonData
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if error != nil {
                print("Error took place \(error!)")
                return
            }
            
            // Convert HTTP response data to a string
            if let safeData = data {
                let dataString = String(data: safeData, encoding: .utf8)
                print("Response data string: \(dataString!)")
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    
                    
                    let alertController = UIAlertController(title: "Berhasil", message:
                                                                "Password telah dirubah", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Tutup", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
        }
        
        task.resume()
                
        
    }

}
