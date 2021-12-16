//
//  DoctorCellTable.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 04/12/21.
//

import UIKit

class DoctorCellTable: UITableViewCell {
    
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var doctorImageView: UIImageView!
    @IBOutlet var doctorProfessionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.2
        cellView.layer.shadowRadius = 4
        

        cellView.layer.masksToBounds = false
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0 )
    }
    
    
    func setUpView(doctor: Datum) {
        doctorNameLabel.text = doctor.name
        doctorImageView.image = UIImage(named: "avatar")
        doctorImageView.layer.borderWidth = 0.2
        doctorImageView.layer.masksToBounds = false
        doctorImageView.layer.borderColor = UIColor.white.cgColor
    }

}
