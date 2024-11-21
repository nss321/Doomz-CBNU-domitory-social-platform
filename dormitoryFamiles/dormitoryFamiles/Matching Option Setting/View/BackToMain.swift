//
//  BackToMain.swift
//  dormitoryFamiles
//
//  Created by BAE on 10/30/24.
//

import UIKit
import Then
import SnapKit

final class BackToMain: UIView {
    
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
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "룸메 매칭 설정을\n그만두나요?"
        $0.font = FontManager.head1()
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .doomzBlack
        $0.addCharacterSpacing()
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "기타 정보등록을 하면\n회원님과 맞는 룸메를 추천해드려요!"
        $0.font = FontManager.body2()
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .gray5
        $0.addCharacterSpacing()
    }
    
    let backToMainButton = CommonButton()
    let closePopupButton = CommonButton()
    
}
