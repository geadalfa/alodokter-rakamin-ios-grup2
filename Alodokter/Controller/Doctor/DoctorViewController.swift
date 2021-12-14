//
//  DoctorViewController.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 04/12/21.
//

import UIKit
import SDWebImage
import RealmSwift

class DoctorViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let userDefaults = UserDefaults.standard
    var doctors = [Doctor]()
    let illustrateImage = IlustrateImage2()
    var searchBarText: String = ""
    var loadingState = true
    var realm = try! Realm()
    var consultationItem: Results<ConsultationObject>?
    let sectionLabel = ["Jadwal Konsultasimu", "Daftar Dokter Terbaik"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDatabase()
        
        if userDefault.object(forKey: "userLoginKey") as? String != nil {
            print("token available")
            self.navigationItem.setRightBarButton(nil, animated: true)
            activityIndicatorView.center = view.center
            activityIndicatorView.startAnimating()
            view.addSubview(activityIndicatorView)
            activityIndicatorView.isHidden = false
            
            tableView.register(UINib(nibName: "DoctorCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
            tableView.rowHeight = 85
            
            displayData()
        } else {
            print("token not available")
            illustrateImage.getImage(view: view)
            tableView.isHidden = true
            searchController.searchBar.isHidden = true
        }
        
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        if let doctorSearch = userDefaults.string(forKey: "doctorLabel") {
            searchController.searchBar.placeholder = "Your Latest Search: \(doctorSearch)"
        } else {
            searchController.searchBar.placeholder = "Search by keywords"
        }
                
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func loadDatabase() {
        
        consultationItem = realm.objects(ConsultationObject.self)
        tableView.reloadData()
        
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
                        self.loadingState = false
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

// MARK: - UITableViewDelegate

extension DoctorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLabel[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let safeConsultation = consultationItem?.count else { return 0 }
        
        if section == 0 {
            return safeConsultation
        }
        
        if section == 1 {
            return doctors.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let safeConsultation = consultationItem else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if indexPath.row < safeConsultation.count {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                
                cell.textLabel?.text = "\(safeConsultation[indexPath.row].consultationDate)"
                cell.detailTextLabel?.text = "\(safeConsultation[indexPath.row].name)"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                cell.isUserInteractionEnabled = false
                return cell
            }
            
        }
        
        
        if indexPath.section == 1 {
            if indexPath.row < doctors.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! DoctorCellTable
                let index = doctors[indexPath.row]
                let urlImage = URL(string: index.image)
                cell.doctorImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.doctorImageView.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "avatar"))
                cell.doctorNameLabel.text = index.name
                cell.doctorProfessionLabel.text = index.spesialis
                cell.doctorImageView.layer.cornerRadius = 29
                cell.doctorImageView.layer.masksToBounds = true

                return cell
            }
        }

        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let index = doctors[indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name: "DoctorStory", bundle: nil)
            let detailDoctorVC = storyBoard.instantiateViewController(withIdentifier: "DoctorStoryController") as! DoctorDetailViewController
            detailDoctorVC.doctorImageViews = index.image // Get image URL from JSON API
            detailDoctorVC.doctorNames = index.name
            detailDoctorVC.doctorProfession = index.spesialis
            detailDoctorVC.doctorDescrip = index.desc
            detailDoctorVC.hidesBottomBarWhenPushed = true
            detailDoctorVC.navigationItem.title = index.name
            detailDoctorVC.hidesBottomBarWhenPushed = true // Removing bottom bar in detail doctor screen
            self.navigationController?.pushViewController(detailDoctorVC, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}

// MARK: - UISearchBar
extension DoctorViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Succeed!")
        searchBar.endEditing(true)
        if !loadingState {
            if searchBarText != "" {
                //Call Search Function Here!
                doctors = searchFilter(key: searchBarText)
                tableView.reloadData()
                print(searchBarText)
    
            }
            else {
                displayData()
                searchBarText = ""
            }
        }
    }
    
    // Display the doctor list when user click "cancel" on searchbar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        displayData()
    }
    
    // Display the doctor list when the search bar is empty
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Text: \(searchText)")
        searchBarText = searchText
        if searchBarText == "" {
            displayData()
        }
        if searchText == "" {
            displayData()
        }
    }

    // Search and match the keyword from user to doctor name/specialization
    func searchFilter(key: String) -> [Doctor]{
        let searchResult2 = doctors.filter { data in
            return data.spesialis.lowercased().contains(key.lowercased()) || data.name.lowercased().contains(key.lowercased())
        }
        return searchResult2
    }
}

