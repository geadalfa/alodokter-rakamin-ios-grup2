//
//  ChangeProfileViewController.swift
//  Alodokter
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit
import Alamofire

protocol ChangeProfileDelegate {
    func changeUserProfile(name: String, dateOfBirth: String)
}

class ChangeProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var changeProfileDelegate: ChangeProfileDelegate?
    
    // Outlets
    @IBOutlet var name: UITextField!
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var address: UITextField!
    @IBOutlet var gender: UITextField!
    @IBOutlet var dateOfBirth: UITextField!
    
    // Variables
    let genderOption: [String] = ["Laki-laki", "Perempuan"]
    let pickerView = UIPickerView()
    var selectedGender: String?
    let userDefault = UserDefaults.standard
    var userId: String = ""
    var userToken: String = ""
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("apakah kosong userID: \(userId), alternatif: \(userDefault.object(forKey: "userID") as! String)")
        print("apakah kosong userToken: \(userToken), alternatif: \(userDefault.object(forKey: "userLoginKey") as! String)")
        
        if userId == "" {
            userId = userDefault.object(forKey: "userID") as! String
        }
        
        if userToken == "" {
            userToken = userDefault.object(forKey: "userLoginKey") as! String
        }
        
        
        
        getUserData()
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
        imageProfile.clipsToBounds = true
        pickerView.delegate = self
        gender.inputView = pickerView
        
        dismissPickerView()
        
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker: )), for:
                                UIControl.Event.valueChanged)
        datePicker.frame.size  = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        dateOfBirth.inputView = datePicker
        dateOfBirth.text = formatDate(date: Date())
        
        self.imageProfile.contentMode = .scaleAspectFill
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    func getUserData() {
        name.text = userDefault.object(forKey: "userName") as? String
        address.text = userDefault.object(forKey: "userAddress") as? String
        gender.text = userDefault.object(forKey: "userGender") as? String
        dateOfBirth.text = userDefault.object(forKey: "userBirthDate") as? String
        
    }
    
    @IBAction func editImageBtn(_ sender: Any) {
        actionSheet()
    }
    
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(self.action))
        
        toolBar.setItems([flexButton, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        gender.inputAccessoryView = toolBar
        dateOfBirth.inputAccessoryView = toolBar
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        print("Save Profile Pressed")
        let userProfile = UserProfile(name: name.text ?? userDefault.object(forKey: "userName") as! String, address: address.text ?? userDefault.object(forKey: "userAddress") as! String , gender: gender.text ?? userDefault.object(forKey: "userGender") as! String , birthDate: dateOfBirth.text ?? userDefault.object(forKey: "userBirthDate") as! String)
        
        updateData()
        
        
    }
    
    func updateData() {
        
        let url = "https://unitedpaper.backendless.app/api/users/\(userId)"
        
        // Prepare a URL
        let urlString = URL(string: url)
        guard let requestURL = urlString else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(userToken)", forHTTPHeaderField: "user-token")
        
        
        // Create model
        struct UploadData: Codable {
            let name: String
            let address: String
            let gender: String
            let birthDate: String
        }
    
        
        // Add data to the model
        let uploadDataModel = UploadData(name: name.text ?? "", address: address.text ?? "", gender: gender.text ?? "", birthDate: dateOfBirth.text ?? "")
        
        
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
            }
            
        }
        
        task.resume()
        
    }
    
}



// MARK: - UIPickerView
extension ChangeProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func actionSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.openCamera()}))
        
        alert.addAction(UIAlertAction(title: "Galery", style: .default, handler: {_ in self.openGalery()}))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageProfile.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Warning", message: "Your camera is broken", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGalery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You dont have permission to access gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func action()
    {
        view.endEditing(true)
    }
    
    @objc func dateChange(datePicker: UIDatePicker)
    {
        dateOfBirth.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderOption[row]
        guard let safeGender = selectedGender else {return}
        gender.text = "\(safeGender)"
    }
    
}




