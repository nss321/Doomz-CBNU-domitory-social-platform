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
    /// String을 param으로 받아서 지정된 서식에 따라 Navigation Title로 설정
    func setupNavigationBar(_ navigationTitle: String) {
        let label = UILabel()
        label.text = navigationTitle
        label.font = FontManager.head1()
        label.textColor = .doomzBlack
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray5
        self.navigationItem.titleView = label
    }
    
    /// Label과 StackView를 하나의 Container로 묶어서 return
    /// - Parameters:
    ///   - string: String
    ///   - subview: UIView
    /// - Returns: UIstackView
    func createStackViewWithLabelAndSubview(string: String, subview: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        let label = UILabel()
        label.text = string
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(subview)
        
        return stackView
    }
    
    func checkSelections(selectedItems: [String?], nextButton: CommonButton) {
        let allSelected = selectedItems.allSatisfy { $0 != nil }
        nextButton.isEnabled(allSelected)
        nextButton.backgroundColor = allSelected ? .primary : .gray3
    }
    
    func checkSelctions(selectedOptions: [String?], nextButton: CommonButton) {
        if selectedOptions.count == 4 {
            nextButton.isEnabled(true)
            nextButton.backgroundColor = .primary
        } else {
            nextButton.isEnabled(false)
            nextButton.backgroundColor = .gray3
        }
    }
}

