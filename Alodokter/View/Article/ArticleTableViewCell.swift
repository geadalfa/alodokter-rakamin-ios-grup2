//
//  ArticleTableViewCell.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleContentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
