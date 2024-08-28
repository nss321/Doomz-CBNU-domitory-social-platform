//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

final class BrownVC: UIViewController {
    private var arraylist: [Article] = []
    private var pageNum = 0
    private var isLoadingItems = true
    var kind : Category?
    
    private var articles: [Article] = []
    var path = ""
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        network(url: Url.base + path)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeDormiotry), name: .changeDormiotry, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageNum = 0
        articles.removeAll()
        network(url: Url.base + path) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func network(url: String, completion: (() -> Void)? = nil) {
        Network.getMethod(url: url) { (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                let newArticles = response.data.articles
                if newArticles.isEmpty {
                    self.isLoadingItems = false
                } else {
                    self.articles = newArticles
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    completion?()
                }
            case .failure(let error):
                print("Error: \(error)")
                completion?()
            }
        }
    }

    
    @objc private func changeDormiotry() {
        network(url: Url.base + path)
        self.collectionView.reloadData()
    }
    
    
    private func loadNextPage() {
           // 카테고리에 맞는 다음 페이지 보여주기
           guard isLoadingItems else { return }
           
           pageNum += 1
           
           switch kind {
           case .lost:
               path = Url.lostUrl(page: pageNum)
           case .share:
               path = Url.shareUrl(page: pageNum)
           case .together:
               path = Url.togetherUrl(page: pageNum)
           case .help:
               path = Url.helpPostUrl(page: pageNum)
           case .all:
               path = Url.pathAllPostUrl(page: pageNum)
           case .none:
               break
           }
           
           network(url: Url.base + path)
       }
    
}


extension BrownVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let url = "http://43.202.254.127:8080/api/articles/\(id)"
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

extension BrownVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // 스크롤 끝나면 다음페이지로
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height {
                loadNextPage()
            }
        }
}
