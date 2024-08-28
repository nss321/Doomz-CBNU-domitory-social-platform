//
//  SleepPatternViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit
import SnapKit

final class SleepPatternViewController: UIViewController, ConfigUI {
    
    let goToSleepTimes: [String] = [
        "오후 9시 이전", "오후 9시", "오후 10시",
        "오후 11시", "오후 12시", "오전 1시",
        "오전 2시", "오전 3시", "오전 3시 이후"
    ]
    
    let wakeupTimes: [String] = [
        "오전 4시 이전", "오전 4시", "오전 5시",
        "오전 6시", "오전 7시", "오전 8시",
        "오전 9시", "오전 10시", "오전 10시 이후"
    ]
    
    let habits: [String] = [
        "이갈이", "코골이", "잠꼬대", "없음"
    ]
    
    let sensitivity: [String] = [
        "어두움", "밝음"
    ]
    
    var selectedBedTime: String?
    var selectedWakeupTime: String?
    var selectedHabit: String?
    var selectedSensitivity: String?
    
    let currentScreenWidth = UIScreen.currentScreenWidth
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.bounces = false
        return view
    }()
    
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
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "1 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress1")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let sleepPatternLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sleepPattern_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 수면 패턴은?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let sleepPatternStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 28
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var bedTiemCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var wakeupTimeCollcetionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
        
    }()
    
    private lazy var sleepingHabitsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var sleepSensitivityCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let notificationLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryLight
        
        let image = UIImageView(image: UIImage(named: "notiIcon"))
        
        let label = UILabel()
        let string = "* 표시는 필수 선택사항입니다."
        let attributedString = NSMutableAttributedString(string: string)
        
        attributedString.addAttributes([
            .font: FontManager.button(),
            .foregroundColor: UIColor.primary!
        ], range: NSRange(location: 0, length: 2))
        
        attributedString.addAttributes([
            .font: FontManager.button(),
            .foregroundColor: UIColor.gray5!
        ], range: NSRange(location: 2, length: 4))
        
        attributedString.addAttributes([
            .font: FontManager.button(),
            .foregroundColor: UIColor.primary!
        ], range: NSRange(location: 6, length: 7))
        
        attributedString.addAttributes([
            .font: FontManager.button(),
            .foregroundColor: UIColor.gray5!
        ], range: NSRange(location: 13, length: 4))
        
        label.attributedText = attributedString
        label.textAlignment = .center
        
        
        view.addSubview(image)
        view.addSubview(label)
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .gray3!, height: 52) {
        self.didClickNextButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addComponents()
        setConstraints()
        setupNavigationBar("긱사생활 설정")
        nextButton.setup(model: nextButtonModel)
        checkSelections(selectedItems: [selectedBedTime, selectedWakeupTime, selectedHabit, selectedSensitivity], nextButton: nextButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addComponents() {
        let bedTimeSection =  createStackViewWithLabelAndSubview(string: "취침시간", subview: bedTiemCollectionView, isRequired: true)
        let wakeupTimeSection =  createStackViewWithLabelAndSubview(string: "기상시간", subview: wakeupTimeCollcetionView, isRequired: true)
        let habitsSection = createStackViewWithLabelAndSubview(string: "잠버릇", subview: sleepingHabitsCollectionView, isRequired: true)
        let sensitivitySection = createStackViewWithLabelAndSubview(string: "잠귀", subview: sleepSensitivityCollectionView, isRequired: true)
      
        view.addSubview(scrollView)
        scrollView.addSubview(notificationLabel)
        scrollView.addSubview(stackView)
        [logoStackView, sleepPatternStackView].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, sleepPatternLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [bedTimeSection, wakeupTimeSection, habitsSection, sensitivitySection, nextButton].forEach { sleepPatternStackView.addArrangedSubview($0) }
        
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bedTiemCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(160)
        }
        
        wakeupTimeCollcetionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(160)
        }
        
        sleepingHabitsCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo((currentScreenWidth - 86) / 4)
        }
        
        sleepSensitivityCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Double(UIScreen.currentScreenHeight)*0.08+24)
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        
        sleepPatternLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
        
        notificationLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.08)
        }
        
    }
    
    @objc
    func didClickNextButton() {
        let matchingOption: [String: Any] = [
            "selectedBedTimes": selectedBedTime ?? "",
            "selectedWakeupTimes": selectedWakeupTime ?? "",
            "selectedHabits": selectedHabit ?? "",
            "selectedSensitivity": selectedSensitivity ?? ""
        ]
        UserDefaults.standard.setMatchingOption(matchingOption)
        
        ["selectedBedTimes", "selectedWakeupTimes", "selectedHabits", "selectedSensitivity"].forEach {
            print("\($0): \(UserDefaults.standard.getMatchingOptionValue(forKey: $0) ?? "")")
        }
    
        self.navigationController?.pushViewController(SmokeAndAlcoholPatternViewController(), animated: true)
    }
}

extension SleepPatternViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case bedTiemCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
            cell.configure(with: goToSleepTimes[indexPath.row])
            return cell
        case wakeupTimeCollcetionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
            cell.configure(with: wakeupTimes[indexPath.row])
            return cell
        case sleepingHabitsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as? SleepPatternCircleCollectionViewCell else { fatalError() }
            cell.configure(with: habits[indexPath.row])
            return cell
        case sleepSensitivityCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
            cell.configure(with: sensitivity[indexPath.row])
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
            cell.configure(with: goToSleepTimes[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem: Int
        
        switch collectionView {
        case sleepingHabitsCollectionView:
            numberOfItem = habits.count
        case sleepSensitivityCollectionView:
            numberOfItem = sensitivity.count
        default:
            numberOfItem = goToSleepTimes.count
        }
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat
        
        switch collectionView {
        case sleepingHabitsCollectionView, sleepSensitivityCollectionView:
            lineSpacing = 0
        default:
            lineSpacing = 8
        }
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat
        
        switch collectionView {
        case sleepingHabitsCollectionView:
            interSpacing = 15
        default:
            interSpacing = 8
        }
        return interSpacing
    }
}

extension SleepPatternViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch collectionView {
        case sleepingHabitsCollectionView:
            // MARK: cell 간격
            cellSize = CGSize(width: UIScreen.circleCellDiameter, height: UIScreen.circleCellDiameter)
        case sleepSensitivityCollectionView:
            cellSize = CGSize(width: UIScreen.cellWidth2Column, height: UIScreen.cellHeight)
        default:
            cellSize = CGSize(width: UIScreen.cellWidth3Column, height: UIScreen.cellHeight)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case bedTiemCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedBedTime, items: goToSleepTimes)
            print("Bed Time: \(selectedBedTime ?? "선택 해제") 선택")
        case wakeupTimeCollcetionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedWakeupTime, items: wakeupTimes)
            print("Wakeup Time: \(selectedWakeupTime ?? "선택 해제") 선택")
        case sleepingHabitsCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedHabit, items: habits)
            print("Habit: \(selectedHabit ?? "선택 해제") 선택")
        case sleepSensitivityCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedSensitivity, items: sensitivity)
            print("Sensitivity: \(selectedSensitivity ?? "선택 해제") 선택")
        default:
            print("default")
        }
        checkSelections(selectedItems: [selectedBedTime, selectedWakeupTime, selectedHabit, selectedSensitivity], nextButton: nextButton)
    }
}
