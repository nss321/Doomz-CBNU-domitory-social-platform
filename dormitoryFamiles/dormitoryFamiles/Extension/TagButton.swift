import UIKit

class RoundButton: UIButton {
    private var spacing: CGFloat = 4 {
        didSet {
            updateSpacing()
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    
    private func setupButton() {
        self.layer.masksToBounds = true
        self.setTitleColor(.red, for: .normal)
        updateSpacing()
    }
    
    private func updateSpacing() {
        let insetAmount = spacing / 2
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self.titleLabel {
            return self
        }
        return hitView
    }
}

class TagButton: RoundButton {
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layer.cornerRadius = min(self.bounds.height, 48) / 2
    }
    
    convenience init(title: String) {
        self.init()
        setUI(title: title)
    }
    
    private func setUI(title: String) {
        self.setTitle(title, for: .normal)
        self.layer.borderColor = UIColor.gray4?.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.setTitleColor(.gray4, for: .normal)
    }
    
    private func changePinkColor() {
        self.backgroundColor = .primaryMid
    }
    
    private func changeWhiteColor() {
        self.backgroundColor = .white
    }
    
    private func changeTitleGray() {
        self.setTitleColor(.gray4, for: .normal)
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
    }
}
