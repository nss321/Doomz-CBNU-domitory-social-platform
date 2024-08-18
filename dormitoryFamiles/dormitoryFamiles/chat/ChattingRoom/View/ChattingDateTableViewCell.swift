//
//  ChattingDateTableViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/12/24.
//

import UIKit

class ChattingDateTableViewCell: UITableViewCell {

    private let leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray2
        label.font = FontManager.small1()
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leftLineView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(rightLineView)
        
        leftLineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-12)
            $0.height.equalTo(0.8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        rightLineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(dateLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(0.8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        dateLabel.text = dateFormatter.string(from: date)
    }
}
