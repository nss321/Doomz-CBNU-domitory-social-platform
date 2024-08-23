//
//  UIButton+.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import Foundation
import UIKit

extension UIButton {
    
    func makeSquare(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIButton {
        self.layer.borderColor = .init(red: 179/255, green: 179/255, blue: 179/255, alpha: 0.39)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height),
        ])
        return self
    }
    
    func makeCircle(size: CGFloat, title: String, BackgroundColor: UIColor) -> UIButton {
        self.layer.cornerRadius = size/2
        self.clipsToBounds = true
        self.backgroundColor = BackgroundColor
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size),
        ])
        return self
    }
    
    func alignTextBelow(spacing: CGFloat = 4.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}
