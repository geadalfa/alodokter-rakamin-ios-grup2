//
//  ArticleViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit
import SDWebImage

class ArticleViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    
    // Variables
    let articleModel = ArticleModel()
    var ModelArticle = FetchArticle(status: "", totalResults: 0, articles: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleIdentifier")
        articleTableView.rowHeight = 140
        displayData()
    }
    
    
}

// MARK: - UICollectionView
extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ModelArticle.totalResults > 20 {
            return 20
        }
        return ModelArticle.totalResults
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellArticle = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionIdentifier", for: indexPath) as! ArticleCellCollection
        let index = ModelArticle.articles?[indexPath.row]
        let urlImage = URL(string: index?.urlToImage ?? "")
        cellArticle.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cellArticle.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "corona"))
        cellArticle.articleLabel.text = index?.title ?? ""
        
        return cellArticle
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = ModelArticle.articles?[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = indexPath?.title
        detailArticleVC.articleImage = indexPath?.urlToImage
        detailArticleVC.articleAuthor = indexPath?.author
        detailArticleVC.articleDate = indexPath?.publishedAt
        detailArticleVC.articleContent = indexPath?.content
        detailArticleVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail article screen
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
    }
    
    
    
}

// MARK: - UITableView
extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ModelArticle.totalResults > 20 {
            return 20
        }
        return ModelArticle.totalResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as! ArticleTableViewCell
        let index = ModelArticle.articles?[indexPath.row]
        let urlImage = URL(string: index?.urlToImage ?? "")
        cell.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.articleImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "corona"))
        cell.articleTitleLabel.text = index?.title ?? ""
        cell.articleContentLabel.text = index?.description ?? ""
        cell.articleImageView.image = UIImage(named: "logo.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = ModelArticle.articles?[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
        let detailArticleVC = storyBoard.instantiateViewController(withIdentifier: "DetailArticleController") as! DetailArticleViewController
        detailArticleVC.articleTitle = index?.title
        detailArticleVC.articleImage = index?.urlToImage
        detailArticleVC.articleContent = index?.content
        detailArticleVC.articleAuthor = index?.author
        detailArticleVC.articleDate = index?.publishedAt
        detailArticleVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail article screen
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
        self.articleTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}

//MARK: Fetch Article Data
extension ArticleViewController {
    func displayData() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=id&apiKey=c910bfd484464746b4c911b0615c1028") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode(FetchArticle.self, from: data) {
                    self.ModelArticle = decodedPosts
                    print("Debug: \(decodedPosts.articles?.count)")
                    DispatchQueue.main.async {
                        //self.activityIndicatorView.stopAnimating()
                        //self.activityIndicatorView.isHidden = true
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
