//
//  profileView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/8/24.
//
import UIKit
import SnapKit
import Kingfisher

protocol ProfileViewDelegate: AnyObject {
    func chattingButtonTapped(memberId: Int)
    func followingButtonTapped(memberId: Int)
}

class ProfileView: UIView, ConfigUI {
    weak var delegate: ProfileViewDelegate?
    
    //mvc모델의 ProfileView는 view에서 memberId는 데이터쪽이지만, 데이터를 변경하지 않는 이상 필요한 데이터는 저장해도 된다고 판단하였습니다.
    private var memberId: Int?
    
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
        button.addTarget(self, action: #selector(followingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let chattingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("채팅하기", for: .normal)
        button.backgroundColor = .primary
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(chattingButtonTapped), for: .touchUpInside)
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
            $0.height.equalTo(48)
            $0.trailing.equalTo(chattingButton.snp.leading).offset(-16)
            $0.width.equalTo(chattingButton)
        }
        
        chattingButton.snp.makeConstraints {
            $0.top.equalTo(dormitoryLabel.snp.bottom).offset(32)
            $0.trailing.equalToSuperview().offset(-28)
            $0.height.equalTo(48)
            $0.width.equalTo(followButton)
        }
    }
    
    func setData(memberId: Int, nickName: String, profileImageUrl: URL, dormitory: String, isFollowing: Bool) {
           self.memberId = memberId // 멤버 ID 저장
           self.nicknameLabel.text = nickName
           self.dormitoryLabel.text = dormitory
           self.profileImageView.kf.setImage(with: profileImageUrl)
           if isFollowing {
               followButton.setTitle("팔로우", for: .normal)
               followButton.backgroundColor = .gray1
               followButton.setTitleColor(.gray5, for: .normal)
           } else {
               followButton.setTitle("팔로우하기", for: .normal)
               followButton.backgroundColor = .primaryMid
               followButton.setTitleColor(.white, for: .normal)
           }
       }
       
       @objc private func chattingButtonTapped() {
           if let memberId = memberId {
               delegate?.chattingButtonTapped(memberId: memberId) // 멤버 ID 전달
           }
       }
    
    @objc private func followingButtonTapped() {
        if let memberId = memberId {
            delegate?.followingButtonTapped(memberId: memberId) // 멤버 ID 전달
        }
    }
}
