//
//  ConfigUI.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/17/24.
//

import Foundation
import UIKit

protocol ConfigUI {
    /// 네비게이션 바 설정
    func setupNavigationBar()
    
    /// 컴포넌트를 추가
    func addComponents()
    
    /// 위치 설정
    func setConstraints()
    
    ///  VoiceOver 설정용
    func setupAccessibility()
}

extension ConfigUI {
    func setupNavigationBar() { }
    func setupAccessibility() { }
}

extension UIViewController {
    func setupNavigationBar(_ navigationTitle: String) {
        let label = UILabel()
        label.text = navigationTitle
        label.font = FontManager.head1()
        label.textColor = .doomzBlack
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray5
        self.navigationItem.titleView = label
//        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
    }
    
}
