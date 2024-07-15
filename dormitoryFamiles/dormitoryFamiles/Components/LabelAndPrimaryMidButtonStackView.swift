//
//  LabelAndPrimaryMidButtonStackView.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/14.
//

import UIKit

class LabelAndRoundButtonStackView: UIStackView {
    
    init(labelText: String, textFont: UIFont, buttonText: String, buttonHasArrow: Bool) {
        super.init(frame: .zero)
        setupView(labelText: labelText, textFont: textFont, buttonText: buttonText, buttonHasArrow: buttonHasArrow)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(labelText: String, textFont: UIFont, buttonText: String, buttonHasArrow: Bool) {
        axis = .horizontal
        alignment = .fill
        
        let label = UILabel()
        label.font = textFont
        label.text = labelText
        
        let button = PrimaryMidRoundButton(title: buttonText, isArrow: buttonHasArrow)
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        addArrangedSubview(label)
        addArrangedSubview(button)
    }
}
