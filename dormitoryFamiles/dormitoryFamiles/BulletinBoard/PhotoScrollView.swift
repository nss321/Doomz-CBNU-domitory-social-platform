//
//  PhotoScrollView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/16.
//

import UIKit

class PhotoScrollView: UIScrollView {
    
    var photoStackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        layout()
    }
    

    private func layout() {
        photoStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoStackView)
        NSLayoutConstraint.activate([
            photoStackView.topAnchor.constraint(equalTo: self.topAnchor),
            photoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        //스크롤바 가리기
        self.showsHorizontalScrollIndicator = false
        photoStackView.spacing = 12
    }
    
    func addImage(image: UIImage) {
        let newImageView = AddPhotoImageView(image: image)
        photoStackView.addArrangedSubview(newImageView)
        
        NSLayoutConstraint.activate([
            newImageView.heightAnchor.constraint(equalToConstant: 80),
            newImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    

}

class AddPhotoScrollView: PhotoScrollView {
    let addPhotoButton = UIButton()
    private let cameraView = UIImageView()
    let countPictureLabel = UILabel()
    
}

