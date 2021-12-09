//
//  DoctorViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 04/12/21.
//

import UIKit
import SDWebImage

class DoctorViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let userDefaults = UserDefaults.standard
    var doctors = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        tableView.register(UINib(nibName: "DoctorCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = 70
        
        displayData()
        
    }
    
    func displayData() {
        
        guard let url = URL(string: "https://61a9916133e9df0017ea3e3d.mockapi.io/doctor") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Doctor].self, from: data) {
                    self.doctors = decodedPosts
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = true
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        if let doctorSearch = userDefaults.string(forKey: "doctorLabel") {
            searchController.searchBar.placeholder = "Your Latest Search: \(doctorSearch)"
        } else {
            searchController.searchBar.placeholder = "Search by keywords"
        }
        
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    
    
    
}

// MARK: - UITableViewDelegate

extension DoctorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! DoctorCellTable
        let index = doctors[indexPath.row]
        let urlImage = URL(string: index.image)
        cell.doctorImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.doctorImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "avatar"))
        cell.doctorNameLabel.text = index.name
        cell.doctorProfessionLabel.text = index.spesialis
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = doctors[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "DoctorStory", bundle: nil)
        let detailDoctorVC = storyBoard.instantiateViewController(withIdentifier: "DoctorStoryController") as! DoctorStoryViewController
        detailDoctorVC.doctorImageViews = index.image // Get image URL from JSON API
        detailDoctorVC.doctorNames = index.name
        detailDoctorVC.doctorProfession = index.spesialis
        detailDoctorVC.doctorDescrip = index.desc
        detailDoctorVC.hidesBottomBarWhenPushed = true
        detailDoctorVC.navigationItem.title = index.name
        detailDoctorVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail article screen
        self.navigationController?.pushViewController(detailDoctorVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - UISearchBar
extension DoctorViewController: UISearchBarDelegate {
    
}

