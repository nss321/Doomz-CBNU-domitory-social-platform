//
//  PriorityCell.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/10/24.
//

import UIKit
import SnapKit

class PriorityCell: UICollectionViewCell {
    static let identifier = "PriorityCell"
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray1?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let circle: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        view.layer.cornerRadius = 12
        return view
    }()
    
    let labelInCircle: UILabel = {
        let label = UILabel()
        label.font = FontManager.subtitle1()
        label.textAlignment = .center
        label.textColor = .gray1
        label.text = "1"
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = FontManager.body1()
        label.textAlignment = .center
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            container.backgroundColor = isSelected ? .primaryLight : .background
            container.layer.borderColor = isSelected ? UIColor.primaryMid?.cgColor : UIColor.gray1?.cgColor
            circle.backgroundColor = isSelected ? .primaryMid : .gray1
            labelInCircle.textColor = isSelected ? .background : .gray1
            label.textColor = isSelected ? .black : .gray5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(container)
        circle.addSubview(labelInCircle)
        [circle, label].forEach { container.addSubview($0) }
        
        container.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        labelInCircle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        circle.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(circle.snp.right).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    func selectedCell() {
        container.backgroundColor = .primaryLight
        container.layer.borderColor = UIColor.primaryMid?.cgColor
        circle.backgroundColor = .primaryMid
        labelInCircle.textColor = .background
        label.textColor = .black
    }
}

