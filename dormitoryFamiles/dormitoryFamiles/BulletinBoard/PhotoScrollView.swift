//
//  PhotoScrollView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/16.
//

import UIKit

//게시판 디테일(get 포토)
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

//게시판 사진등록(post 포토)
class AddPhotoScrollView: UIScrollView {
    let addPhotoStackView = UIStackView()
    let addPhotoButton = UIButton()
    let countPictureLabel = UILabel()
    let maximumPhotoNumber = 5
    let baseButtonView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
    }
    
    private func setupScrollView() {
        self.showsHorizontalScrollIndicator = false
        addPhotoStackView.axis = .horizontal
        addPhotoStackView.spacing = 8
        addPhotoStackView.translatesAutoresizingMaskIntoConstraints = false
        baseButtonView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addPhotoStackView)
        addSubview(baseButtonView)
        addSubview(addPhotoButton)
        
        addPhotoStackView.addArrangedSubview(baseButtonView)
        addPhotoStackView.addArrangedSubview(countPictureLabel)
        
        addPhotoButton.layer.cornerRadius = 8
        addPhotoButton.clipsToBounds = true
        addPhotoButton.backgroundColor = .gray0
        addPhotoButton.tintColor = .gray4
        addPhotoButton.titleLabel?.font = FontManager.subtitle1()
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named: "registerCamera")
            config.title = "0/\(maximumPhotoNumber)"
            config.imagePlacement = .top
            config.imagePadding = 0
            addPhotoButton.configuration = config
        } else {
            addPhotoButton.setImage(UIImage(named: "registerCamera"), for: .normal)
            addPhotoButton.setTitle("0/\(maximumPhotoNumber)", for: .normal)
            addPhotoButton.setTitleColor(.black, for: .normal)
            addPhotoButton.alignTextBelow(spacing: 0)
        }
        
        NSLayoutConstraint.activate([
            addPhotoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addPhotoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            addPhotoStackView.topAnchor.constraint(equalTo: topAnchor),
            addPhotoStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseButtonView.widthAnchor.constraint(equalToConstant: 80),
            baseButtonView.heightAnchor.constraint(equalToConstant: 90),
            baseButtonView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 80),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 80),
            addPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addImage(image: UIImage, id: Int) {
        let baseView = AddImageBaseView(image: image, id: id)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        baseView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        addPhotoStackView.addArrangedSubview(baseView)
    }
}
