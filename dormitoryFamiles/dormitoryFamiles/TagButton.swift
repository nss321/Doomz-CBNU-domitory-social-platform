//
//  TagButton.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/03.
//

import UIKit

class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupConfiguration()
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setupConfiguration()
    }
    
    private func setupButton() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
        self.setTitleColor(.red, for: .reserved)
    }
    
    private func setupConfiguration() {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 15, leading: 8, bottom: 15, trailing: 8)
        self.configuration = configuration
    }
   
}



class TagButton: RoundButton {

    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    convenience init(title: String) {
        self.init()
        setUI(title: title)
    }
    
    private func setUI(title: String) {
        self.setTitle(title, for: .normal)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.setTitleColor(.black, for: .normal)
    }
    
    func changeWhiteColor() {
        self.backgroundColor = .white
    }

    func changeOrangeColor() {
        self.backgroundColor = .black
    }

}
