//
//  MBTIViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 5/30/24.
//

import UIKit
import SnapKit

final class MBTIViewController: UIViewController, ConfigUI {
    
    // MARK: MBTI의 4가지 성향
    let energyOrientation = ["E","I"]
    let informationProcessing = ["S","N"]
    let decisionMaking = ["F","T"]
    let lifestyleApproach = ["P","J"]
    
    var selectedEnergyOrientation: String?
    var selectedInformationProcessing: String?
    var selectedDecisionMaking: String?
    var selectedLifestyleApproach: String?
    
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
    
    private let mbtiStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let mbtiCollectionViewStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "5 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress5")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let mbtiLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mbti_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 MBTI는?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .primary!, height: 52) {
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
        let mbtiSection = createStackViewWithLabelAndSubview(string: "MBTI", subview: mbtiCollectionViewStack)
        
        view.addSubview(stackView)
        [logoStackView, mbtiStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, mbtiLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [mbtiSection, spacerView, nextButton].forEach{ mbtiStack.addArrangedSubview($0) }
        
        [energyOrientation, informationProcessing, decisionMaking, lifestyleApproach].enumerated().forEach { (index, item) in
            let collectionView = createCollectionView(tag: index, data: item)
            mbtiCollectionViewStack.addArrangedSubview(collectionView)
        }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        mbtiLogo.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(75)
            make.width.equalTo(Double(UIScreen.currentScreenWidth) * 0.48)
            make.height.equalTo(Double(UIScreen.currentScreenHeight) * 0.16)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    
        spacerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        
        mbtiLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
    }
    
    @objc
    func didClickNextButton() {
        let matchingOption: [String: Any] = [
            "selectedEnergyOrientation": selectedEnergyOrientation ?? "",
            "selectedInformationProcessing": selectedInformationProcessing ?? "",
            "selectedDecisionMaking": selectedDecisionMaking ?? "",
            "selectedLifestyleApproach": selectedLifestyleApproach ?? ""
        ]
        UserDefaults.standard.setMatchingOption(matchingOption)
        
        guard let m = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedEnergyOrientation") else { fatalError() }
        guard let b = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedInformationProcessing") else { fatalError() }
        guard let t = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedDecisionMaking") else { fatalError() }
        guard let i = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedLifestyleApproach") else { fatalError() }
        
        print("Selected MBTI: \(m)\(b)\(t)\(i)")
        
        
        self.navigationController?.pushViewController(HomeCycleViewController(), animated: true)
    }
    
    func createCollectionView(tag:Int, data: [String]) -> UICollectionView {
        let interSpacing = 16
        let diameter = (UIScreen.screenWidthLayoutGuide - Int(interSpacing)*3) / 4
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(interSpacing)
        layout.itemSize = CGSize(width: diameter, height: diameter) // 원형 뷰의 크기
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints {
            $0.width.equalTo(diameter)
            $0.height.equalTo(2*diameter+interSpacing)
        }
        return collectionView
    }
}

// UICollectionViewDataSource, UICollectionViewDelegate 구현
extension MBTIViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return energyOrientation.count
        case 1:
            return informationProcessing.count
        case 2:
            return decisionMaking.count
        case 3:
            return lifestyleApproach.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SleepPatternCircleCollectionViewCell
        let text: String
        switch collectionView.tag {
        case 0:
            text = energyOrientation[indexPath.item]
        case 1:
            text = informationProcessing[indexPath.item]
        case 2:
            text = decisionMaking[indexPath.item]
        case 3:
            text = lifestyleApproach[indexPath.item]
        default:
            text = ""
        }
        cell.configure(with: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            selectedEnergyOrientation = energyOrientation[indexPath.item]
            print("\(energyOrientation[indexPath.item]) 선택")
        case 1:
            selectedInformationProcessing = informationProcessing[indexPath.item]
            print("\(informationProcessing[indexPath.item]) 선택")
        case 2:
            selectedDecisionMaking = decisionMaking[indexPath.item]
            print("\(decisionMaking[indexPath.item]) 선택")
        case 3:
            selectedLifestyleApproach = lifestyleApproach[indexPath.item]
            print("\(lifestyleApproach[indexPath.item]) 선택")
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            if selectedEnergyOrientation == energyOrientation[indexPath.item] {
                selectedEnergyOrientation = nil
            }
            print("\(energyOrientation[indexPath.item]) 선택 해제")
        case 1:
            if selectedInformationProcessing == informationProcessing[indexPath.item] {
                selectedInformationProcessing = nil
            }
            print("\(informationProcessing[indexPath.item]) 선택 해제")
        case 2:
            if selectedDecisionMaking == decisionMaking[indexPath.item] {
                selectedDecisionMaking = nil
            }
            print("\(decisionMaking[indexPath.item]) 선택 해제")
        case 3:
            if selectedLifestyleApproach == lifestyleApproach[indexPath.item] {
                selectedLifestyleApproach = nil
            }
            print("\(lifestyleApproach[indexPath.item]) 선택 해제")
        default:
            print("default")
        }
    }
}
