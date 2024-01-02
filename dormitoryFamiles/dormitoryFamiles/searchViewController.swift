//
//  searchViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/02.
//

import UIKit

class searchViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setSearchBar()
    }
    

    private func setSearchBar() {
        
        searchController.searchBar.placeholder = "글 제목, 해시태그"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            searchController.filterContentForSearchText(searchText)
           }
    }

}
