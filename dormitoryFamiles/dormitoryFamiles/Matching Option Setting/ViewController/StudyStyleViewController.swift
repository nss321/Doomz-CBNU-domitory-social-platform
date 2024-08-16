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
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .background
        label.textColor = .gray3
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "?"
        label.textAlignment = .center
        label.cornerRadius = 6
        label.layer.borderColor = UIColor.gray3?.cgColor
        label.layer.borderWidth = 1
        label.addCharacterSpacing(kernalValue: 1.5)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let helpPopUp = HelpPopUpView()
    
    private let dim: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
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
        checkSelections(selectedItems: [selectedExam], nextButton: nextButton)
        dim.isHidden = true
        helpPopUp.isHidden = true
    }
    
    func addComponents() {
        let studyPlaceSection = createStackViewWithLabelAndSubview(string: "공부장소", subview: studyPlaceCollectionView)
        let examSection = createStackViewWithLabelAndSubview(string: "시험", subview: examCollectionView, isRequired: true)

        
        view.addSubview(stackView)
        [logoStackView, studyStyleStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, studyStyleLogo, contentLabel].forEach{ logoStackView.addArrangedSubview($0) }
        [studyPlaceSection, examSection, spacerView, nextButton].forEach{ studyStyleStack.addArrangedSubview($0) }
        
        view.addSubview(helpLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showHelpPopUp))
        helpLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(dim)
        view.addSubview(helpPopUp)
        helpPopUp.setCancelButtonTarget(self, action: #selector(didClickCancelButton))
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
        
        helpLabel.snp.makeConstraints {
            $0.bottom.equalTo(examCollectionView.snp.top).inset(-12)
            $0.left.equalTo(examCollectionView.snp.left).inset(43)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
        
        helpPopUp.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(114)
        }
        
        dim.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    
    @objc func showHelpPopUp() {
        dim.isHidden = false
        helpPopUp.isHidden = false
        
        // 팝업 및 dim의 투명도를 점점 높여가며 표시
        dim.alpha = 0
        helpPopUp.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.dim.alpha = 0.5
            self.helpPopUp.alpha = 1
        }
    }
    
    @objc func didClickCancelButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dim.alpha = 0
            self.helpPopUp.alpha = 0
        }) { _ in
            self.dim.isHidden = true
            self.helpPopUp.isHidden = true
        }
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
            cellSize = CGSize(width: UIScreen.cellWidth3Column, height: UIScreen.cellHeight)
        default:
            cellSize = CGSize(width: UIScreen.cellWidth2Column, height: UIScreen.cellHeight)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case studyPlaceCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedStudyPlace, items: studyPlace)
            print("Study Place: \(studyPlace[indexPath.item]) 선택")
        case examCollectionView:
            handleSelection(collectionView: collectionView, indexPath: indexPath, selectedValue: &selectedExam, items: exam)
            print("Exam: \(exam[indexPath.item]) 선택")
        default:
            print("default")
        }
        checkSelections(selectedItems: [selectedExam], nextButton: nextButton)
    }
}


final class HelpPopUpView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
        setConstraints()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .gray0
        self.layer.cornerRadius = 12

        [questionmark, titleLabel, contentLabel, cancelButton].forEach {
            addSubview($0)
        }
    }

    private let questionmark: UIImageView = {
        let symbol = UIImageView(image: UIImage(systemName: "questionmark.circle"))
        symbol.contentMode = .scaleAspectFit
        symbol.tintColor = .primaryMid
        symbol.borderColor = .primaryMid
        return symbol
    }()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = FontManager.subtitle1()
        label.textColor = .primaryMid
        label.text = " 시험"
        label.addCharacterSpacing()
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.body2()
        label.textColor = .gray5
        label.lineBreakMode = .byCharWrapping
        label.text = "학교 시험 이외에도 따로 준비하고 있는 시험이나 공부가 있을 경우에 해당해요"
        label.numberOfLines = 0
        label.addCharacterSpacing(kernalValue: -0.5)
        return label
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelButton"), for: .normal)
        return button
    }()

    private func setConstraints() {
        questionmark.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.equalTo(titleLabel.snp.centerY).offset(1)
            $0.left.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.left.equalTo(questionmark.snp.right)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }

        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
        }
    }

    func setCancelButtonTarget(_ target: Any?, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
