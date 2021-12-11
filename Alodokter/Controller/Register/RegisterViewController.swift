//
//  RegisterViewController.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    
    // Variables
    let genderOptions: [String] = ["Laki-laki", "Perempuan"]
    let pickerView = UIPickerView()
    var selectedGender: String?
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        genderTextField.inputView = pickerView
        
        dismissPickerView()
        
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        birthDateTextField.inputView = datePicker
        birthDateTextField.text = formatDate(date: Date())
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        toolBar.setItems([flexButton, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
        birthDateTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    @objc func dateChange(datePicker: UIDatePicker)
    {
        birthDateTextField.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        guard let safeName = nameTextField.text else { return }
        guard let safeEmail = emailTextField.text else { return }
        guard let safePassword = passwordTextField.text else { return }
        guard let safeAddress = addressTextField.text else { return }
        guard let safeGender = genderTextField.text else { return }
        guard let safeBirthDate = birthDateTextField.text else { return }
        guard let safeConfirmation = confirmationPasswordTextField.text else { return }
        
        if safePassword == safeConfirmation && safePassword != "" {
            let register = RegisterModel(name: safeName, email: safeEmail, password: safePassword, address: safeAddress, gender: safeGender, birthDate: safeBirthDate)
            APIManager.shareInstance.callingRegisterAPI(register: register) { isSuccess, str in
                if isSuccess {
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    self.alert(title: "Terima Kasih", message: str)
                    
                } else {
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.isHidden = true
                    self.alert(title: "Terjadi Kesalahan", message: str)
                }
            }
            
            
            
        } else {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            let alertController = UIAlertController(title: "Perhatian!", message:
                                                        "Konfirmasi Password Tidak Sesuai", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        if nameTextField.text == "" || emailTextField.text == "" || addressTextField.text == "" || genderTextField.text == "" || passwordTextField.text == "" || confirmationPasswordTextField.text == "" {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            let alertController = UIAlertController(title: "Data Belum Lengkap!", message:
                                                        "Mohon Lengkapi Biodata Anda", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Terima Kasih", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerView
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderOptions[row]
        guard let safeGender = selectedGender else { return }
        genderTextField.text = "\(safeGender)"
    }
    
    
}

// MARK: - String

extension String {
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
