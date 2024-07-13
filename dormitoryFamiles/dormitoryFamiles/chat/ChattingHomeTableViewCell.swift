//
//  ChattingHomeTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit
import Kingfisher

class ChattingHomeTableViewCell: UITableViewCell {
    static let identifier = "ChattingHomeTableViewCell"
    
    let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let imageNicknameMessageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    let nicknameMessageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let timeUnreadStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.title4()
        label.text = "nickname"
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.subtitle2()
        label.text = "message"
        label.textColor = .gray5
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.small1()
        label.text = "time"
        label.textColor = .gray3
        return label
    }()
    
    let unReadCountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.small1()
        label.backgroundColor = .primary
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func addComponents() {
        [allStackView, timeUnreadStackView, nicknameMessageStackView, imageNicknameMessageStackView].forEach {
            addSubview($0)
        }
        
        [nicknameLabel, messageLabel].forEach {
            nicknameMessageStackView.addArrangedSubview($0)
        }
        
        [profileImageView, nicknameMessageStackView].forEach {
            imageNicknameMessageStackView.addArrangedSubview($0)
        }
        
        [timeLabel, unReadCountLabel].forEach {
            timeUnreadStackView.addArrangedSubview($0)
        }
        
        [imageNicknameMessageStackView, timeUnreadStackView].forEach {
            allStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        allStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
    }
    
    private func loadImage(url: String) {
        let imageUrl = URL(string: url)
        self.profileImageView.kf.setImage(with: imageUrl)
    }
    
    func configure(memberNickname: String, memberProfileUrl:String?, unReadCount: Int, lastMessage: String, lastMessageTime: String) {
        self.nicknameLabel.text = memberNickname
        self.unReadCountLabel.text = String(unReadCount)
        self.messageLabel.text = lastMessage
        self.timeLabel.text = lastMessageTime
        if memberProfileUrl != "" {
            loadImage(url: memberProfileUrl ?? "")
        }else {
            profileImageView.image = UIImage(named: "bulletinBoardProfile")
        }
    }
}
