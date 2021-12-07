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
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let articleModel = ArticleModel()
    let doctorModel = DoctorModels()
    let userDefault = UserDefaults.standard
    var doctors = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.center = doctorCollectionView.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        displayData()
        
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
        loginView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    @IBAction func seeMore(_ sender: Any) {
        
        let data = articleModel.article[0]
        let storyboard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyboard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = data.title
        detailArticleVC.articleImage = data.image
        detailArticleVC.articleContent = data.content
        detailArticleVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
        
    }
    
    @IBAction func allArticle(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func allDoctor(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func displayData() {
        guard let url = URL(string: "https://61a9916133e9df0017ea3e3d.mockapi.io/users") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Doctor].self, from: data) {
                    self.doctors = decodedPosts
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.doctorCollectionView.reloadData()
                    }
                } else {
                    debugPrint("Failure to decode posts.")
                    print(error?.localizedDescription)
                }
            } else {
                debugPrint("Failure to get data.")
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.articleCollectionView {
            return articleModel.article.count
        }
        
        if collectionView == self.doctorCollectionView {
            if doctors.count < 10 {
                return doctors.count
            }
            else {
                return 10
            }
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
            cellDoctor.doctorNameLabel.text = doctors[indexPath.row].name
            cellDoctor.doctorProfessionLabel.text = doctors[indexPath.row].placeOfBirth
            
            return cellDoctor
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.articleCollectionView {
            let indexPath = articleModel.article[indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
            detailArticleVC.articleTitle = indexPath.title
            detailArticleVC.articleImage = indexPath.image
            detailArticleVC.articleContent = indexPath.content
            detailArticleVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(detailArticleVC, animated: true)
        }
        else if collectionView == self.doctorCollectionView {
            if UserDefaults.standard.string(forKey: "userName") != nil {
                let indexPath = doctorModel.doctor[indexPath.row]
                let storyBoard: UIStoryboard = UIStoryboard(name: "DoctorStory", bundle: nil)
                let detailDoctorVC = storyBoard.instantiateViewController(withIdentifier: "DoctorStoryController") as! DoctorStoryViewController
                detailDoctorVC.doctorImageViews = indexPath.image
                detailDoctorVC.doctorNames = indexPath.name
                detailDoctorVC.doctorProfession = indexPath.profession
                detailDoctorVC.doctorDescrip = indexPath.desc
                detailDoctorVC.hidesBottomBarWhenPushed = true
                detailDoctorVC.navigationItem.title = indexPath.name
                self.navigationController?.pushViewController(detailDoctorVC, animated: true)
            }
            else {
                showAlert(type: "Dokter")
            }
        }
    }
}

//extension HomeViewController {
//    static func shareInstance() -> HomeViewController {
//        return HomeViewController()
//    }
//}
