//
//  ChattingHomeTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit
import SnapKit
import Kingfisher

class ChattingHomeTableViewCell: UITableViewCell {
    static let identifier = "ChattingHomeTableViewCell"
    
    let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
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
        stackView.alignment = .trailing
        return stackView
    }()
    
    let profileImageView: UIImageView = UIImageView()
    
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
    
    let unReadCountLabel: RoundLabel = {
        let label = RoundLabel(title: "")
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
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        
        guard let intUnReadCount = Int(unReadCountLabel.text ?? "") else {return}
        
        if intUnReadCount == 0 {
            unReadCountLabel.backgroundColor = .white
        }
    }
    
    private func addComponents() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(allStackView)
        
        nicknameMessageStackView.addArrangedSubview(nicknameLabel)
        nicknameMessageStackView.addArrangedSubview(messageLabel)
        
        timeUnreadStackView.addArrangedSubview(timeLabel)
        timeUnreadStackView.addArrangedSubview(unReadCountLabel)
        
        allStackView.addArrangedSubview(nicknameMessageStackView)
        allStackView.addArrangedSubview(timeUnreadStackView)
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12).priority(.high)
            $0.leading.equalToSuperview().inset(25)
            $0.height.width.equalTo(48).priority(.required)
        }
        
        allStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(25)
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
        self.timeLabel.text = DateUtility.chattingTimeFormet(from: lastMessageTime)
        
        if memberProfileUrl != "" {
            loadImage(url: memberProfileUrl ?? "")
        } else {
            profileImageView.image = UIImage(named: "bulletinBoardProfile")
        }
    }
    
    func highlightKeyword(keyword: String) {
        guard let messageText = messageLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: messageText)
        let range = (messageText as NSString).range(of: keyword)
        guard range.length > 0 else { return }
        attributedString.addAttribute(.foregroundColor, value: UIColor.primary as Any, range: range)
        messageLabel.attributedText = attributedString
    }
}
