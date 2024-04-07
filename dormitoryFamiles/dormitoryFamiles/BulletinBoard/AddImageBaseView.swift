//
//  addImageBaseView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/04/01.
//

import UIKit

protocol CancelButtonTappedDelegate {
    func cancelButtonTapped()
}

final class AddImageBaseView: UIView {
    
    private let imageView: AddPhotoImageView
    private let cancelButton: UIButton
    static var cancelButtonTappedDelegate: CancelButtonTappedDelegate?
    private static var index = 0
    
    init(image: UIImage) {
        self.imageView = AddPhotoImageView(image: image)
        self.cancelButton = UIButton()
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        cancelButton.setImage(UIImage(named: "cancelButton"), for: .normal)
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
            // cancelButton constraints
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func cancelButtonTapped() {
           if let stackView = superview as? UIStackView {
               if let indexToRemove = stackView.arrangedSubviews.firstIndex(of: self) {
                   Self.index = indexToRemove
                   Self.cancelButtonTappedDelegate?.cancelButtonTapped()
                   stackView.removeArrangedSubview(self)
                   removeFromSuperview()
                   stackView.layoutIfNeeded()
               }
           }
    }
}
