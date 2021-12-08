//
//  HomeViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 01/12/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var doctorCollectionView: UICollectionView!
    @IBOutlet weak var signInButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    
    // Variables
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let articleModel = ArticleModel()
    let doctorModel = DoctorModels()
    let userDefault = UserDefaults.standard
    var doctors = [Doctor]()
    var article = FetchArticle(status: "", totalResults: 0, articles: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.center = doctorCollectionView.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        displayData()
        displayDataArticle()
        
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
        let storyboard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyboard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = article.articles?[10].title
        detailArticleVC.articleImage = article.articles?[10].urlToImage
        detailArticleVC.articleContent = article.articles?[10].content
        detailArticleVC.articleAuthor = article.articles?[10].author
        detailArticleVC.articleDate = article.articles?[10].publishedAt
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
        guard let url = URL(string: "https://61a9916133e9df0017ea3e3d.mockapi.io/doctor") else { return }
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
            if article.totalResults < 10 {
                return article.totalResults
            }
            else {
                return 10
            }
            return 1
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
            let index = article.articles?[indexPath.row]
            let urlImage = URL(string: index?.urlToImage ?? "")
            cellArticle.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cellArticle.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "logo"))
            cellArticle.articleLabel.text = index?.title ?? ""
            
            return cellArticle
        }
        
        if collectionView == self.doctorCollectionView {
            let cellDoctor = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorCollectionIdentifier", for: indexPath) as! DoctorCellCollection
            
            // Get image from API
            let urlString = doctors[indexPath.row].image
            let url = URL(string:urlString)
            cellDoctor.doctorImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cellDoctor.doctorImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
            
            cellDoctor.doctorNameLabel.text = doctors[indexPath.row].name
            cellDoctor.doctorProfessionLabel.text = doctors[indexPath.row].spesialis
            
            return cellDoctor
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.articleCollectionView {
            let indexPath = article.articles?[indexPath.row]
            let urlImage = URL(string: indexPath?.urlToImage ?? "")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
            detailArticleVC.articleTitle = indexPath?.title
            detailArticleVC.articleImage = indexPath?.urlToImage
            detailArticleVC.articleContent = indexPath?.content
            detailArticleVC.articleAuthor = indexPath?.author
            detailArticleVC.articleDate = indexPath?.publishedAt
            detailArticleVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(detailArticleVC, animated: true)
        }
        else if collectionView == self.doctorCollectionView {
            if UserDefaults.standard.string(forKey: "userName") != nil {
                let indexPath = doctors[indexPath.row]
                let storyBoard: UIStoryboard = UIStoryboard(name: "DoctorStory", bundle: nil)
                let detailDoctorVC = storyBoard.instantiateViewController(withIdentifier: "DoctorStoryController") as! DoctorStoryViewController
                detailDoctorVC.doctorImageViews = indexPath.image // Get image URL from JSON API
                detailDoctorVC.doctorNames = indexPath.name
                detailDoctorVC.doctorProfession = indexPath.spesialis
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

extension HomeViewController {
    func displayDataArticle() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=id&apiKey=c910bfd484464746b4c911b0615c1028") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode(FetchArticle.self, from: data) {
                    self.article = decodedPosts
                    DispatchQueue.main.async {
                        //self.activityIndicatorView.stopAnimating()
                        //self.activityIndicatorView.isHidden = true
                        self.articleCollectionView.reloadData()
                        self.loadBanner()
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
}

extension HomeViewController {
    func loadBanner() {
        let urlImage = URL(string: article.articles?[10].urlToImage ?? "")
        bannerView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        bannerView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "corona"))
        bannerTitleLabel.text = article.articles?[10].title ?? ""
    }
}
