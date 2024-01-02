//
//  searchViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/02.
//

import UIKit

class searchViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var magnifierImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setSearchBar()
        searchController.delegate = self
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
    
    private func toggleHiddenView() {
        if magnifierImageView.isHidden == false {
            self.magnifierImageView.isHidden = true
            self.descriptionLabel.isHidden = true
        }else {
            self.magnifierImageView.isHidden = false
            self.descriptionLabel.isHidden = false

        }
        
    }

}

extension searchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        toggleHiddenView()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        toggleHiddenView()
    }
}
