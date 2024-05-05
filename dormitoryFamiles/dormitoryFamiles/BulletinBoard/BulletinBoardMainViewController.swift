//
//  bulletinBoardMainViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/01.
//
import Tabman
import Pageboy
import UIKit
import DropDown

final class BulletinBoardMainViewController: TabmanViewController, DormitoryButtonHandling {
    enum Sort: String {
        case createdAt = "createdAt"
        case popularity = "popularity"
    }

    enum Status: String {
        case ing = "모집중"
        case finish = "모집완료"
    }
    
    private var viewControllers: [BrownVC] {
        let allVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        allVC.path = Url.pathAllPostUrl
        
        let helpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        helpVC.path = Url.helpPostUrl
        
        let togetherVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        togetherVC.path = Url.togetherUrl
        
        let shareVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        shareVC.path = Url.shareUrl
        
        let lostVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "brownVC") as! BrownVC
        lostVC.path = Url.lostUrl
        
        return [allVC, helpVC, togetherVC, shareVC, lostVC]
    }
    let dropDown = DropDown()
    @IBOutlet weak var naviCustomView: UIView!
    
    @IBOutlet weak var tabmanView: UIView!
    @IBOutlet weak var writeButton: TagButton!
    
    @IBOutlet weak var sortListButton: UIButton!
    @IBOutlet weak var filterListButton: UIButton!
    @IBOutlet weak var dormitoryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTapman()
        setTintAdjustmentModeForButtons(in: self.view)
        setObserver()
        setDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    private func setUI() {
        writeButton.configuration?.image = UIImage(named: "bulletinBoardPlus")
    }
    
    private func setDropDown() {
        DropDown.startListeningToKeyboard()
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0
        DropDown.appearance().selectionBackgroundColor = .gray0 ?? .white
        DropDown.appearance().textFont = .pretendard14Variable ?? .init()
        DropDown.appearance().textColor = .gray4 ?? .gray
    }
    
    @objc func dormitoryChangeNotification(_ notification: Notification) {
        if notification.object is String {
            dormitoryButton.head1 = SelectedDormitory.shared.domitory
            dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
            dormitoryButton.isUserInteractionEnabled = true
        }
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dormitoryChangeNotification(_:)), name: .init("DormitoryChangeNotification"), object: nil)
    }
    
    private func setTintAdjustmentModeForButtons(in view: UIView) {
        //받아온 뷰를 돌며 타입이 버튼이거나 버튼을 상속받은 엘리먼트들만
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.tintAdjustmentMode = .normal
            }
            //버튼이 아니라면 그 내부를 또 탐색
            setTintAdjustmentModeForButtons(in: subview)
        }
    }
    
    func updateUrl(_ sender: String) {
        for vc in viewControllers {
            var newUrl = vc.path
            
            switch sender {
            case "최신순":
                newUrl = newUrl.replacingOccurrences(of: Sort.popularity.rawValue, with: Sort.createdAt.rawValue)
            case "인기순":
                newUrl = newUrl.replacingOccurrences(of: Sort.createdAt.rawValue, with: Sort.popularity.rawValue)
            case "전체":
                newUrl = newUrl.replacingOccurrences(of: "status=\(Status.ing.rawValue)", with: "")
                newUrl = newUrl.replacingOccurrences(of: "status=\(Status.finish.rawValue)", with: "")
            case "모집중":
                newUrl += vc.path.contains("?") ? "&status=\(Status.ing.rawValue)" : "?status=\(Status.ing.rawValue)"
            case "모집완료":
                newUrl += vc.path.contains("?") ? "&status=\(Status.finish.rawValue)" : "?status=\(Status.finish.rawValue)"
            default:
                break
            }
            
            vc.path = newUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        viewControllers.forEach { print($0.path) }
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
    

    
    @IBAction func dormitoryButtonTapped(_ sender: UIButton) {
        presentSheet()
    }
    
    
    @IBAction func sortList(_ sender: UIButton) {
        showDropDown(sender)
    }
    

    func showDropDown(_ sender: UIButton) {
        //버튼에 따라 데이터 소스 세팅
        switch sender.titleLabel?.text ?? ""{
        case "최신순", "인기순":
            dropDown.dataSource = ["최신순", "인기순"]
        case "전체", "모집중":
            dropDown.dataSource = ["전체", "모집중"]
        default:
            dropDown.dataSource = []
        }
        
        //공통으로 dropdown을 보여주기 위한 코드
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            //item 선택시 -> 1. 버튼의 title변경, 2. 해당 url세팅
            sender.body2 = item
            self.updateUrl(item)
        }
    }
}



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
            return TMBarItem(title: "궁금해요")
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
