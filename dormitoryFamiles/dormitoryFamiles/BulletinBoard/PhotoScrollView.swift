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
            newImageView.heightAnchor.constraint(equalToConstant: 100),
            newImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    

}

class AddPhotoScrollView: PhotoScrollView {
    let addPhotoButton = UIButton()
    private let cameraView = UIImageView()
    let countPictureLabel = UILabel()
    private let buttonComponentStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setCameraView()
        setCountPictureLabel()
        setAddPhotoButton()
        setButtonComponentStackView()
        photoStackView.addArrangedSubview(addPhotoButton)
    }
    
    private func setCameraView() {
        cameraView.image = UIImage(systemName: "camera")
        cameraView.tintColor = .black
        cameraView.isUserInteractionEnabled = true
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.heightAnchor.constraint(equalToConstant: 29),
            cameraView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setCountPictureLabel() {
        countPictureLabel.text = "\(self.photoStackView.arrangedSubviews.count)/10"
        countPictureLabel.font = .pretendardVariable
        countPictureLabel.textColor = .gray4
        countPictureLabel.textAlignment = .center
        countPictureLabel.isUserInteractionEnabled = true
    }
    
    private func setButtonComponentStackView() {
        photoStackView.addArrangedSubview(cameraView)
        photoStackView.addArrangedSubview(countPictureLabel)
        photoStackView.spacing = 5
        photoStackView.axis = .vertical
    }
    
    private func setAddPhotoButton() {
        buttonComponentStackView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.addSubview(buttonComponentStackView)
        
        NSLayoutConstraint.activate([
            buttonComponentStackView.centerXAnchor.constraint(equalTo: addPhotoButton.centerXAnchor),
            buttonComponentStackView.centerYAnchor.constraint(equalTo: addPhotoButton.centerYAnchor)
        ])
    }
}

