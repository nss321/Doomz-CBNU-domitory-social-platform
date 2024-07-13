//
//  ChatFollowingCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit

class UserProfileNicknameCollectionViewControllerCell: UICollectionViewCell {
    static let identifier = "ChatFollowingCollectionViewCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bulletinBoardProfile")
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.small1()
        label.text = "닉네임"
        label.textAlignment = .center
        label.textColor = .gray3
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(stackView)
        [profileImageView, nicknameLabel].forEach{
            stackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadImage(url: String) {
        let imageUrl = URL(string: url)
        self.profileImageView.kf.setImage(with: imageUrl)
    }
    
    func configure(text: String, profileUrl: String) {
        nicknameLabel.text = text
        loadImage(url: profileUrl)
    }
}
