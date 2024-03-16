//
//  SleepPatternViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit
import SnapKit

final class SleepPatternViewController: UIViewController, ConfigUI {
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "1 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        
        return label
    }()
    
//    private let progressBar: UIImageView = {
        // TODO: 프로그레스 바 이미지 에셋에 추가 해야함
//        let view = UIImageView(image: "")
//        return view
//    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 수면 패턴은?"
        label.font = FontManager.title2()
        label.textColor = .blackYak
        label.addCharacterSpacing()
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addComponents()
        setConstraints()
        setupNavigationBar("긱사생활 설정")
    }
    
    func addComponents() {
        [currentStep, /*progressBar,*/ contentLabel].forEach { view.addSubview($0) }
    }
    
    func setConstraints() {
        currentStep.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.centerX.equalToSuperview()
        }
    }
}
