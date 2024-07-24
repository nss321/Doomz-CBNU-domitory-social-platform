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

final class PrimaryMidRoundButton: TagButton {
    
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
class RoundLabel: UILabel {
    
    private var topInset: CGFloat = 4
    private var leftInset: CGFloat = 8
    private var bottomInset: CGFloat = 4
    private var rightInset: CGFloat = 8
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let width = originalContentSize.width + leftInset + rightInset
        let height = originalContentSize.height + topInset + bottomInset
        return CGSize(width: width, height: height)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.bounds.height, 48) / 2
        self.layer.masksToBounds = true
    }
    
    convenience init(title: String) {
        self.init()
        setUI(title: title)
        self.textAlignment = .left
        self.contentMode = .center
    }
    
    convenience init(top: Int, left: Int, bottom: Int, right: Int) {
        self.init()
        setSize(top: top, left: left, bottom: bottom, right: right)
        self.textAlignment = .left
        self.contentMode = .center
    }
    
    private func setUI(title: String) {
        self.text = title
        self.layer.masksToBounds = true
        
    }
    
    private func setSize(top: Int, left: Int, bottom: Int, right: Int) {
        self.topInset = CGFloat(top)
        self.leftInset = CGFloat(left)
        self.bottomInset = CGFloat(bottom)
        self.rightInset = CGFloat(right)
        self.invalidateIntrinsicContentSize()
        setNeedsDisplay()
    }
}

class DropdownButton: UIButton {
       init(frame: CGRect, title: String) {
           super.init(frame: frame)
           setupButton(title: title)
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupButton(title: "최신순")
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           self.layer.cornerRadius = min(self.bounds.height, 48) / 2
           self.layer.masksToBounds = true
       }

       private func setupButton(title: String) {
           self.body2 = title
           self.setTitleColor(.black, for: .normal)
           self.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
           self.layer.borderWidth = 1
           self.setTitleColor(.gray, for: .normal)
           self.setImage(UIImage(named: "bulletinBoardVector"), for: .normal)
           let spacing: CGFloat = 5
           self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
           self.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
           self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
           self.semanticContentAttribute = .forceRightToLeft
       }
}
