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
        countPictureLabel.text = "\(self.addPhotoStackView.arrangedSubviews.count)/5"
        countPictureLabel.font = .pretendardVariable
        countPictureLabel.textColor = .gray4
        countPictureLabel.textAlignment = .center
        countPictureLabel.isUserInteractionEnabled = true
    }
    
    private func setButtonComponentStackView() {
        buttonComponentStackView.addArrangedSubview(cameraView)
        buttonComponentStackView.addArrangedSubview(countPictureLabel)
        buttonComponentStackView.axis = .vertical
        addPhotoStackView.spacing = 2
        addPhotoStackView.axis = .horizontal
    }
    
    private func setAddPhotoButton() {
        addPhotoButtonView.translatesAutoresizingMaskIntoConstraints = false
        buttonComponentStackView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        addPhotoButton.isUserInteractionEnabled = true 
        addPhotoButtonView.addSubview(addPhotoButton)
        addPhotoButton.addSubview(buttonComponentStackView)
        addPhotoStackView.addArrangedSubview(addPhotoButtonView)

        NSLayoutConstraint.activate([
            buttonComponentStackView.centerXAnchor.constraint(equalTo: addPhotoButton.centerXAnchor),
            buttonComponentStackView.centerYAnchor.constraint(equalTo: addPhotoButton.centerYAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: addPhotoButtonView.bottomAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 80),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 80),
            addPhotoButtonView.widthAnchor.constraint(equalToConstant: 80),
            addPhotoButtonView.heightAnchor.constraint(equalToConstant: 90)
        ])

    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            addPhotoStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            addPhotoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addPhotoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    
    override func addImage(image: UIImage) {
        let customImageViewContainer = AddImageBaseView(image: image)
            addPhotoStackView.addArrangedSubview(customImageViewContainer)
            
            NSLayoutConstraint.activate([
                customImageViewContainer.heightAnchor.constraint(equalToConstant: 90),
                customImageViewContainer.widthAnchor.constraint(equalToConstant: 90)
            ])
    
    }
}

