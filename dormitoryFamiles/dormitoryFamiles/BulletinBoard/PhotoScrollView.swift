//
//  PhotoScrollView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/16.
//

import UIKit


class PhotoScrollView: UIScrollView {
    var addPhotoStackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func layout() {
        addPhotoStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addPhotoStackView)
        NSLayoutConstraint.activate([
            addPhotoStackView.topAnchor.constraint(equalTo: self.topAnchor),
            addPhotoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addPhotoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addPhotoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        //스크롤바 가리기
        self.showsHorizontalScrollIndicator = false
        addPhotoStackView.spacing = 12
    }
    
    func addImage(image: UIImage) {
        let newImageView = AddPhotoImageView(image: image)
        addPhotoStackView.addArrangedSubview(newImageView)
        
        NSLayoutConstraint.activate([
            newImageView.heightAnchor.constraint(equalToConstant: 100),
            newImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    

}

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
