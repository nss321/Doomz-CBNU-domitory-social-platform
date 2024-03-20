//
//  AddPhotoImageView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/20.
//

import UIKit

class AddPhotoImageView: UIImageView {
    
    override init(image: UIImage?) {
            super.init(image: image)
            cornerRadius()
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cornerRadius() {
        self.layer.masksToBounds = true;
        self.cornerRadius = 8
    }
}
