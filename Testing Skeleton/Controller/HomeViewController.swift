//
//  HomeViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 01/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var doctorCollectionView: UICollectionView!
    
    // Variables
    let articleModel = ArticleModel()
    let doctorModel = DoctorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Hi, Prince Alvin"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        

    }
    
    @IBAction func allArticle(_ sender: UIButton) { // Function for "Lihat Semua" button to navigate to artikel screen
        self.performSegue(withIdentifier: "goToArticle", sender: self)
    }
    

}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.articleCollectionView {
            return articleModel.article.count
        }
        
        if collectionView == self.doctorCollectionView {
            return doctorModel.doctor.count
        }
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.articleCollectionView {
            let cellArticle = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionIdentifier", for: indexPath) as! ArticleCellCollection
            let index = articleModel.article[indexPath.row]
            let image = UIImage(named: "\(index.image)")
            cellArticle.articleImageView.image = image
            cellArticle.articleLabel.text = index.title
            
            return cellArticle
        }
        
        if collectionView == self.doctorCollectionView {
            let cellDoctor = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorCollectionIdentifier", for: indexPath) as! DoctorCellCollection
            let index = doctorModel.doctor[indexPath.row]
            let image = UIImage(named: "\(index.image)")
            cellDoctor.doctorImageView.image = image
            cellDoctor.doctorNameLabel.text = index.name
            cellDoctor.doctorProfessionLabel.text = index.profession
            
            return cellDoctor
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = articleModel.article[indexPath.row]
        
        let detailArticleVC = storyboard?.instantiateViewController(identifier: "detailArticle") as! DetailArticleViewController
        detailArticleVC.articleTitle = indexPath.title
        detailArticleVC.articleImage = indexPath.image
        detailArticleVC.articleContent = indexPath.content
        
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
    }
    
    
    
}
