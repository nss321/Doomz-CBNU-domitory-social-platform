//
//  ChooseRoomateViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/15/24.
//

import UIKit
import SnapKit

final class ChooseRoomateViewController: UIViewController, ConfigUI {
    
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
    let habits: [String] = ["이갈이", "코골이", "잠꼬대", "없음"]
    let sensitivity: [String] = ["어두움", "밝음"]
    let smoke = ["비흡연", "흡연"]
    let alcohol = ["없음", "가끔", "종종", "자주"]
    let shower = ["아침", "저녁"]
    let cleanHabit = ["바로바로", "가끔", "몰아서"]
    let hot = ["적게 탐", "조금 탐", "많이 탐"]
    let cold = ["적게 탐", "조금 탐", "많이 탐"]
    let energyOrientation = ["E","I"]
    let informationProcessing = ["S","N"]
    let decisionMaking = ["F","T"]
    let lifestyleApproach = ["P","J"]
    let cycle = ["거의안감", "2,3달에\n한번", "1달에\n한번", "주에 한번"]
    let midnightSnack = ["안먹어요", "가끔", "자주"]
    let eatingFoodInRoom = ["괜찮아요", "싫어요"]
    let noise = ["이어폰", "스피커", "유동적"]
    let perfume = ["미사용", "가끔", "자주"]
    let studyPlace = ["기숙사", "기숙사 외", "유동적"]
    let exam = ["시험 준비", "해당없어요"]
    let workout = ["안해요", "긱사에서", "헬스장에서"]
    let bugs = ["잘잡아요", "작은것만", "못잡아요"]
    
    let selectedPriorities = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedPriorities") as? [String]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let string = "원하는 룸메의 정보를 선택해주세요!"
        let attributedString = NSMutableAttributedString(string: string)
        
        attributedString.addAttributes([
            .font: FontManager.title2(),
            .foregroundColor: UIColor.doomzBlack
        ], range: NSRange(location: 0, length: 11))
        
        attributedString.addAttributes([
            .font: FontManager.body3(),
            .foregroundColor: UIColor.doomzBlack
        ], range: NSRange(location: 12, length: 7))
        
        label.attributedText = attributedString
        label.textAlignment = .center
        return label
    }()

    private let sectionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let korToEng = [
        "취침 시간":"selectedBedTimes",
        "기상 시간":"selectedWakeupTimes",
        "잠버릇":"selectedHabits",
        "잠귀":"selectedSensitivity",
        "흡연 여부":"selectedSmoke",
        "음주 빈도":"selectedAlcohol",
        "청소":"selectedCleanHabit",
        "더위":"selectedHot",
        "추위":"selectedCold",
        "향수":"selectedPerfume",
        "시험":"selectedExam"
    ]
    
    lazy var korToOptions = [
        "취침 시간": goToSleepTimes,
        "기상 시간": wakeupTimes,
        "잠버릇": habits,
        "잠귀": sensitivity,
        "흡연 여부": smoke,
        "음주 빈도": alcohol,
        "청소": cleanHabit,
        "더위": hot,
        "추위": cold,
        "향수": perfume,
        "시험": exam
    ] as [String : Any]
    
    var firstPreference: String?
    var secondPreference: String?
    var thirdPreference: String?
    var fourthPreference: String?
    var selectedItems = [Bool](repeating: false, count: 11)
    
    private let nextButton = CommonButton()
    
    private lazy var nextButtonModel = CommonbuttonModel(title: "다음", titleColor: .white ,backgroundColor: .gray3!, height: 52) {
        self.didClickNextButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("룸메 우선순위설정")
        addComponents()
        setConstraints()
        nextButton.setup(model: nextButtonModel)
//        checkSelections(selectedOptions: selectedPriorities, nextButton: nextButton)
        print(selectedPriorities!)
        updateNextButtonState()
        makeSections()
        
    }
    
    func addComponents() {
        view.addSubview(titleLabel)
        view.addSubview(sectionStack)
        view.addSubview(spacerView)
        view.addSubview(nextButton)
        
//        let label = UILabel()
//        label.numberOfLines = 0
//        if let text = UserDefaults.standard.getMatchingOptionValue(forKey: "selectedPriorities") as? [String] {
//            label.text = text.joined(separator: "\n")
//        }
//        sectionStack.addArrangedSubview(label)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        
        sectionStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        spacerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
    }
    
    @objc func didClickNextButton() {
        let preference: [String: Any] = [
            "firstPreference": firstPreference ?? "",
            "secondPreference": secondPreference ?? "",
            "thirdPreference": thirdPreference ?? "",
            "fourthPreference": fourthPreference ?? ""
        ]
        
        // 유효한 타입만 포함되도록 딕셔너리 값을 확인
        UserDefaults.standard.setMatchingOption(preference)
        
        ["firstPreference","secondPreference","thirdPreference","fourthPreference"].forEach {
            print("preference: \(UserDefaults.standard.getMatchingOptionValue(forKey: $0) ?? "N/A")")
        }
        
        self.navigationController?.pushViewController(CompleteMatchingOptionViewController(), animated: true)
    }
