//
//  DoctorCell.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class DoctorCellCollection: UICollectionViewCell {

    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorProfessionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        doctorImageView.layer.borderWidth = 0.2
        doctorImageView.layer.masksToBounds = false
        doctorImageView.layer.borderColor = UIColor.white.cgColor
        doctorImageView.layer.cornerRadius = image.frame.size.width / 2
        doctorImageView.clipsToBounds = true

    }
    
}
