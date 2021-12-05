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
    let userDefaults = UserDefaults.standard
    let doctorModel = DoctorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "Doctor", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
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
        return doctorModel.doctor.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! DoctorCellTable
        var title: String?
        var content: String?
        APIManager.shareInstance.callingDoctorAPI() { (result) in
            switch result {
            case .success(let json):
                title = (json as! DoctorModelAPI).articles[indexPath.row].content
                content = (json as! DoctorModelAPI).articles[indexPath.row].content
                print(title)
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        cell.doctorNameLabel.text = title
        cell.doctorProfessionLabel.text = content
//        cell.doctorImageView.image = UIImage(named: "\(index.image)")
        
        return cell
    }
    
}


extension DoctorViewController: UISearchBarDelegate {
    
}
