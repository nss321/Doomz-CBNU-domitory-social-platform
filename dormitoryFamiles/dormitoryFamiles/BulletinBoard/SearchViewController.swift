//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

final class SearchViewController: UIViewController {
    private var articles: [Article] = []
    private var path = ""
    @IBOutlet weak var searchWordLabel: UILabel!
    @IBOutlet weak var noPostImageSettingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar = UISearchBar()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //검색 화면에 들어올때 검색 결과가 없다는 창은 아예 안보여야함.
        noPostImageSettingView.isHidden = true
        updateCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        network(url: Url.base + path, searchText: "")
        setSearchBar()
        
    }
    
    func updateCollectionView() {
        let keword = searchBar.text ?? ""
        articles.removeAll()
        network(url: Url.base+Url.searchUrl(searchText: keword), searchText: keword) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setSearchBar() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 40))
        searchBar.placeholder = "검색어를 입력해 주세요."
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.leftView = nil
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 as Any])
            textFieldInsideSearchBar.font = UIFont(name: "Pretendard Variable", size: 16)
        }
        searchBar.searchTextField.backgroundColor = .gray0
        searchBar.searchTextField.layer.cornerRadius = searchBar.bounds.height / 2
        searchBar.searchTextField.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func network(url: String, searchText: String, completion: (() -> Void)? = nil) {
        Network.getMethod(url: url) { (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                self.articles = response.data.articles
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.articles.isEmpty {
                        print("검색 결과 없음")
                        self.searchWordLabel.title3 = "'\(searchText)'"
                        self.noPostImageSettingView.isHidden = false
                        completion?()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
                completion?()
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BulluetinBoardCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
        
        cell.layer.cornerRadius = 20
        
        
        let article = articles[indexPath.row]
        cell.title.text = article.title
        cell.nickName.text = article.nickname
        cell.viewCount.text = "조회" + String(article.viewCount)
        cell.commentCount.text = String(article.commentCount)
        cell.wishCount.text = String(article.wishCount)
        cell.content.text = article.content
        cell.categoryTag.body2 = article.boardType
        cell.statusTag.body2 = article.status
        cell.profileUrl = article.profileUrl
        cell.thumbnailUrl = article.thumbnailUrl
        
        let dateString = article.createdAt
        if let formattedString = DateUtility.formattedDateString(from: dateString) {
            cell.createdDateLabel.body2 = formattedString
        } else {
            cell.createdDateLabel.body2 = article.createdAt
        }
        
        if article.status == "모집완료" {
            cell.changeFinish()
        }else {
            cell.changeIng()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleElement = articles[indexPath.row]
        
        let id = articleElement.articleId
        
        let url = Url.searchBulletinBoard(id: id)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let articleDetailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as? BulletinBoardDetailViewViewController {
            articleDetailViewController.setUrl(url: url)
            articleDetailViewController.id = id
            self.navigationController?.pushViewController(articleDetailViewController, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335, height: 167)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    //검색이 완료되면 실행되는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        noPostImageSettingView.isHidden = true
        if let searchText = searchBar.text {
            print("검색어: \(searchText)")
            network(url: Url.base+Url.searchUrl(searchText: searchText), searchText: searchText)
        }
    }
}
