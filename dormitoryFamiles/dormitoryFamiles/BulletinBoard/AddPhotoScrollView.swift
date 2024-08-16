//
//  AddPhotoScrollView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/11/24.
//

import UIKit

class AddPhotoScrollView: UIScrollView {
    let addPhotoStackView = UIStackView()
    let addPhotoButton = UIButton()
    let countPictureLabel = UILabel()
    let maximumPhotoNumber = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
    }
    
    private func setupScrollView() {
        addPhotoStackView.axis = .horizontal
        addPhotoStackView.spacing = 8
        addPhotoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addPhotoStackView)
        
        addPhotoStackView.addArrangedSubview(addPhotoButton)
        addPhotoStackView.addArrangedSubview(countPictureLabel)
        
        addPhotoButton.setImage(UIImage(systemName: "camera"), for: .normal)
        countPictureLabel.text = "0/\(maximumPhotoNumber)"
        
        NSLayoutConstraint.activate([
            addPhotoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addPhotoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            addPhotoStackView.topAnchor.constraint(equalTo: topAnchor),
            addPhotoStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 88),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    func addImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        addPhotoStackView.insertArrangedSubview(imageView, at: addPhotoStackView.arrangedSubviews.count - 1)
    }
}
