//
//  SleepPatternCircleCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/25/24.
//

import UIKit
import SnapKit

class SleepPatternCircleCollectionViewCell: UICollectionViewCell {
    static let identifier = "SleepPatternCircleCollectionViewCell"
    
    private let sleepTimeBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 36
        view.layer.borderColor = UIColor.gray1?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let sleepTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.subtitle1()
        label.textAlignment = .center
        label.textColor = .gray4
        label.addCharacterSpacing()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sleepTimeBlock)
        sleepTimeBlock.addSubview(sleepTimeLabel)
        
        sleepTimeBlock.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        sleepTimeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        sleepTimeLabel.text = text
    }
}


