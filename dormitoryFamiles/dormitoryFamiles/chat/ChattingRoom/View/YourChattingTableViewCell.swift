//
//  YourChattingTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit
import SnapKit
import Kingfisher

class YourChattingTableViewCell: UITableViewCell, ConfigUI {
    
    let cirleView = UIImageView(image: UIImage(named: "chattingDetailCircleGray"))
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }() {
        didSet {
            if let newImageView = profileImageView.image {
                oldValue.image = newImageView
            }
        }
    }
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let messageLabel: RoundLabel = {
        let label = RoundLabel(top: 8, left: 16, bottom: 8, right: 16)
        label.layer.cornerRadius = 28
        label.backgroundColor = .gray1
        label.numberOfLines = 0
        label.font = .body1
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = FontManager.small1()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        dump(profileImageView)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-15)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
            make.bottom.equalTo(timeLabel.snp.top).offset(-5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func addComponents() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(cirleView)
    }
    
    func setConstraints() {
        cirleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(7.8)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(cirleView)
            $0.leading.greaterThanOrEqualToSuperview().offset(60)
            $0.trailing.equalTo(cirleView.snp.leading)
            $0.bottom.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(messageLabel.snp.leading).inset(-8)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.chatMessage
        timeLabel.text = DateUtility.formatTime(message.sentTime)
        nicknameLabel.text = message.memberNickname
    }
}
