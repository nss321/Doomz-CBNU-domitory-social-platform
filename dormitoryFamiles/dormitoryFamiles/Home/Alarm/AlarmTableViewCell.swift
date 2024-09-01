//
//  AlarmTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/30/24.
//

import UIKit
import SnapKit
import Kingfisher

class AlarmTableViewCell: UITableViewCell, ConfigUI {
    
    static let identifier = "alarmCell"
    var sender = ""
    var articleTitle = ""
    var isRead = false
    var notificationId = 0
    var targetId = 0
    var typeImageView = UIImageView()
    
    private let roundBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray1?.cgColor
        return view
    }()
    var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.624, blue: 0.631, alpha: 1)
        return label
    }()
    var createdAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.624, blue: 0.631, alpha: 1)
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .title4
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.minimumScaleFactor = 1.0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addComponents()
        setConstraints()
    }
    
    
    
    //셀과의 간격을 15로 주었음
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.width
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeImageView.image = nil
        typeLabel.text = nil
        createdAtLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func setUI() {
        
    }
    
    func addComponents() {
        contentView.addSubview(roundBaseView)
        [typeImageView, typeLabel, createdAtLabel, descriptionLabel].forEach{ roundBaseView.addSubview($0) }
    }
    
    func setConstraints() {
        roundBaseView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        typeImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.width.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(typeImageView)
            $0.leading.equalTo(typeImageView.snp.trailing).offset(4)
        }
        
        createdAtLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(typeImageView.snp.bottom).offset(8).priority(.high)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16).priority(.high)
            $0.height.greaterThanOrEqualTo(25).priority(.required)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(articleTitle: String?, createdAt: String, isRead: Bool, notificationId: Int, sender: String, targetId: Int, type: String) {
        self.articleTitle = articleTitle ?? ""
        self.createdAtLabel.body2 = createdAt
        //시간을 보고 몇분전 세팅
        self.isRead = isRead
        self.notificationId = notificationId
        self.sender = sender
        self.targetId = targetId
        self.typeLabel.button = type
        if let alarmType = AlarmType(rawValue: type) {
            self.descriptionLabel.text = alarmType.rawValue
        } else if let alarmType = AlarmType(rawValue: AlarmType.matchingDescription(type)?.rawValue ?? "") {
            self.descriptionLabel.text = sender+alarmType.rawValue
        } else {
            self.descriptionLabel.text = ""
        }
        
        //타입을 보고 이미지뷰 세팅(현재는 테스트 임시세팅)
        typeImageView.image = UIImage(named: "chattingColor")
    }
}
