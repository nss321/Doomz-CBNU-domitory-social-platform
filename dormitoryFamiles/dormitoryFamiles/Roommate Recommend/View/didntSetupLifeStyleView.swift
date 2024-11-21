//
//  didntSetupLifeStyleView.swift
//  dormitoryFamiles
//
//  Created by BAE on 9/12/24.
//

import UIKit
import SnapKit
import Then

final class didntSetupLifeStyleView: UIView {
    
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
        
        [logo, titleLabel, contentLabel, typePreferredButton].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "completeMyCondition_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = " 아직 룸메 정보 설정을\n입력하지 않았어요!"
        $0.font = FontManager.head1()
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .doomzBlack
        $0.addCharacterSpacing()
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "룸메 매칭을 설정하면 둠즈가\n원하는 룸메를 추천해드려요!"
        $0.font = FontManager.body2()
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .gray5
        $0.addCharacterSpacing()
    }
    
    let typePreferredButton = CommonButton()
    
    private func setConstraints() {
        logo.snp.makeConstraints {
            $0.width.equalTo(Double(UIScreen.currentScreenWidth) * 0.57)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(12)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        typePreferredButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
}
