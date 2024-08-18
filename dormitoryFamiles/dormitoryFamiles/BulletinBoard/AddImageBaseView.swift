//
//  addImageBaseView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/04/01.
//

import UIKit

protocol CancelButtonTappedDelegate: AnyObject {
    func cancelButtonTapped(id: Int)
}

final class AddImageBaseView: UIView {

    private let imageView: AddPhotoImageView
    private let cancelButton: UIButton
    static weak var cancelButtonTappedDelegate: CancelButtonTappedDelegate?
    let id: Int

    init(image: UIImage, id: Int) {
        self.imageView = AddPhotoImageView(image: image)
        self.cancelButton = UIButton()
        self.id = id
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.isUserInteractionEnabled = true
        
        addSubview(imageView)
        addSubview(cancelButton)
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            cancelButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            cancelButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        Self.cancelButtonTappedDelegate?.cancelButtonTapped(id: self.id)
        removeFromSuperview()
    }
}
