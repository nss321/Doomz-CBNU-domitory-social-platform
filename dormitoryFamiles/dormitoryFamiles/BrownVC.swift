//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

class BrownVC: UIViewController {
    var articles: [Article] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        collectionView.register(UINib(nibName: "PopularCollectionViewHeader",
                                      bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        network(url: "")
        
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    private func network(url: String) {
        //        let url = URL(string: url)!
        //        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        //            if let error = error {
        //                print("Error: \(error)")
        //            } else if let data = data {
        //                let decoder = JSONDecoder()
        //                do {
        //                    let response = try decoder.decode(ArticleResponse.self, from: data)
        //
        
        //                } catch {
        //                    print("Error: \(error)")
        //                }
        //            }
        //        }
        //        task.resume()
        
        let jsonString = """
        {
            "code": 200,
            "data": {
                "articles": [
                    {
                        "articleId": 1,
                        "nickName": "sominZzang",
                        "profileUrl": "aefeafjl.caefa.faef",
                        "boardType": "도와주세요",
                        "title": "바퀴벌레 잡아주실 분",
                        "content": "ㅠㅠㅠ 무서워용",
                        "wishCount": 4,
                        "amIWish": 0,
                        "commentCount": 2,
                        "viewCount": 12,
                        "status": "progress",
                        "createdDate": "2023-12-22T15:30:00",
                        "thumbnailUrl": "faefeafjl.caefa.faef"
                    },
                    {
                        "articleId": 2,
                        "nickName": "simgleCore",
                        "profileUrl": "aefeafjl.caefa.faef",
                        "boardType": "도와주세요",
                        "title": "배고프다",
                        "content": "혼밥 싫어요!",
                        "wishCount": 122,
                        "amIWish": 1,
                        "commentCount": 44,
                        "viewCount": 12,
                        "status": "done",
                        "createdDate": "2023-12-22T15:30:00",
                        "thumbnailUrl": "faefeafjl.caefa.faef"
                    }
                ]
            }
        }
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ArticleResponse.self, from: jsonData)
                //데이터 받아오는것에 성공시 작업할내용들
                articles = response.data.articles
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                
            } catch {
                print("Error: \(error)")
            }
        }
        
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
        cell.nickName.text = article.nickName
        cell.viewCount.text = "조회" + String(article.viewCount)
        cell.commentCount.text = String(article.commentCount)
        cell.wishCount.text = String(article.wishCount)
        cell.content.text = article.content
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335, height: 167)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    // 헤더의 크기를 지정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 56)
    }
    
    // 헤더를 생성하는 함수
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
}
