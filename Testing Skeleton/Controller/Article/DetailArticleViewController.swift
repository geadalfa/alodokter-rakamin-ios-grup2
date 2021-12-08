//
//  DetailArticleViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class DetailArticleViewController: UIViewController {
    
    
    // Outlets
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!

    // Variables
    var articleTitle: String?
    var articleImage: String?
    var articleContent: String?
    var articleAuthor: String?
    var articleDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       showDataArticle()
    }
    
    func showDataArticle() {
        articleTitleLabel.text = articleTitle ?? "No Data"
        articleImageView.image = UIImage(named: "\(articleImage ?? "Logo")")
        articleContentLabel.text = articleContent ?? "No Data"
        articleAuthorLabel.text = "Penulis: \(articleAuthor ?? "")"
        articleDateLabel.text = "Tanggal: \(articleDate ?? "")"
    }
    


}
