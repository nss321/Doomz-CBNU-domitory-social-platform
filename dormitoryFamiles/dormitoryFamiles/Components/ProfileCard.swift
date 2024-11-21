//
//  ProfileCard.swift
//  dormitoryFamiles
//
//  Created by BAE on 9/4/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class ProfileCard: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .background
        self.layer.cornerRadius = 32
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray1?.cgColor
        
        [logo, nicknameLabel, userNickname, followingLabel, userFollowing, followerLabel, userFollower, informationLabel, informationNameLabel, informationAgeLabel, informationNumberLabel, informationDepartmentLabel, userName, userAge, userStudentNumber, userDepartment, lifeStyleLabel, lifeStyleBackGround, firstPreference, firstPreferenceTitle, firstPreferenceContent, secondPreference, secondPreferenceTitle, secondPreferenceContent, thirdPreference, thirdPreferenceTitle, thirdPreferenceContent, fourthPreference, fourthPreferenceTitle, fourthPreferenceContent].forEach {
            /*container.*/addSubview($0)
        }
        
        setConstraints()
    }
    
    private let logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileThumbnailImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "님"
        label.font = FontManager.body1()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let userNickname: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = FontManager.title4()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray4
        label.addCharacterSpacing()
        return label
    }()
    
    private let userFollowing: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primaryMid
        label.addCharacterSpacing()
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray4
        label.addCharacterSpacing()
        return label
    }()
    
    private let userFollower: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primaryMid
        label.addCharacterSpacing()
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 정보"
        label.font = FontManager.title5()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primary
        label.addCharacterSpacing()
        return label
    }()
    
    private let informationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let informationAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let informationNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "학번"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let informationDepartmentLabel: UILabel = {
        let label = UILabel()
        label.text = "학과"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let lifeStyleLabel: UILabel = {
        let label = UILabel()
        label.text = "선호 룸메 라이프 스타일"
        label.font = FontManager.title5()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primary
        label.addCharacterSpacing()
        return label
    }()
    
    private let lifeStyleBackGround: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        view.layer.cornerRadius = 24
        return view
    }()

    private let firstPreference = UIImageView().then {
        $0.image = UIImage(named: "profileThumbnailImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let firstPreferenceTitle = UILabel().then {
        $0.text = "청소"
        $0.font = FontManager.subtitle2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let firstPreferenceContent = UILabel().then {
        $0.text = "매일매일"
        $0.font = FontManager.body2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let secondPreference = UIImageView().then {
        $0.image = UIImage(named: "profileThumbnailImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let secondPreferenceTitle = UILabel().then {
        $0.text = "소리"
        $0.font = FontManager.subtitle2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let secondPreferenceContent = UILabel().then {
        $0.text = "무음"
        $0.font = FontManager.body2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let thirdPreference = UIImageView().then {
        $0.image = UIImage(named: "profileThumbnailImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let thirdPreferenceTitle = UILabel().then {
        $0.text = "본가주기"
        $0.font = FontManager.subtitle2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let thirdPreferenceContent = UILabel().then {
        $0.text = "2달에 한번"
        $0.font = FontManager.body2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let fourthPreference = UIImageView().then {
        $0.image = UIImage(named: "profileThumbnailImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let fourthPreferenceTitle = UILabel().then {
        $0.text = "공부"
        $0.font = FontManager.subtitle2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let fourthPreferenceContent = UILabel().then {
        $0.text = "기숙사"
        $0.font = FontManager.body2()
        $0.textColor = .gray5
        $0.textAlignment = .center
        $0.addCharacterSpacing()
    }
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.textColor = .gray5
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let userAge: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.textColor = .gray5
        return label
    }()
    
    private let userStudentNumber: UILabel = {
        let label = UILabel()
        label.text = "24"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.textColor = .gray5
        return label
    }()
    
    private let userDepartment: UILabel = {
        let label = UILabel()
        label.text = "정보통신공학부"
        label.font = FontManager.subtitle2()
        label.textAlignment = .center
        label.textColor = .gray5
        return label
    }()
    
    
    let typePreferredButton = CommonButton()
    
    private func setConstraints() {
        logo.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.left.equalToSuperview().inset(20)
        }
        
        userNickname.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.left.equalTo(logo.snp.right).offset(12)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.bottom.equalTo(userNickname.snp.bottom)
            $0.left.equalTo(userNickname.snp.right).offset(6)
        }
        
        userFollowing.snp.makeConstraints {
            $0.bottom.equalTo(logo.snp.bottom).inset(6)
            $0.left.equalTo(userNickname.snp.left)
        }
        
        followingLabel.snp.makeConstraints {
            $0.bottom.equalTo(userFollowing.snp.bottom)
            $0.left.equalTo(userFollowing.snp.right).offset(4)
        }
        
        userFollower.snp.makeConstraints {
            $0.bottom.equalTo(userFollowing.snp.bottom)
            $0.left.equalTo(followingLabel.snp.right).offset(20)
            
        }
        
        followerLabel.snp.makeConstraints {
            $0.bottom.equalTo(userFollowing.snp.bottom)
            $0.left.equalTo(userFollower.snp.right).offset(4)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(24)
            $0.left.equalTo(logo.snp.left)
        }
        
        informationNameLabel.snp.makeConstraints {
            $0.left.equalTo(informationLabel.snp.left)
            $0.top.equalTo(informationLabel.snp.bottom).offset(16)
        }
        
        informationAgeLabel.snp.makeConstraints {
            $0.left.equalTo(informationNameLabel.snp.right).offset(60)
            $0.centerY.equalTo(informationNameLabel.snp.centerY)
        }
        
        informationNumberLabel.snp.makeConstraints {
            $0.left.equalTo(informationAgeLabel.snp.right).offset(40)
            $0.centerY.equalTo(informationNameLabel.snp.centerY)
        }
        
        informationDepartmentLabel.snp.makeConstraints {
            $0.left.equalTo(informationLabel.snp.left)
            $0.top.equalTo(informationNameLabel.snp.bottom).offset(8)
        }
        
        lifeStyleLabel.snp.makeConstraints {
            $0.left.equalTo(informationLabel.snp.left)
            $0.top.equalTo(informationDepartmentLabel.snp.bottom).offset(24)
        }
        
        lifeStyleBackGround.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lifeStyleLabel.snp.bottom).offset(12)
            $0.width.equalTo(Double(UIScreen.currentScreenWidth) * 0.786)
            $0.height.equalTo(Double(UIScreen.currentScreenHeight) * 0.15)
        }
        
        firstPreference.snp.makeConstraints {
            $0.top.left.equalTo(lifeStyleBackGround).inset(12)
            $0.width.height.equalTo(Double(UIScreen.currentScreenWidth) * 0.117)
        }
        
        firstPreferenceTitle.snp.makeConstraints {
            $0.left.equalTo(firstPreference.snp.right).offset(4)
            $0.top.equalTo(firstPreference.snp.top).offset(4)
        }
        
        firstPreferenceContent.snp.makeConstraints {
            $0.left.equalTo(firstPreferenceTitle.snp.left)
            $0.bottom.equalTo(firstPreference.snp.bottom).inset(4)
        }
        
        // StackView 쓰는게 낫나?
        secondPreference.snp.makeConstraints {
            $0.top.equalTo(lifeStyleBackGround).inset(12)
            // lifeStyleBackground width의 절반 + 7px
            $0.left.equalTo(lifeStyleBackGround.snp.left).offset(Double(UIScreen.currentScreenWidth) * 0.393 + 7)
            $0.width.height.equalTo(Double(UIScreen.currentScreenWidth) * 0.117)
        }
        
        secondPreferenceTitle.snp.makeConstraints {
            $0.left.equalTo(secondPreference.snp.right).offset(4)
            $0.top.equalTo(secondPreference.snp.top).offset(4)
        }
        
        secondPreferenceContent.snp.makeConstraints {
            $0.left.equalTo(secondPreferenceTitle.snp.left)
            $0.bottom.equalTo(secondPreference.snp.bottom).inset(4)
        }

        thirdPreference.snp.makeConstraints {
            $0.bottom.left.equalTo(lifeStyleBackGround).inset(12)
            $0.width.height.equalTo(Double(UIScreen.currentScreenWidth) * 0.117)
        }
        
        thirdPreferenceTitle.snp.makeConstraints {
            $0.left.equalTo(thirdPreference.snp.right).offset(4)
            $0.top.equalTo(thirdPreference.snp.top).offset(4)
        }
        
        thirdPreferenceContent.snp.makeConstraints {
            $0.left.equalTo(thirdPreferenceTitle.snp.left)
            $0.bottom.equalTo(thirdPreference.snp.bottom).inset(4)
        }

        fourthPreference.snp.makeConstraints {
            $0.left.equalTo(secondPreference.snp.left)
            $0.bottom.equalTo(thirdPreference.snp.bottom)
            $0.width.height.equalTo(Double(UIScreen.currentScreenWidth) * 0.117)
        }
        
        fourthPreferenceTitle.snp.makeConstraints {
            $0.left.equalTo(fourthPreference.snp.right).offset(4)
            $0.top.equalTo(fourthPreference.snp.top).offset(4)
        }
        
        fourthPreferenceContent.snp.makeConstraints {
            $0.left.equalTo(fourthPreferenceTitle.snp.left)
            $0.bottom.equalTo(fourthPreference.snp.bottom).inset(4)
        }
        
        userName.snp.makeConstraints {
            $0.left.equalTo(informationNameLabel.snp.right).offset(8)
            $0.width.equalTo(Double(UIScreen.currentScreenWidth) * 0.128)
            $0.centerY.equalTo(informationNameLabel)
        }
        
        userAge.snp.makeConstraints {
            $0.left.equalTo(informationAgeLabel.snp.right).offset(8)
            $0.centerY.equalTo(informationAgeLabel)
        }

        userStudentNumber.snp.makeConstraints {
            $0.left.equalTo(informationNumberLabel.snp.right).offset(8)
            $0.centerY.equalTo(informationNumberLabel)
        }
        
        userDepartment.snp.makeConstraints {
            $0.left.equalTo(informationDepartmentLabel.snp.right).offset(8)
            $0.centerY.equalTo(informationDepartmentLabel)
        }
    
    }
    
    func setup(_ profile: MatchedUser) {
        self.userNickname.text = profile.nickname
        self.userFollowing.text = String(profile.followingCount)
        self.userFollower.text = String(profile.followerCount)
        self.userName.text = profile.name
        self.userAge.text = String(profile.calculateAge())
        self.userStudentNumber.text = profile.studentNumber
        self.userDepartment.text = profile.departmentType
//        self.firstPreference.text = profile.
        
        if let profileImageUrl = URL(string: profile.profileUrl) {
            self.logo.kf.setImage(with: profileImageUrl)
        }
    }
}
