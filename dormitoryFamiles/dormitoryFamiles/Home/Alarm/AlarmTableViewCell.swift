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
    var userId = ""
    var tabImageView = UIImageView()
    var tabUrl: String? {
        didSet {
            updateProfileImage()
        }
    }
    
    private let roundBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray1?.cgColor
        return view
    }()
    var tabTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.624, blue: 0.631, alpha: 1)
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.62, green: 0.624, blue: 0.631, alpha: 1)
        return label
    }()
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
        
    }
    
    func addComponents() {
        [roundBaseView, tabImageView, tabTextLabel, timeLabel, descriptionLabel].forEach{ contentView.addSubview($0) }
    }
    
    func setConstraints() {
        roundBaseView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func updateProfileImage() {
        guard let tabUrl = tabUrl, let url = URL(string: tabUrl) else {
            return
        }
        tabImageView.kf.setImage(with: url)
        tabImageView.contentMode = .scaleAspectFill
    }
}
