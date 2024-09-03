//
//  SleepPatternCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/18/24.
//

import UIKit
import SnapKit

class SleepPatternCollectionViewCell: UICollectionViewCell {
    static let identifier = "SleepPatternCollectionViewCell"
    
    private let sleepTimeBlock: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray1?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let sleepTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.body1()
        label.textAlignment = .center
        label.textColor = .gray4
        label.addCharacterSpacing()
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                sleepTimeBlock.backgroundColor = .secondary
                sleepTimeBlock.layer.borderColor = UIColor.primaryMid?.cgColor
                sleepTimeLabel.textColor = .primary
            } else {
                sleepTimeBlock.backgroundColor = .background
                sleepTimeBlock.layer.borderColor = UIColor.gray1?.cgColor
                sleepTimeLabel.textColor = .gray4
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sleepTimeBlock)
        sleepTimeBlock.addSubview(sleepTimeLabel)
        
        sleepTimeBlock.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        sleepTimeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        sleepTimeLabel.text = text
    }
}
