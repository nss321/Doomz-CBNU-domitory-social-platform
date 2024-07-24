//
//  ChattingProfileStackView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit
import SnapKit

class ChattingNavigationProfileStackView: UIStackView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addArrangedSubview(profileImageView)
        addArrangedSubview(nicknameLabel)
        axis = .horizontal
        spacing = 12
        alignment = .center
    }
    
    func configure(nickname: String) {
        nicknameLabel.title2 = nickname
    }
}
