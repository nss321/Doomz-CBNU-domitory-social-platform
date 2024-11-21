//
//  EatingFoodViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/8/24.
//

import UIKit
import SnapKit

final class EatingFoodViewController: UIViewController, ConfigUI {
    
    let midnightSnack = ["안 먹어요", "가끔", "자주"]
    let eatingFoodInRoom = ["괜찮아요", "싫어요"]
    
    var selectedMidnightSnack: String?
    var selectedEatingFoodInRoom: String?
    
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
    
    private let eatingFoodStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "7 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress7")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let eatingFoodLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "eatingFood_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "음식은 어떤가요?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var midnightSnackCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var eatingFoodInRoomCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
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
//        checkSelections(selectedItems: [selectedMidnightSnack, selectedEatingFoodInRoom], nextButton: nextButton)
    }
    
    func addComponents() {
        let midnightSnackSection = createStackViewWithLabelAndSubview(string: "야식", subview: midnightSnackCollectionView)
        let eatingFoodInRoomSection = createStackViewWithLabelAndSubview(string: "방 안에서", subview: eatingFoodInRoomCollectionView)
        
        view.addSubview(stackView)
        [logoStackView, eatingFoodStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, eatingFoodLogo, contentLabel].forEach{ logoStackView.addArrangedSubview($0) }
        [midnightSnackSection, eatingFoodInRoomSection, spacerView, nextButton].forEach{ eatingFoodStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        midnightSnackCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        eatingFoodInRoomCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        
        spacerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        
        eatingFoodLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
        
    }
    
    @objc
    func didClickNextButton() {
        let matchingOption: [String: Any] = [
            "selectedMidnightSnack": selectedMidnightSnack ?? "",
            "selectedEatingFoodInRoom": selectedEatingFoodInRoom ?? ""
        ]
        UserDefaults.standard.setMatchingOption(matchingOption)
        
        // 저장된 정보 로그 출력
        ["selectedMidnightSnack", "selectedEatingFoodInRoom"].forEach {
            print("\($0): \(UserDefaults.standard.getMatchingOptionValue(forKey: $0) ?? "")")
        }
        self.navigationController?.pushViewController(NoiseAndPerfumeViewController(), animated: true)
    }
}

extension EatingFoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case midnightSnackCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: midnightSnack[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: eatingFoodInRoom[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem: Int
        switch collectionView {
        case midnightSnackCollectionView:
            numberOfItem = midnightSnack.count
        default:
            numberOfItem = eatingFoodInRoom.count
        }
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


extension EatingFoodViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch collectionView {
        case midnightSnackCollectionView:
            cellSize = CGSize(width: UIScreen.cellWidth3Column, height: UIScreen.cellHeight)
        default:
            cellSize = CGSize(width: UIScreen.cellWidth2Column, height: UIScreen.cellHeight)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case midnightSnackCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedMidnightSnack, items: midnightSnack)
            print("Midnight Snack: \(midnightSnack[indexPath.item]) 선택")
        case eatingFoodInRoomCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedEatingFoodInRoom, items: eatingFoodInRoom)
            print("Eating Food In Room: \(eatingFoodInRoom[indexPath.item]) 선택")
        default:
            print("default")
        }
//        checkSelections(selectedItems: [selectedMidnightSnack, selectedEatingFoodInRoom], nextButton: nextButton)
    }
}


