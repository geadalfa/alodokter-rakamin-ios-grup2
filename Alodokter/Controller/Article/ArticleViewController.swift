//
//  ArticleViewController.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit
import SDWebImage

class ArticleViewController: UIViewController, UISearchBarDelegate {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // Variables
    var ModelArticle = [Articles]()
    let activityIndicatorCollectionView = UIActivityIndicatorView(style: .large)
    let activityIndicatorTableView = UIActivityIndicatorView(style: .large)
    var searchBarText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateIndicator()
        articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleIdentifier")
        articleTableView.rowHeight = 140
        displayData()
    }
}

extension ArticleViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Canceled!")
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Text: \(searchText)")
    }
}

// MARK: - UICollectionView
extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ModelArticle.count > 20 {
            return 20
        }
        return ModelArticle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellArticle = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionIdentifier", for: indexPath) as! ArticleCellCollection
        let index = ModelArticle[indexPath.row]
        let urlImage = URL(string: index.image)
        cellArticle.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cellArticle.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "banner"))
        cellArticle.articleLabel.text = index.title
        
        return cellArticle
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = ModelArticle[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = indexPath.title
        detailArticleVC.articleImage = indexPath.image
        detailArticleVC.articleAuthor = indexPath.reference
        detailArticleVC.articleDate = indexPath.datePosted
        detailArticleVC.articleContent = indexPath.welcomeDescription
        detailArticleVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail article screen
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
    }
    
    
    
}

// MARK: - UITableView
extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ModelArticle.count > 20 {
            return 20
        }
        return ModelArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as! ArticleTableViewCell
        let index = ModelArticle[indexPath.row]
        let urlImage = URL(string: index.image)
        cell.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "banner"))
        cell.articleTitleLabel.text = index.title
        cell.articleContentLabel.text = index.welcomeDescription
        //cell.articleImageView.image = UIImage(named: "logo.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = ModelArticle[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = index.title
        detailArticleVC.articleImage = index.image
        detailArticleVC.articleContent = index.welcomeDescription
        detailArticleVC.articleAuthor = index.reference
        detailArticleVC.articleDate = index.datePosted
        detailArticleVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail article screen
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
        self.articleTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}

//MARK: Fetch Article Data
extension ArticleViewController {
    func displayData() {
        guard let url = URL(string: "https://61af73793e2aba0017c49367.mockapi.io/articles/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Articles].self, from: data) {
                    self.ModelArticle = decodedPosts
                    DispatchQueue.main.async {
                        //self.activityIndicatorView.stopAnimating()
                        //self.activityIndicatorView.isHidden = true
                        self.activityIndicatorCollectionView.stopAnimating()
                        self.activityIndicatorCollectionView.isHidden = true
                        self.activityIndicatorTableView.stopAnimating()
                        self.activityIndicatorTableView.isHidden = true
                        self.articleCollectionView.reloadData()
                        self.articleTableView.reloadData()
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

extension ArticleViewController {
    func activateIndicator() {
        activityIndicatorCollectionView.center = articleCollectionView.center
        activityIndicatorTableView.center = articleTableView.center
        activityIndicatorCollectionView.startAnimating()
        activityIndicatorTableView.startAnimating()
        view.addSubview(activityIndicatorCollectionView)
        view.addSubview(activityIndicatorTableView)
        activityIndicatorCollectionView.isHidden = false
        activityIndicatorTableView.isHidden = false
    }
}
