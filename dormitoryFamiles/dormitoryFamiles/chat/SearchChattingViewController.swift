//
//  SearchChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit
import Tabman
import Pageboy
import SnapKit

class SearchChattingViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] {
        let allVC = AllViewController()
        
        let followingVC = FollowingViewController()
        
        let allDoomzVC = AllDoomzViewController()
        
        let chattingRoomVC = ChattingRoomViewController()
        
        let messageVC = MessagegViewController()
        
        return [allVC, followingVC, allDoomzVC, chattingRoomVC, messageVC]
    }
    
    private let tabmanView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let navigationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력해주세요."
        textField.font = .subTitle2
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private let baseLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        setTabman()
        addComponents()
        setConstraints()
    }
    
    private func setNavigationBar() {
        let containerView = RoundLabel()
        containerView.backgroundColor = .gray0
        containerView.isUserInteractionEnabled = true

        navigationItem.titleView = containerView
        
        containerView.addSubview(navigationTextField)
        navigationTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
    }
    
    private func setTabman() {
        self.dataSource = self
        // 바 세팅
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .regular)
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
        bar.layout.contentMode = .intrinsic
        
        bar.layout.interButtonSpacing = 24 // 버튼 사이 간격
        bar.layout.transitionStyle = .progressive// Customize
        
        addBar(bar, dataSource: dataSource as! TMBarDataSource, at: .custom(view: tabmanView, layout: nil))
    }
    
    private func addComponents() {
        self.view.addSubview(tabmanView)
        self.view.addSubview(baseLineView)
    }
    
    private func setConstraints() {
        tabmanView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(38)
        }
        
        baseLineView.snp.makeConstraints {
            $0.top.equalTo(tabmanView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension SearchChattingViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "팔로잉")
        case 2:
            return TMBarItem(title: "전체 둠즈")
        case 3:
            return TMBarItem(title: "채팅방")
        case 4:
            return TMBarItem(title: "메세지")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}
