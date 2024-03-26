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
