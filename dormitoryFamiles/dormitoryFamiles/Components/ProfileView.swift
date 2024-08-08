//
//  profileView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

class ProfileView: UIView, ConfigUI {
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        return label
    }()
    
    private let dormitoryLabel: UILabel = {
        let label = UILabel()
        label.text = "양진재"
        label.font = .body2
        label.textColor = .gray5
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray1
        button.setTitleColor(.gray5, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let chattingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("채팅하기", for: .normal)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
        addComponents()
        setConstraints()
    }
    
    private func setView() {
        self.layer.cornerRadius = 32
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray2?.withAlphaComponent(0.3).cgColor
    }
    
    func addComponents() {
        addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(dormitoryLabel)
        addSubview(followButton)
        addSubview(chattingButton)
    }
    
    func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        dormitoryLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        followButton.snp.makeConstraints {
            $0.top.equalTo(dormitoryLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(44)
            $0.trailing.equalTo(chattingButton.snp.leading).offset(-16)
            $0.width.equalTo(chattingButton)
        }
        
        chattingButton.snp.makeConstraints {
            $0.top.equalTo(dormitoryLabel.snp.bottom).offset(32)
            $0.trailing.equalToSuperview().offset(-28)
            $0.height.equalTo(44)
            $0.width.equalTo(followButton)
        }
    }
    
    func setData(nickName: String, profileImageUrl: URL, dormitory: String, isFollowing: Bool) {
        self.nicknameLabel.text = nickName
        self.dormitoryLabel.text = dormitory
        self.profileImageView.kf.setImage(with: profileImageUrl)
        if isFollowing {
            followButton.setTitle("팔로우중", for: .normal)
            followButton.backgroundColor = .gray1
            followButton.setTitleColor(.gray5, for: .normal)
        }else {
            followButton.setTitle("팔로우하기", for: .normal)
            followButton.backgroundColor = .primaryMid
            followButton.setTitleColor(.white, for: .normal)
        }
    }
}
