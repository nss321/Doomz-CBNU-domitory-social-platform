//
//  UILabel+.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernalValue:Double = -0.02) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernalValue, range: NSRange(location: 0, length: string.length-1))
        attributedText = string
    }
    
    func lineSpacing(_ spacing: CGFloat) {
        guard let text = text, let font = font else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSAttributedString(string: text, attributes: [
            .font: font,
            .paragraphStyle: paragraphStyle
        ])
        self.attributedText = attributedString
    }
    
    func asColor(targetString: [String], color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        for str in targetString {
            let range = (fullText as NSString).range(of: str)
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        attributedText = attributedString
    }
}
