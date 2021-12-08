//
//  DoctorStoryViewController.swift
//  Testing Skeleton
//
//  Created by Geadalfa Giyanda on 06/12/21.
//

import UIKit
import SDWebImage

class DoctorStoryViewController: UIViewController {

    // Outlets
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorDescription: UILabel!
    
    // Variables
    var doctorNames: String?
    var doctorImageViews: String?
    var doctorProfession: String?
    var doctorDescrip: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
