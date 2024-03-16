//
//  SleepPatternViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit
import Snapkit

final class SleepPatternViewController: UIViewController {
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 수면 패턴은?"
        label.font = FontManager.body()
        label.textColor = .gs10
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "긱사생활 설정"
        label.font = FontManager.head1()
        label.textColor = .gs20
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupNavigationBar() {
        view.addSubview(naviLine)
        naviLine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(106)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.33)
        }
        self.navigationController?.navigationBar.tintColor = .gs20
        self.navigationItem.titleView = self.navigationTitle
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
    }
}
