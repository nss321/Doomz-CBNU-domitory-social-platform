//
//  HomeCycleViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/8/24.
//

import UIKit
import SnapKit

final class HomeCycleViewController: UIViewController, ConfigUI {
    
    enum cycle: String, CaseIterable {
        case almostNot = "거의안감"
        case twoToThreeMonth = "2,3달에\n한번"
        case oneMonth = "1달에\n한번"
        case everyWeek = "주에 한번"
    }
    
//    let cycle = ["거의안감", "2,3달에\n한번", "1달에\n한번", "주에 한번"]
    
    var selectedCycle: String?
    
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
    
    private let cycleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "6 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress6")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let cycleLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "goingHomeFrequency_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 본가가는 빈도는?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var cycleCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
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
        checkSelections(selectedItems: [selectedCycle], nextButton: nextButton)
    }
    
    func addComponents() {
        let cycleSection = createStackViewWithLabelAndSubview(string: "본가가는 빈도", subview: cycleCollectionView, isRequired: true)
        
        view.addSubview(stackView)
        [logoStackView, cycleStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, cycleLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [cycleSection, spacerView, nextButton].forEach{ cycleStack.addArrangedSubview($0) }
        
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        cycleCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo((UIScreen.currentScreenWidth - 86) / 4)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        spacerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    @objc
    func didClickNextButton() {
//        let homeCycleOption: [String: Any] = [
//            "selectedCycle": selectedCycle ?? ""
//        ]
        var homeCycleOption: [String: Any] = ["selectedCycle":""]
        
        // cell에는 \n 문자가 포함되어, API 명세를 맞추기 위해 조정하는 구문 추가
        switch selectedCycle {
        case cycle.almostNot.rawValue:
            homeCycleOption["selectedCycle"] = "거의 안감"
        case cycle.twoToThreeMonth.rawValue:
            homeCycleOption["selectedCycle"] = "2,3달에 한 번"
        case cycle.oneMonth.rawValue:
            homeCycleOption["selectedCycle"] = "1달에 한 번"
        case cycle.everyWeek.rawValue:
            homeCycleOption["selectedCycle"] = "주에 한 번"
        case .none:
            break
        case .some(_):
            break
        }
        
        UserDefaults.standard.setMatchingOption(homeCycleOption)
        
        // 저장된 정보 로그 출력
        print("selectedCycle: \(UserDefaults.standard.getMatchingOptionValue(forKey: "selectedCycle") ?? "")")
        self.navigationController?.pushViewController(EatingFoodViewController(), animated: true)
    }
}

extension HomeCycleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as? SleepPatternCircleCollectionViewCell else {
            fatalError()
        }
        
        let cycle = cycle.allCases
        cell.configure(with: cycle[indexPath.row].rawValue)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycle.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension HomeCycleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        cellSize = CGSize(width: UIScreen.circleCellDiameter, height: UIScreen.circleCellDiameter )
    
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cycle: [String] = []
        HomeCycleViewController.cycle.allCases.forEach { cycle.append($0.rawValue) }
        handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedCycle, items: cycle)
        print("Cycle: \(cycle[indexPath.row]) 선택")
        checkSelections(selectedItems: [selectedCycle], nextButton: nextButton)
    }
}
