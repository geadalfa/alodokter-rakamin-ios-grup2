//
//  ChangeProfileViewController.swift
//  Testing Skeleton
//
//  Created by Evita Sihombing on 04/12/21.
//

import UIKit

class ChangeProfileViewController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var address: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var gender: UITextField!
    @IBOutlet var dateOfBirth: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    
    let genderOption: [String] = ["Laki-laki", "Perempuan"]
    let pickerView = UIPickerView()
    var selectedGender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    @IBAction func editImageBtn(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true)
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
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
}

extension ChangeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info [.originalImage] as?  UIImage {
                        imageProfile.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ChangeProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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




