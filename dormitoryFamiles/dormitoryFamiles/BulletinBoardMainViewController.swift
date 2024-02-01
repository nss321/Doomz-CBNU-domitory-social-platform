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
    private var viewControllers: [UIViewController] {
        let brownVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        let yellowVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yellowVC") as! YellowVC
        let aaa = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aaa")
        //let aaa = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aaa")
        return [brownVC, yellowVC, aaa, UIViewController(), UIViewController()]
    }
    @IBOutlet weak var naviCustomView: UIView!
    
    @IBOutlet weak var tabmanView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var writeButton: TagButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //setDelegate()
        setTapman()
        //self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//
//        collectionView.register(UINib(nibName: "PopularCollectionViewHeader",
//                                      bundle: nil),
//                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: "header")
//
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//    private func setDelegate() {
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//    }
    
    private func setUI() {
        writeButton.configuration?.image = UIImage(named: "bulletinBoardPlus")
        writeButton.spacing = 10000
    }
    
    private func setTapman() {
        self.dataSource = self
        // 바 세팅
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .regular)
                bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
                bar.buttons.customize { (button) in
                    button.tintColor = .gray3 // 선택 안되어 있을 때
                    button.selectedTintColor = .primary // 선택 되어 있을 때
                    button.font = .body1!
                    button.selectedFont = .title5!
                }
        
        //인디케이터 세팅
        bar.indicator.weight = .light
        bar.indicator.tintColor = .primary
        bar.layout.alignment = .centerDistributed
               
                bar.layout.interButtonSpacing = 24 // 버튼 사이 간격
        bar.layout.transitionStyle = .progressive// Customize
        
        let item = TMBarItem(title: "dddddddd")
        item.title = "Item 1"
        item.badgeValue = "New"
        addBar(bar, dataSource: dataSource as! TMBarDataSource, at: .custom(view: tabmanView, layout: nil))
    }
    
}

//extension BulletinBoardMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 99
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
//
//        cell.layer.cornerRadius = 20
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 335, height: 167)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 12
//    }
//
//    // 헤더의 크기를 지정하는 함수
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 10, height: 56)
//    }
//
//    // 헤더를 생성하는 함수
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            // headerView 설정 코드를 여기에 작성하세요
//
//            return headerView
//        default:
//            assert(false, "Invalid element type")
//        }
//    }
//
//}


extension BulletinBoardMainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        //        let item = TMBarItem(title: "")
        //        item.title = "Page \(index)"
        //        item.image = UIImage(named: "image.png")
        //
        //        return item
        
        // MARK: - Tab 안 글씨들
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "도와주세요")
        case 2:
            return TMBarItem(title: "함께해요")
        case 3:
            return TMBarItem(title: "나눔해요")
        case 4:
            return TMBarItem(title: "분실신고")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
    
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
    
}
