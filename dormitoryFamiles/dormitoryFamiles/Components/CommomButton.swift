//
//  CommomButton.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/27/24.
//

import UIKit
import SnapKit

final class CommonButton: UIView {

    private var button: UIButton!
    private var model: CommonbuttonModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        clipsToBounds = true
        
        self.button = {
            let button = UIButton(type: .custom)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(self.touchUpInside), for: .touchUpInside)
            return button
        }()
        
        self.addSubview(button)
        
        self.button.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    public func setup(model: CommonbuttonModel) {
        self.model = model
        self.backgroundColor = model.backgroundColor
        self.button.setTitle(model.title, for: .normal)
        self.button.setTitleColor(model.titleColor, for: .normal)
        self.button.titleLabel?.font = model.font
        self.layer.cornerRadius = model.cornerRadius
        
        self.button.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(model.height)
        }
        
    }

    @objc private func touchUpInside() {
        self.model?.didTouchUpInside?()
    }
}

final class CommonbuttonModel: NSObject {
    var title: String?
    var font: UIFont
    var titleColor: UIColor
    var backgroundColor: UIColor
    var height: CGFloat
    var cornerRadius: CGFloat
    
    let didTouchUpInside: (() -> Void)?
    
    public init(title: String? = nil,
                font: UIFont = FontManager.button(),
                titleColor: UIColor,
                backgroundColor: UIColor,
                height: CGFloat = 52,
                cornerRadius: CGFloat = 26,
                didTouchUpInside: (() -> Void)? = nil) {
        self.title = title
        self.font = font
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.didTouchUpInside = didTouchUpInside
    }
}

final class PrimaryButton: TagButton {
    
    convenience init(title: String, isArrow: Bool) {
        self.init(title: title)
        setUI()
        if isArrow {
            self.semanticContentAttribute = .forceRightToLeft
            let spacing: CGFloat = 2.0
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
            if let arrowImage = UIImage(systemName: "arrow.right") {
                self.setImage(arrowImage, for: .normal)
            }
            self.sizeToFit()
        }
    }
    
    private func setUI() {
        self.setTitleColor(.primaryMid, for: .normal)
        self.tintColor = .primaryMid
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 255 / 255, green: 126 / 255, blue: 141 / 255, alpha: 1)
        self.titleLabel?.font = UIFont.button
    }
}
