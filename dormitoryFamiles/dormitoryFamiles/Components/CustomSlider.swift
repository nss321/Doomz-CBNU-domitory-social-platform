//
//  CustomSlider.swift
//  dormitoryFamiles
//
//  Created by BAE on 5/23/24.
//

import UIKit

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // 트랙의 높이를 변경
        return CGRect(origin: CGPoint(x: 0, y: (bounds.height - 6) / 2), size: CGSize(width: bounds.width, height: 6))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 슬라이더 높이 변경
        let newBounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: 44)
        self.bounds = newBounds
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let thumbWidth: CGFloat = 16
        let thumbHeight: CGFloat = 16
        
        // MARK: 끝부분 잘리는 이슈 있어서, thumb의 x 포지션에서 1px을 뻄.
        let x = CGFloat(value) * (rect.width - thumbWidth) / CGFloat(maximumValue - minimumValue) - 1
        let y = rect.midY - (thumbHeight / 2)
        return CGRect(x: x, y: y, width: thumbWidth, height: thumbHeight)
    }
}
