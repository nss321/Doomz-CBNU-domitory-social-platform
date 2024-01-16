//
//  UIFontExtension.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/16.
//

import UIKit

@IBDesignable
extension UILabel {
    @IBInspectable var title1: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 20, text: newValue)
        }
    }
    
    @IBInspectable var title2: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 18, text: newValue)
        }
    }
    
    @IBInspectable var title3: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.semiBold.rawValue, size: 18, text: newValue)
        }
    }
    
    @IBInspectable var title4: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var title5: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.semiBold.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var subTitle1: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var subTitle2: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 14, text: newValue)
        }
    }
    
    @IBInspectable var body1: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.regular.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var body2: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.regular.rawValue, size: 14, text: newValue)
        }
    }
    
    @IBInspectable var button: String {
        get {
            return self.font.fontName
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 14, text: newValue)
        }
    }
    
    private func setAttributedFont(name: String, size: CGFloat, text: String) {
        if let newFont = UIFont(name: name, size: size) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newFont.pointSize * 0.5 // 행간 150%
            
            let attributedString = NSAttributedString(string: text, attributes: [
                .font: newFont,
                .kern: -newFont.pointSize * 0.02, // 자간 -2%
                .paragraphStyle: paragraphStyle
            ])
            
            self.attributedText = attributedString
        }
    }
}


@IBDesignable
extension UIButton {
    @IBInspectable var title1: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 20, text: newValue)
        }
    }
    
    @IBInspectable var title2: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 18, text: newValue)
        }
    }
    
    @IBInspectable var title3: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.semiBold.rawValue, size: 18, text: newValue)
        }
    }
    
    @IBInspectable var title4: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.bold.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var title5: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.semiBold.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var subTitle1: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var subTitle2: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 14, text: newValue)
        }
    }
    
    @IBInspectable var body1: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.regular.rawValue, size: 16, text: newValue)
        }
    }
    
    @IBInspectable var body2: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.regular.rawValue, size: 14, text: newValue)
        }
    }
    
    @IBInspectable var button: String {
        get {
            return self.titleLabel?.font.fontName ?? ""
        }
        set {
            setAttributedFont(name: FontPretendardGOVVariable.medium.rawValue, size: 14, text: newValue)
        }
    }
    
    private func setAttributedFont(name: String, size: CGFloat, text: String) {
        if let newFont = UIFont(name: name, size: size) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = newFont.pointSize * 0.5 // 행간 150%
            
            let attributedString = NSAttributedString(string: text, attributes: [
                .font: newFont,
                .kern: -newFont.pointSize * 0.02, // 자간 -2%
                .paragraphStyle: paragraphStyle
            ])
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

enum FontPretendardGOVVariable: String {
    case regular = "PretendardGOVVariable-Regular"
    case medium = "PretendardGOVVariable-Medium"
    case semiBold = "PretendardGOVVariable-SemiBold"
    case bold = "PretendardGOVVariable-Bold"
}
