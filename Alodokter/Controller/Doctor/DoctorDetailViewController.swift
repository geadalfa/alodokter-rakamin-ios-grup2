//
//  DoctorStoryViewController.swift
//  Alodokter
//
//  Created by Geadalfa Giyanda on 06/12/21.
//

import UIKit
import SDWebImage
import RealmSwift

class DoctorDetailViewController: UIViewController {

    // Outlets
    @IBOutlet weak var consultationSchedule: UITableView!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorDescription: UILabel!
    
    
    // Variables
    let realm = try! Realm()
    let consultationModel = ConsultationModel()
    var doctorNames: String?
    var doctorImageViews: String?
    var doctorProfession: String?
    var doctorDescrip: String?
    let scheduleTime: [String] = [
    "Senin, 20 Desember 2021", "Selasa, 21 Desember 2021", "Rabu, 22 Desember 2021", "Kamis, 23 Desember 2021"]
    var scheduleSelected: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        consultationSchedule.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "scheduleIdentifier")
        
        showDataDoctor()
    }
    
    func showDataDoctor() {
        doctorName.text = doctorNames ?? "Dr. Name"

        doctorSpeciality.text = doctorProfession ?? "No Data"
        doctorDescription.text = doctorDescrip ?? "No Data"
        
        // Get image from API
        let url = URL(string: (doctorImageViews!))
        doctorImageView.sd_setImage(with: url)
    }
    
    
    @IBAction func consultPressed(_ sender: UIButton) {
        
        if scheduleSelected == "" {
            let alert = UIAlertController(title: "Maaf", message: "Harap Pilih Jadwal Konsultasi Dahulu", preferredStyle: .alert)
            let action = UIAlertAction(title: "Terima Kasih", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let consultationObject = ConsultationObject()
            guard let safeDoctorNames = doctorNames else { return }
            consultationObject.name = safeDoctorNames
            consultationObject.consultationDate = scheduleSelected
            save(consultation: consultationObject)
            
            print("jadwalkan: \(scheduleSelected)")
            
            let alert = UIAlertController(title: "Berhasil", message: "Jadwal Konsultasi Telah Dibuat", preferredStyle: .alert)
            let action = UIAlertAction(title: "Terima Kasih", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: true)
                
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func save(consultation: ConsultationObject) {
        do {
            try realm.write {
                realm.add(consultation)
            }
        } catch {
            print("Error to save data \(error.localizedDescription)")
        }
        
    }
    
}




// MARK: - UITableView
extension DoctorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = consultationSchedule.dequeueReusableCell(withIdentifier: "scheduleIdentifier", for: indexPath) as! ScheduleTableViewCell
        cell.scheduleLabel.text = scheduleTime[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleSelected = scheduleTime[indexPath.row]
    }
    
}
