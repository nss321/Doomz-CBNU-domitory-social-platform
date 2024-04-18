//
//  LifeStyleViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 4/16/24.
//

import UIKit
import SnapKit

final class LifeStyleViewController: UIViewController, ConfigUI {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 38
        view.alignment = .center
        return view
    }()
    
    private let logoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .center
        return view
    }()
    
    private let lifeStyleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "3 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress3")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let lifeStyleLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "lifeStyle_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 생활방식은?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .gray3!, height: 52) {
        self.didClickNextButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("긱사생활 설정")
        addComponents()
        setConstraints()
        nextButton.setup(model: nextButtonModel)
    }
    
    func addComponents() {
        view.addSubview(stackView)
        [logoStackView, lifeStyleStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, lifeStyleLogo, contentLabel].forEach{ logoStackView.addArrangedSubview($0) }
        [nextButton].forEach{ lifeStyleStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
//            $0.bottom.equalToSuperview()
        }
        
//        smokeCollectionView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.width.equalTo(view.snp.width).inset(20)
//            $0.height.equalTo(48)
//        }
//        
//        alcoholCollectionView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.width.equalTo(view.snp.width).inset(20)
//            $0.height.equalTo((currentScreenWidth - 86) / 4)
//        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    
    @objc
    func didClickNextButton() {
        print("nextBtn")
//        self.navigationController?.pushViewController(SmokeAndAlcoholPatternViewController(), animated: false)
    }
    
}
