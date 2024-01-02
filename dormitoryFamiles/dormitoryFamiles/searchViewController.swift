//  searchViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/02.
//
import UIKit
class searchViewController: UITableViewController {
    let cellIdentifier = "BulletinBoardMainTableViewCell"
    let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
           return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
       }
    
    var allData = ["Sample 1", "Sample 2", "Test Data", "Example"] // 원본 데이터
       var filteredData = [String]() // 필터링된 결과를 담을 배열

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nib 파일을 사용하는 경우
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setSearchBar()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    
    private func setSearchBar() {
        
        searchController.searchBar.placeholder = "글 제목, 해시태그"
            searchController.obscuresBackgroundDuringPresentation = false
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                filterContentForSearchText(searchText)
            } else {
                filteredData = allData
            }
            tableView.reloadData()
        }
    
    private func filterContentForSearchText(_ searchText: String) {
           filteredData = allData.filter { (data: String) -> Bool in
               return data.lowercased().contains(searchText.lowercased())
           }
       }

        
    
    private func toggleHiddenView() {
        //        if magnifierImageView.isHidden == false {
        //            self.magnifierImageView.isHidden = true
        //            self.descriptionLabel.isHidden = true
        //        }else {
        //            self.magnifierImageView.isHidden = false
        //            self.descriptionLabel.isHidden = false
        //
        //        }
        //
    }
}
extension searchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        toggleHiddenView()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        toggleHiddenView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let data = isFiltering ? filteredData[indexPath.row] : allData[indexPath.row]
            cell.textLabel?.text = data
            return cell
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return isFiltering ? filteredData.count : allData.count
        }

}
