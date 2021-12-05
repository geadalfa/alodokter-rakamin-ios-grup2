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
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    // Variables
    let articleModel = ArticleModel()
    let doctorModel = DoctorModel()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Hi, \(userDefault.string(forKey: "userName") ?? "Guest")"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        if (userDefault.string(forKey: "userName") != nil) {
            signInButton.isEnabled = false
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    func showAlert(type: String) {
        let showAlert = UIAlertController(title: "Belum Sign-In", message: "Mohon Sign In terlebih dahulu untuk melihat \(type) ini", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default)
        showAlert.addAction(action)
        self.present(showAlert, animated: true, completion: nil)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginView = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginView.fromHome = true
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    @IBAction func seeMore(_ sender: Any) {
        //if UserDefaults.standard.string(forKey: "userName") != nil {
            let data = articleModel.article[0]
            let storyboard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let detailArticleVC = storyboard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
            detailArticleVC.articleTitle = data.title
            detailArticleVC.articleImage = data.image
            detailArticleVC.articleContent = data.content
            
            self.navigationController?.pushViewController(detailArticleVC, animated: true)
        //}
        //else {
        //    showAlert(type: "Headline")
        //}
    }
    
    @IBAction func allArticle(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
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
        //if UserDefaults.standard.string(forKey: "userName") != nil {
            let indexPath = articleModel.article[indexPath.row]
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
            detailArticleVC.articleTitle = indexPath.title
            detailArticleVC.articleImage = indexPath.image
            detailArticleVC.articleContent = indexPath.content
            detailArticleVC.hidesBottomBarWhenPushed = true // hide bottom bar in detail article screen
            
            self.navigationController?.pushViewController(detailArticleVC, animated: true)
        //}
        //else {
        //    showAlert(type: "Artikel")
        //}
        
    }
    
    
    
}

extension HomeViewController {
    static func shareInstance() -> HomeViewController {
        return HomeViewController()
    }
}
