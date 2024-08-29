//
//  AlarmTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/30/24.
//

import UIKit
import SnapKit

class AlarmTableViewCell: UITableViewCell, ConfigUI {
    static let identifier = "alarmCell"
    var roundBaseView = UIView()
    var tabImage = UIImageView()
    var tabTextLabel = UILabel()
    var timeLabel = UILabel()
    var descriptionLabel = UILabel()
    
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    private func setUI() {
        roundBaseView.layer.cornerRadius = 16
        roundBaseView.layer.borderWidth = 1
        roundBaseView.layer.borderColor = UIColor.gray1?.cgColor
    }
    
    func addComponents() {
        [roundBaseView, tabImage, tabTextLabel, timeLabel, descriptionLabel].forEach{ contentView.addSubview($0) }
    }
    
    func setConstraints() {
        roundBaseView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
