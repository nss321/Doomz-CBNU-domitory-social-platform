//
//  NoiseAndPerfumeViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/8/24.
//

import UIKit
import SnapKit

final class NoiseAndPerfumeViewController: UIViewController, ConfigUI {
  
    let noise = ["이어폰", "스피커", "유동적"]
    let perfume = ["미사용", "가끔", "자주"]
    
    var selectedNoise: String?
    var selectedPerfume: String?

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
    
    private let noiseAndPerfumeStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "8 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress8")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let noiseAndPerFumeLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "noiseAndPerfume_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나는 주로 어떤 편인가요?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private lazy var noiseCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var perfumeCollectionView: UICollectionView = {
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
        let noiseSection = createStackViewWithLabelAndSubview(string: "휴대폰 소리", subview: noiseCollectionView)
        let perfumeSection = createStackViewWithLabelAndSubview(string: "향수", subview: perfumeCollectionView)
        
        view.addSubview(stackView)
        [logoStackView, noiseAndPerfumeStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, noiseAndPerFumeLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [noiseSection, perfumeSection, spacerView, nextButton].forEach{ noiseAndPerfumeStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        noiseCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        perfumeCollectionView.snp.makeConstraints {
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
        
        noiseAndPerFumeLogo.snp.makeConstraints{
            $0.height.equalTo(Double(UIScreen.currentScreenHeight)*0.148)
        }
    }
    
    @objc
    func didClickNextButton() {
        let noiseAndPerfumeOption: [String: Any] = [
            "selectedNoise": selectedNoise ?? "",
            "selectedPerfume": selectedPerfume ?? ""
        ]
        UserDefaults.standard.setMatchingOption(noiseAndPerfumeOption)
        
        // 저장된 정보 로그 출력
        ["selectedNoise", "selectedPerfume"].forEach {
            print("\($0): \(UserDefaults.standard.getMatchingOptionValue(forKey: $0) ?? "")")
        }
        self.navigationController?.pushViewController(StudyStyleViewController(), animated: true)
    }
    
}

extension NoiseAndPerfumeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case noiseCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: noise[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: perfume[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension NoiseAndPerfumeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfinter:Int = noise.count - 1
        let interSpacing:Int = 8
        let cellSize = CGSize(width: (UIScreen.screenWidthLayoutGuide - numberOfinter * interSpacing) / 3, height: 48)

        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case noiseCollectionView:
            selectedNoise = noise[indexPath.item]
            print("Noise: \(noise[indexPath.item]) 선택")
        case perfumeCollectionView:
            selectedPerfume = perfume[indexPath.item]
            print("Perfume: \(perfume[indexPath.item]) 선택")
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case noiseCollectionView:
            selectedNoise = nil
            print("Noise: \(noise[indexPath.item]) 선택 해제")
        case perfumeCollectionView:
            selectedPerfume = nil
            print("Perfume: \(perfume[indexPath.item]) 선택 해제")
        default:
            print("default")
        }
    }
}
