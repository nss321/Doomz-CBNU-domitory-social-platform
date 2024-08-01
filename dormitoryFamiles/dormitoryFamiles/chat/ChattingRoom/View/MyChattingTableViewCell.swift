//
//  MyChattingTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit
import SnapKit
import Kingfisher

class MyChattingTableViewCell: UITableViewCell, ConfigUI {

    let cirleView = UIImageView(image: UIImage(named: "chattingDetailCircle"))
    let messageLabel: RoundLabel = {
        let label = RoundLabel(top: 8, left: 16, bottom: 8, right: 16)
        label.layer.cornerRadius = 28
        label.backgroundColor = .primaryMid
        label.textColor = .white
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
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(cirleView)
    }
    
    func setConstraints() {
        cirleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(7.8)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(cirleView)
            $0.leading.greaterThanOrEqualToSuperview().offset(60)
            $0.trailing.equalTo(cirleView.snp.leading)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(messageLabel.snp.leading).inset(-8)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.chatMessage
        timeLabel.text = DateUtility.formatTime(message.sentTime)
    }
    
}
