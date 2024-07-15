//
//  StudyStyleViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/8/24.
//

import UIKit
import SnapKit

final class StudyStyleViewController: UIViewController, ConfigUI {
    
    let studyPlace = ["기숙사", "기숙사 외", "유동적"]
    let exam = ["시험 준비", "해당없어요"]
    
    var selectedStudyPlace: String?
    var selectedExam: String?
    
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
    
    private let studyStyleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "9 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress9")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let studyStyleLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "studyStyle_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "시험기간에 나는?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var studyPlaceCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var examCollectionView: UICollectionView = {
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
        let midnightSnackSection = createStackViewWithLabelAndSubview(string: "야식", subview: studyPlaceCollectionView)
        let eatingFoodInRoomSection = createStackViewWithLabelAndSubview(string: "방 안에서", subview: examCollectionView)

        
        view.addSubview(stackView)
        [logoStackView, studyStyleStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, studyStyleLogo, contentLabel].forEach{ logoStackView.addArrangedSubview($0) }
        [midnightSnackSection, eatingFoodInRoomSection, spacerView, nextButton].forEach{ studyStyleStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        studyPlaceCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        examCollectionView.snp.makeConstraints {
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
        
        studyStyleLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
        
    }
    
    @objc
    func didClickNextButton() {
        let studyStyleOption: [String: Any] = [
            "selectedStudyPlace": selectedStudyPlace ?? "",
            "selectedExam": selectedExam ?? ""
        ]
        UserDefaults.standard.setMatchingOption(studyStyleOption)
        
        // 저장된 정보 로그 출력
        ["selectedStudyPlace", "selectedExam"].forEach {
            print("\($0): \(UserDefaults.standard.getMatchingOptionValue(forKey: $0) ?? "")")
        }
        self.navigationController?.pushViewController(MiscViewController(), animated: true)
    }
}

extension StudyStyleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case studyPlaceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: studyPlace[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: exam[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem: Int
        switch collectionView {
        case studyPlaceCollectionView:
            numberOfItem = studyPlace.count
        default:
            numberOfItem = exam.count
        }
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


extension StudyStyleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch collectionView {
        case studyPlaceCollectionView:
            cellSize = CGSize(width: (UIScreen.currentScreenWidth - 56) / 3, height: 48)
        default:
            cellSize = CGSize(width: (UIScreen.currentScreenWidth - 48) / 2, height: 48)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case studyPlaceCollectionView:
            selectedStudyPlace = studyPlace[indexPath.item]
            print("Study Place: \(studyPlace[indexPath.item]) 선택")
        case examCollectionView:
            selectedExam = exam[indexPath.item]
            print("Exam: \(exam[indexPath.item]) 선택")
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case studyPlaceCollectionView:
            selectedStudyPlace = nil
            print("Study Place: \(studyPlace[indexPath.item]) 선택 해제")
        case examCollectionView:
            selectedExam = nil
            print("Exam: \(exam[indexPath.item]) 선택 해제")
        default:
            print("default")
        }
    }
}