//    func test() {
//        if let list = selectedPriorities {
//            for item in list {
//                print(korToEng[item])
//            }
//        }
//    }
    
    func makeSections() {
        guard let headers = selectedPriorities else { fatalError() }
        
        for item in headers {
            switch item {
            case "취침 시간" :
                let section = makeSelectedSection(header: item, content: goToSleepTimes, tag: 0, cellType: PriorityCellType.rect(type: .right), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "기상 시간" :
                let section = makeSelectedSection(header: item, content: wakeupTimes, tag: 1, cellType: PriorityCellType.rect(type: .right), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "잠버릇" :
                let section = makeSelectedSection(header: item, content: habits, tag: 2, cellType: PriorityCellType.circle, numberOfColumns: 4, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "잠귀" :
                let section = makeSelectedSection(header: item, content: sensitivity, tag: 3, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 2, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "흡연 여부" :
                let section = makeSelectedSection(header: item, content: smoke, tag: 4, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 2, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "음주 빈도" :
                let section = makeSelectedSection(header: item, content: alcohol, tag: 5, cellType: PriorityCellType.circle, numberOfColumns: 4, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "청소" :
                let section = makeSelectedSection(header: item, content: cleanHabit, tag: 6, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "더위" :
                let section = makeSelectedSection(header: item, content: hot, tag: 7, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "추위" :
                let section = makeSelectedSection(header: item, content: cold, tag: 8, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "향수" :
                let section = makeSelectedSection(header: item, content: perfume, tag: 9, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 3, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            case "시험" :
                let section = makeSelectedSection(header: item, content: exam, tag: 10, cellType: PriorityCellType.rect(type: .not), numberOfColumns: 2, delegate: self, dataSource: self)
                sectionStack.addArrangedSubview(section)
            default :
                return
            }
        }
    }
}

extension ChooseRoomateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return goToSleepTimes.count
        case 1:
            return wakeupTimes.count
        case 2:
            return habits.count
        case 3:
            return sensitivity.count
        case 4:
            return smoke.count
        case 5:
            return alcohol.count
        case 6:
            return cleanHabit.count
        case 7:
            return hot.count
        case 8:
            return cold.count
        case 9:
            return perfume.count
        case 10:
            return exam.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch collectionView.tag {
        case 0:
            let sleepCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            sleepCell.configure(with: goToSleepTimes[indexPath.item])
            cell = sleepCell
        case 1:
            let wakeupCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            wakeupCell.configure(with: wakeupTimes[indexPath.item])
            cell = wakeupCell
        case 2:
            let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as! SleepPatternCircleCollectionViewCell
            habitCell.configure(with: habits[indexPath.item])
            cell = habitCell
        case 3:
            let sensitivityCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            sensitivityCell.configure(with: sensitivity[indexPath.item])
            cell = sensitivityCell
        case 4:
            let smokeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            smokeCell.configure(with: smoke[indexPath.item])
            cell = smokeCell
        case 5:
            let alcoholCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as! SleepPatternCircleCollectionViewCell
            alcoholCell.configure(with: alcohol[indexPath.item])
            cell = alcoholCell
        case 6:
            let cleanCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            cleanCell.configure(with: cleanHabit[indexPath.item])
            cell = cleanCell
        case 7:
            let hotCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            hotCell.configure(with: hot[indexPath.item])
            cell = hotCell
        case 8:
            let coldCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            coldCell.configure(with: cold[indexPath.item])
            cell = coldCell
        case 9:
            let perfumeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            perfumeCell.configure(with: perfume[indexPath.item])
            cell = perfumeCell
        case 10:
            let examCell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as! SleepPatternCollectionViewCell
            examCell.configure(with: exam[indexPath.item])
            cell = examCell
        default:
            cell = UICollectionViewCell()
        }
        
        return cell
    }
    
}

extension ChooseRoomateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag < selectedItems.count {
            selectedItems[collectionView.tag] = true
        }
        updateNextButtonState()
        
        switch collectionView {
        case sectionStack.arrangedSubviews[0].subviews[1]:
            if let label = sectionStack.arrangedSubviews[0].subviews[0] as? UILabel {
                let key = label.text ?? ""
                if let options = korToOptions[key] as? [String] {
                    firstPreference = options[indexPath.row]
                }
            }
        case sectionStack.arrangedSubviews[1].subviews[1]:
            if let label = sectionStack.arrangedSubviews[1].subviews[0] as? UILabel {
                let key = label.text ?? ""
                if let options = korToOptions[key] as? [String] {
                    secondPreference = options[indexPath.row]
                }
            }
        case sectionStack.arrangedSubviews[2].subviews[1]:
            if let label = sectionStack.arrangedSubviews[2].subviews[0] as? UILabel {
                let key = label.text ?? ""
                if let options = korToOptions[key] as? [String] {
                    thirdPreference = options[indexPath.row]
                }
            }
        case sectionStack.arrangedSubviews[3].subviews[1]:
            if let label = sectionStack.arrangedSubviews[3].subviews[0] as? UILabel {
                let key = label.text ?? ""
                if let options = korToOptions[key] as? [String] {
                    fourthPreference = options[indexPath.row]
                }
            }
        default:
            print("디폴트")
            print(sectionStack.arrangedSubviews[0].subviews)
            print(collectionView)
        }
        
        // 흡연여부 추위 더위 시험
//        guard let order = selectedItems else { fatalError() }
        
        
        
    }
    
    func updateNextButtonState() {
        var count = 0
        for selected in selectedItems {
            if selected {
                count += 1
            }
        }
        nextButton.isEnabled(count == 4 ? true : false)
        nextButton.backgroundColor = count == 4 ? .primary : .gray3
    }
}
