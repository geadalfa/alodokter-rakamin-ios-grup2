//
//  DoctorViewController.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 04/12/21.
//

import UIKit

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
        
        tableView.register(UINib(nibName: "Doctor", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = 120
        
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
        cell.setUpView(doctor: doctors[indexPath.row])
        return cell
    }
    
}

// MARK: - UISearchBar
extension DoctorViewController: UISearchBarDelegate {
    
}

