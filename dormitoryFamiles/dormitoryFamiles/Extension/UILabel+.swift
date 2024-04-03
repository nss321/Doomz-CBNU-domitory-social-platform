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
}
