//
//  DoctorCellTable.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 04/12/21.
//

import UIKit

class DoctorCellTable: UITableViewCell {
    
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var doctorImageView: UIImageView!
    @IBOutlet var doctorProfessionLabel: UILabel!
    @IBOutlet var doctorDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.2
        cellView.layer.shadowRadius = 4
        

        cellView.layer.masksToBounds = false
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0 )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
