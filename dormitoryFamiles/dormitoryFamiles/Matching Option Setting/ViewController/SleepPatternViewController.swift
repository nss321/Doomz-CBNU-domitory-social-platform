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
        "어두움", "밝음", "없음"
    ]
    
    var selectedBedTimes: [String] = []
    var selectedWakeupTimes: [String] = []
    var selectedHabits: [String] = []
    var selectedSensitivity: [String] = []
    
    let currentScreenWidth = UIScreen.currentScreenWidth
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .gray2
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
        view.allowsMultipleSelection = true
        return view
    }()
    
    private lazy var wakeupTimeCollcetionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.allowsMultipleSelection = true
        return view
        
    }()
    
    private lazy var sleepingHabitsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.allowsMultipleSelection = true
        return view
    }()
    
    private lazy var sleepSensitivityCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.allowsMultipleSelection = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addComponents() {
        let bedTimeSection =  createStackViewWithLabelAndSubview(string: "취침시간", subview: bedTiemCollectionView)
        let wakeupTimeSection =  createStackViewWithLabelAndSubview(string: "기상시간", subview: wakeupTimeCollcetionView)
        let habitsSection = createStackViewWithLabelAndSubview(string: "잠버릇", subview: sleepingHabitsCollectionView)
        let sensitivitySection = createStackViewWithLabelAndSubview(string: "잠귀", subview: sleepSensitivityCollectionView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [logoStackView, sleepPatternStackView].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, sleepPatternLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [bedTimeSection, wakeupTimeSection, habitsSection, sensitivitySection, /*alarmSection,*/ nextButton].forEach { sleepPatternStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview().inset(20)
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
            $0.top.equalToSuperview().offset(30)
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        
        sleepPatternLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
    }
    
    @objc
    func didClickNextButton() {
        let matchingOption: [String: Any] = [
            "selectedBedTimes": selectedBedTimes,
            "selectedWakeupTimes": selectedWakeupTimes,
            "selectedHabits": selectedHabits,
            "selectedSensitivity": selectedSensitivity
        ]
        UserDefaults.standard.setMatchingOption(matchingOption)
        
        // 저장된 정보 로그 출력
        if let savedOptions = UserDefaults.standard.getMatchingOption() {
            print("Saved Matching Options: \(savedOptions)")
        }
        self.tabBarController?.tabBar.isHidden = true
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
            cellSize = CGSize(width: (currentScreenWidth - 86) / 4, height: (currentScreenWidth - 86) / 4 )
        default:
            cellSize = CGSize(width: (currentScreenWidth - 58) / 3, height: 48)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case bedTiemCollectionView:
            let selectedItem = goToSleepTimes[indexPath.row]
            selectedBedTimes.append(selectedItem)
            print("\(collectionView)의 \(selectedItem) 선택")
        case wakeupTimeCollcetionView:
            let selectedItem = wakeupTimes[indexPath.row]
            selectedWakeupTimes.append(selectedItem)
            print("\(collectionView)의 \(selectedItem) 선택")
        case  sleepingHabitsCollectionView:
            let selectedItem = habits[indexPath.row]
            selectedHabits.append(selectedItem)
            print("\(collectionView)의 \(selectedItem) 선택")
        case sleepSensitivityCollectionView:
            let selectedItem = sensitivity[indexPath.row]
            selectedSensitivity.append(selectedItem)
            print("\(collectionView)의 \(selectedItem) 선택")
        default:
            print("\(indexPath.row) 선택")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case bedTiemCollectionView:
            let deselectedItem = goToSleepTimes[indexPath.row]
            if let index = selectedBedTimes.firstIndex(of: deselectedItem) {
                selectedBedTimes.remove(at: index)
            }
            print("deselect \(deselectedItem)")
        case wakeupTimeCollcetionView:
            let deselectedItem = wakeupTimes[indexPath.row]
            if let index = selectedWakeupTimes.firstIndex(of: deselectedItem) {
                selectedWakeupTimes.remove(at: index)
            }
            print("deselect \(deselectedItem)")
        case  sleepingHabitsCollectionView:
            let deselectedItem = habits[indexPath.row]
            if let index = selectedHabits.firstIndex(of: deselectedItem) {
                selectedHabits.remove(at: index)
            }
            print("deselect \(deselectedItem)")
        case sleepSensitivityCollectionView:
            let deselectedItem = sensitivity[indexPath.row]
            if let index = selectedSensitivity.firstIndex(of: deselectedItem) {
                selectedSensitivity.remove(at: index)
            }
            print("deselect \(deselectedItem)")
        default:
            print("deselect \(indexPath.row)")
        }
    }
}
