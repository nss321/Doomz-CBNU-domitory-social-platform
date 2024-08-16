//
//  ConfigUI.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/17/24.
//

import UIKit
import SnapKit

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
    
    /// Label과 StackView를 하나의 Container로 묶어서 return, 필수 항목 표시 추가
    /// - Parameters:
    ///   - string: String
    ///   - subview: UIView
    ///   - isRequired: Bool
    /// - Returns: UIstackView
    func createStackViewWithLabelAndSubview(string: String, subview: UIView, isRequired: Bool) -> UIStackView {
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
        
        let asterisk = UILabel()
        asterisk.text = "*"
        asterisk.font = FontManager.button()
        asterisk.textColor = .primary
        asterisk.addCharacterSpacing()
        
        let labelContainer = UIView()
        labelContainer.backgroundColor = .clear
        labelContainer.addSubview(label)
        
        if isRequired {
            labelContainer.addSubview(asterisk)
            asterisk.snp.makeConstraints {
                $0.left.equalTo(label.snp.right).offset(4)
                $0.top.equalToSuperview()
            }
        }
        
        stackView.addArrangedSubview(labelContainer)
        stackView.addArrangedSubview(subview)
        
        label.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
        }
        
        
        
        return stackView
    }
    
    func checkSelections(selectedItems: [String?], nextButton: CommonButton) {
        let allSelected = selectedItems.allSatisfy { $0 != nil }
        nextButton.isEnabled(allSelected)
        nextButton.backgroundColor = allSelected ? .primary : .gray3
    }
    
    func checkSelections(selectedOptions: [String?], nextButton: CommonButton) {
        if selectedOptions.count == 4 {
            nextButton.isEnabled(true)
            nextButton.backgroundColor = .primary
        } else {
            nextButton.isEnabled(false)
            nextButton.backgroundColor = .gray3
        }
    }
    
    enum PriorityCellType {
        case rect(type: IsSleepTime)
        case circle
        
        enum IsSleepTime {
            case right
            case not
        }
    }
    
    func makeSelectedSection(header: String, content: [String], tag: Int, cellType: PriorityCellType, numberOfColumns: Int, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) -> UIStackView {
        
        var stackView = UIStackView()
        
        switch cellType {
        case .rect(let type):
            let layout = UICollectionViewFlowLayout()
            let interSpacing = 8
            let width = (UIScreen.screenWidthLayoutGuide - interSpacing * (numberOfColumns-1)) / numberOfColumns - 1
            print("\(UIScreen.screenWidthLayoutGuide) \(interSpacing) \(numberOfColumns)\n\(UIScreen.screenWidthLayoutGuide-interSpacing*(numberOfColumns-1)) \(CGFloat(width))")
            print(UIScreen.cellWidth2Column)
            let height = UIScreen.cellHeight
            layout.minimumLineSpacing = CGFloat(interSpacing)
            layout.itemSize = CGSize(width: width, height: height)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            collectionView.tag = tag
            collectionView.backgroundColor = .clear
            collectionView.delegate = delegate
            collectionView.dataSource = dataSource
            collectionView.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
            
            switch type {
            case .right:
                collectionView.snp.makeConstraints {
                    $0.width.equalTo(UIScreen.screenWidthLayoutGuide)
                    $0.height.equalTo(height*3+interSpacing*2)
                }
                stackView = createStackViewWithLabelAndSubview(string: header, subview: collectionView)
            case .not:
                collectionView.snp.makeConstraints {
                    $0.width.equalTo(UIScreen.screenWidthLayoutGuide)
                    $0.height.equalTo(height)
                }
                stackView = createStackViewWithLabelAndSubview(string: header, subview: collectionView)
            }
            
        case .circle:
            let layout = UICollectionViewFlowLayout()
            let interSpacing = 16
            let diameter = UIScreen.circleCellDiameter
            layout.minimumLineSpacing = CGFloat(interSpacing)
            layout.itemSize = CGSize(width: diameter, height: diameter)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            collectionView.tag = tag
            collectionView.backgroundColor = .clear
            collectionView.delegate = delegate
            collectionView.dataSource = dataSource
            collectionView.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier)
            
            collectionView.snp.makeConstraints {
                $0.width.equalTo(UIScreen.screenWidthLayoutGuide)
                $0.height.equalTo(diameter)
            }
            stackView = createStackViewWithLabelAndSubview(string: header, subview: collectionView)
            
        }
        
        return stackView
    }
}

