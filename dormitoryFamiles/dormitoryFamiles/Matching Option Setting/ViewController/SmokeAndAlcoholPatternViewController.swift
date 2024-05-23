//
//  SmokeAndAlcoholPatternViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/28/24.
//

import UIKit
import SnapKit

final class SmokeAndAlcoholPatternViewController: UIViewController, ConfigUI {
    
    let smoke = ["비흡연", "흡연"]
    let alcohol = ["없음", "가끔", "종종", "자주"]
    let currentScreenWidth: CGFloat = UIScreen.main.bounds.width
    
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
    
    private let smokeAndAlcoholPatternStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "2 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress2")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let smokeAndAlcoholPatternLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "smokeAndAlcoholPattern_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 흡연・음주는?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var smokeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var alcoholCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCircleCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let drinkHabitTextField: UITextField = {
        let view = UITextField()
        view.frame.size.height = 52
        view.borderStyle = .roundedRect
        view.layer.borderColor = UIColor.gray1?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.autocorrectionType = .no
        view.spellCheckingType = .no
        view.autocapitalizationType = .none
        view.attributedPlaceholder = NSAttributedString(string: "나의 주사를 적어주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray4])
        view.clearsOnBeginEditing = false
        view.returnKeyType = .done
        view.backgroundColor = .clear
        view.font = .subTitle1
        view.textColor = .black
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
        drinkHabitTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func addComponents() {
        let smokeSection = createStackViewWithLabelAndSubview(string: "흡연여부", subview: smokeCollectionView)
        let alcoholSection = createStackViewWithLabelAndSubview(string: "음주빈도", subview: alcoholCollectionView)
        let alcoholHabitSection = createStackViewWithLabelAndSubview(string: "주사", subview: drinkHabitTextField)
        
        view.addSubview(stackView)
        [logoStackView, smokeAndAlcoholPatternStackView].forEach { stackView.addArrangedSubview($0) }
        
        [currentStep, progressBar, smokeAndAlcoholPatternLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        
        [smokeSection, alcoholSection, alcoholHabitSection, nextButton].forEach { smokeAndAlcoholPatternStackView.addArrangedSubview($0) }
        
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            //            $0.bottom.equalToSuperview()
        }
        
        smokeCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        alcoholCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo((currentScreenWidth - 86) / 4)
        }
        
        drinkHabitTextField.snp.makeConstraints {
            $0.width.equalTo(currentScreenWidth - 40)
            $0.height.equalTo(52)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    
    @objc
    func didClickNextButton() {
        print("nextBtn")
        print("textField: \(String(describing: drinkHabitTextField.text))")
        self.navigationController?.pushViewController(LifeStyleViewController(), animated: true)
    }
}

extension SmokeAndAlcoholPatternViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case smokeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: smoke[indexPath.row])
            return cell
        case alcoholCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as? SleepPatternCircleCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: alcohol[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: smoke[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem: Int
        
        switch collectionView {
        case smokeCollectionView:
            numberOfItem = smoke.count
        case alcoholCollectionView:
            numberOfItem = alcohol.count
        default:
            numberOfItem = alcohol.count
        }
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat
        
        switch collectionView {
        case smokeCollectionView:
            interSpacing = 8
        default:
            interSpacing = 15
        }
        return interSpacing
    }
}

extension SmokeAndAlcoholPatternViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch collectionView {
        case alcoholCollectionView:
            // MARK: cell 간격
            cellSize = CGSize(width: (currentScreenWidth - 86) / 4, height: (currentScreenWidth - 86) / 4 )
        default:
            cellSize = CGSize(width: (currentScreenWidth - 48) / 2, height: 48)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case smokeCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        case alcoholCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        default:
            print("\(indexPath.row) 선택")
        }
        
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension SmokeAndAlcoholPatternViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            view.frame.origin.y = -(keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
}
