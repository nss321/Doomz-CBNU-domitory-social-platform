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
    let addPhotoButtonView = UIView()
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
        setButtonComponentStackView()
        setAddPhotoButton()
        setLayout()
        addImage(image: UIImage(named: "registerCamera")!)
    }
    
    private func setCameraView() {
        cameraView.image = UIImage(named: "registerCamera")
        cameraView.tintColor = .black
        cameraView.isUserInteractionEnabled = true
        
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.heightAnchor.constraint(equalToConstant: 24),
            cameraView.widthAnchor.constraint(equalToConstant: 28)
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
        buttonComponentStackView.addArrangedSubview(cameraView)
        buttonComponentStackView.addArrangedSubview(countPictureLabel)
        buttonComponentStackView.axis = .vertical
        photoStackView.spacing = 12
        photoStackView.axis = .horizontal
    }
    
    private func setAddPhotoButton() {
        addPhotoButtonView.translatesAutoresizingMaskIntoConstraints = false
        buttonComponentStackView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        addPhotoButtonView.addSubview(addPhotoButton)
        addPhotoButton.addSubview(buttonComponentStackView)
        photoStackView.addArrangedSubview(addPhotoButtonView)

        NSLayoutConstraint.activate([
            buttonComponentStackView.centerXAnchor.constraint(equalTo: addPhotoButton.centerXAnchor),
            buttonComponentStackView.centerYAnchor.constraint(equalTo: addPhotoButton.centerYAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: addPhotoButtonView.bottomAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 80),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 80),
            addPhotoButtonView.widthAnchor.constraint(equalToConstant: 80),
            addPhotoButtonView.heightAnchor.constraint(equalToConstant: 88)
        ])

    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            photoStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            photoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoStackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    
//    override func addImage(image: UIImage) {
//        let newImageView = AddPhotoImageView(image: image)
//        let baseView = UIView()
//        let cancelButton = UIButton()
//
//        cancelButton.setImage(UIImage(named: <#T##String#>), for: <#T##UIControl.State#>)
//
//        baseView.addSubview(newImageView)
//        photoStackView.addArrangedSubview(baseView)
//    }
}
