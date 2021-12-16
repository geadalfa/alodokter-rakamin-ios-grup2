//
//  HomeViewController.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 01/12/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var doctorCollectionView: UICollectionView!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var bannerTitleLabel: UILabel!
    
    // Variables
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let userDefault = UserDefaults.standard
    var doctorsArray: [Datum] = [Datum]()
    var jsonData: Data?
    var article = [Articles]()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.center = doctorCollectionView.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        displayData()
        displayDataArticle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        label.textColor = UIColor.black
        label.text = "Hi, \(userDefault.string(forKey: "userName") ?? "Guest")"
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        if (userDefault.string(forKey: "userName") != nil) {
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    func showAlert(type: String) {
        let showAlert = UIAlertController(title: "Belum Sign-In", message: "Mohon Sign In terlebih dahulu untuk melihat \(type) ini", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default)
        showAlert.addAction(action)
        self.present(showAlert, animated: true, completion: nil)
    }
    
    @IBAction func seeMore(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyboard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = article.last?.title
        detailArticleVC.articleImage = article.last?.image
        detailArticleVC.articleContent = article.last?.welcomeDescription
        detailArticleVC.articleAuthor = article.last?.reference
        detailArticleVC.articleDate = article.last?.datePosted
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
        guard let url = URL(string: "https://alodokter-api.herokuapp.com/doctors/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode(Doctor.self, from: data) {
                    //let json = try! JSONDecoder().decode(NestedJSONModel.self, from: jsonData)
                    
                    let dataArray = decodedPosts.data
                    
                    for item in dataArray {
                        let name = item.name
                        let spesialis = item.spesialis
                        let image = item.img
                        let desc = item.desc
                        let id = item.id
                        let timetable = item.timetable
                        let nip = item.nip
                        let location = item.location
                        let phone = item.phone
                        let createdAt = item.createdAt
                        let updatedAt = item.updatedAt
                        
                        self.doctorsArray.append(
                            Datum(id: id, name: name, nip: nip, spesialis: spesialis, location: location, timetable: timetable, phone: phone, img: image, desc: desc, createdAt: createdAt, updatedAt: updatedAt))
                    }
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
            if article.count < 10 {
                return article.count
            }
            else {
                return 10
            }
            return 1
        }
        
        if collectionView == self.doctorCollectionView {
            if doctorsArray.count < 10 {
                return doctorsArray.count
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
            let index = article[indexPath.row]
            let urlImage:URL = URL(string: index.image)!
            print("debug: \(urlImage)")
            cellArticle.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cellArticle.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "logo"))
            cellArticle.articleLabel.text = index.title
            
            return cellArticle
        }
        
        if collectionView == self.doctorCollectionView {
            let cellDoctor = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorCollectionIdentifier", for: indexPath) as! DoctorCellCollection
            
            // Get image from API
            let urlString = doctorsArray[indexPath.row].img
            let url = URL(string:urlString)
            cellDoctor.doctorImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cellDoctor.doctorImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
            
            cellDoctor.doctorNameLabel.text = doctorsArray[indexPath.row].name
            cellDoctor.doctorProfessionLabel.text = doctorsArray[indexPath.row].spesialis
            
            return cellDoctor
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.articleCollectionView {
            let indexPath = article[indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
            detailArticleVC.articleTitle = indexPath.title
            detailArticleVC.articleImage = indexPath.image
            detailArticleVC.articleContent = indexPath.welcomeDescription
            detailArticleVC.articleAuthor = indexPath.reference
            detailArticleVC.articleDate = indexPath.datePosted
            detailArticleVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(detailArticleVC, animated: true)
        }
        else if collectionView == self.doctorCollectionView {
            if UserDefaults.standard.string(forKey: "userName") != nil {
                let indexPath = doctorsArray[indexPath.row]
                let storyBoard: UIStoryboard = UIStoryboard(name: "DoctorStory", bundle: nil)
                let detailDoctorVC = storyBoard.instantiateViewController(withIdentifier: "DoctorStoryController") as! DoctorDetailViewController
                detailDoctorVC.doctorImageViews = indexPath.img // Get image URL from JSON API
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
        guard let url = URL(string: "https://61af73793e2aba0017c49367.mockapi.io/articles/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Articles].self, from: data) {
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
        let urlImage = URL(string: article.last?.image ?? "")
        bannerView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        bannerView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "banner"))
        bannerTitleLabel.text = article.last?.title ?? ""
    }
}

