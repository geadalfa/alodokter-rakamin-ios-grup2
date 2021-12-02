//
//  ArticleViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import UIKit

class ArticleViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    
    // Variables
    let articleModel = ArticleModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleIdentifier")
        articleTableView.rowHeight = 100
    }
    
    
}

// MARK: - UICollectionView
extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleModel.article.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellArticle = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionIdentifier", for: indexPath) as! ArticleCellCollection
        let index = articleModel.article[indexPath.row]
        let image = UIImage(named: "\(index.image)")
        cellArticle.articleImageView.image = image
        cellArticle.articleLabel.text = index.title
        
        return cellArticle
        
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

// MARK: - UITableView
extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleModel.article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleIdentifier", for: indexPath) as! ArticleTableViewCell
        let index = articleModel.article[indexPath.row]
        cell.articleImageView.image = UIImage(named: "\(index.image)")
        cell.articleTitleLabel.text = index.title
        cell.articleContentLabel.text = index.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = articleModel.article[indexPath.row]
        
        let detailArticleVC = storyboard?.instantiateViewController(identifier: "detailArticle") as! DetailArticleViewController
        detailArticleVC.articleTitle = index.title
        detailArticleVC.articleImage = index.image
        detailArticleVC.articleContent = index.content
        
        self.navigationController?.pushViewController(detailArticleVC, animated: true)
        self.articleTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}
