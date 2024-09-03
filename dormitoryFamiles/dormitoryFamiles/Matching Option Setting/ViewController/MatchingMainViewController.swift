//
//  MatchingMainViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/15/24.
//

import UIKit
import SnapKit

final class MatchingMainViewController: UIViewController, ConfigUI {
    
    private let recommendedMatesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recommendedMates"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let requestListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "requestList"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let doomzListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "doomzList"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("룸메매칭")
        addComponents()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addComponents() {
        recommendedMatesButton.addTarget(self, action: #selector(button1), for: .touchUpInside)
        requestListButton.addTarget(self, action: #selector(button2), for: .touchUpInside)
        doomzListButton.addTarget(self, action: #selector(button3), for: .touchUpInside)
        [recommendedMatesButton, requestListButton, doomzListButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        recommendedMatesButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(43)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.screenWidthLayoutGuide)
            $0.height.equalTo(recommendedMatesButton.snp.width).multipliedBy(0.77)
        }
        
        requestListButton.snp.makeConstraints {
            $0.top.equalTo(recommendedMatesButton.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo((UIScreen.screenWidthLayoutGuide-16)/2)
            $0.height.equalTo(requestListButton.snp.width).multipliedBy(1.6)
        }
        
        doomzListButton.snp.makeConstraints {
            $0.top.equalTo(requestListButton.snp.top)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(requestListButton.snp.width)
            $0.height.equalTo(requestListButton.snp.height)
        }
    }
    
    @objc func button1() {
        print("1탭")
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(SleepPatternViewController(), animated: true)
    }
    @objc func button2() {
        print("2탭")
    }
    @objc func button3() {
        print("3탭")
    }
    
    
}
