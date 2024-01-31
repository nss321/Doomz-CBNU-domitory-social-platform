//
//  bulletinBoardMainViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/01.
//
import Tabman
import Pageboy
import UIKit

class BulletinBoardMainViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController(), UIViewController()]
    let cellIdentifier = "BulletinBoardMainTableViewCell"
    @IBOutlet weak var naviCustomView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var writeButton: TagButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setTapman()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        collectionView.register(UINib(nibName: "PopularCollectionViewHeader",
                                              bundle: nil),
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: "header")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setUI() {
        writeButton.configuration?.image = UIImage(named: "bulletinBoardPlus")
        writeButton.spacing = 10000
    }
    
    private func setTapman() {
        self.dataSource = self
                // Create bar
                let bar = TMBar.LineBar()
                bar.layout.transitionStyle = .snap // Customize
        bar.layout.alignment = .centerDistributed
        bar.contentMode = .scaleAspectFit
        
        

                // Add to view
                addBar(bar, dataSource: self, at: .top)
        
        let item = TMBarItem(title: "dddddddd")
        item.title = "Item 1"
        item.badgeValue = "New"
            
    }
    
}

extension BulletinBoardMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 99
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
        
        cell.layer.cornerRadius = 20
        
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
                // headerView 설정 코드를 여기에 작성하세요
                
                return headerView
            default:
                assert(false, "Invalid element type")
            }
        }
    
}


extension BulletinBoardMainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewControllers.count
        }

        func viewController(for pageboyViewController: PageboyViewController,
                            at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }

        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }

        func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    
}
