//
//  ConstitutionViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 5/30/24.
//

import UIKit
import SnapKit

final class ConstitutionViewController: UIViewController, ConfigUI {
  
    
    let hot = ["적게 탐", "조금 탐", "많이 탐"]
    let cold = ["적게 탐", "조금 탐", "많이 탐"]

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
    
    private let constitutionStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "4 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress4")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let constitutionLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "constitution_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 체질은?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var hotCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var coldCollectionView: UICollectionView = {
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
        let hotSection = createStackViewWithLabelAndSubview(string: "더위", subview: hotCollectionView)
        let coldSection = createStackViewWithLabelAndSubview(string: "추위", subview: coldCollectionView)
        
        view.addSubview(stackView)
        [logoStackView, constitutionStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, constitutionLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [hotSection, coldSection, spacerView, nextButton].forEach{ constitutionStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        hotCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        coldCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        spacerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
        
        constitutionLogo.snp.makeConstraints{
            $0.height.equalTo(120)
        }
    }
    
    @objc
    func didClickNextButton() {
        print("nextBtn")
        self.navigationController?.pushViewController(MBTIViewController(), animated: true)
    }
    
}

extension ConstitutionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case hotCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: hot[indexPath.row])
            return cell
        case coldCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cold[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: hot[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem = hot.count
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat = 8
        return interSpacing
    }
}

extension ConstitutionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfinter:Int = hot.count - 1
        let interSpacing:Int = 8
        let cellSize = CGSize(width: (UIScreen.screenWidthLayoutGuide - numberOfinter * interSpacing) / 3, height: 48)

        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case hotCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        case coldCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        default:
            print("\(indexPath.row) 선택")
        }
        
    }
}
