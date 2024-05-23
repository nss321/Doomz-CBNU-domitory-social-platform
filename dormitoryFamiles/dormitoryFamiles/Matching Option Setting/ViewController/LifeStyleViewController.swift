//
//  LifeStyleViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 4/16/24.
//

import UIKit
import SnapKit

final class LifeStyleViewController: UIViewController, ConfigUI {
    
    let shower = ["아침", "저녁"]
    let cleanHabit = ["바로바로", "가끔", "몰아서"]
    let currentScreenWidth:  CGFloat = UIScreen.main.bounds.width
    
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
    
    private let lifeStyleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 28
        view.alignment = .center
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "3 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        return label
    }()
    
    private let progressBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "progress3")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let lifeStyleLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "lifeStyle_logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 생활방식은?"
        label.font = FontManager.title2()
        label.textAlignment = .center
        label.textColor = .doomzBlack
        label.addCharacterSpacing()
        return label
    }()
    
    private let showerTimeSlider: CustomSlider = {
        let slider = CustomSlider()
        
        if let minTrackImage = UIImage(named: "trackImage")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3), resizingMode: .stretch) {
            slider.setMinimumTrackImage(minTrackImage, for: .normal)
        }
        
        if let thumbImage = UIImage(named: "thumb")?.resized(to: CGSize(width: 16, height: 16)) {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        
        slider.tintColor = .primaryMid
        slider.value = 30
        slider.minimumValue = 0
        slider.maximumValue = 60
        slider.contentMode = .center
        return slider
    }()
    
    private lazy var showerTimeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var cleanHabitCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
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
        let sliderSection = createStackViewWithLabelAndSubview(string: "샤워시간", subview: showerTimeSlider)
        let showerSection = createStackViewWithLabelAndSubview(string: "샤워시간대", subview: showerTimeCollectionView)
        let cleanSection = createStackViewWithLabelAndSubview(string: "청소", subview: cleanHabitCollectionView)
        
        view.addSubview(stackView)
        [logoStackView, lifeStyleStack].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, lifeStyleLogo, contentLabel].forEach{ logoStackView.addArrangedSubview($0) }
        [sliderSection,showerSection, cleanSection, nextButton].forEach{ lifeStyleStack.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        showerTimeCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(48)
        }
        
        cleanHabitCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo((currentScreenWidth - 86) / 4)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        
        showerTimeSlider.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
        }
    }
    
    @objc
    func didClickNextButton() {
        print("nextBtn")
        //        self.navigationController?.pushViewController(SmokeAndAlcoholPatternViewController(), animated: false)
    }
    
}

extension LifeStyleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case showerTimeCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: shower[indexPath.row])
            return cell
        case cleanHabitCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cleanHabit[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: shower[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem: Int
        
        switch collectionView {
        case showerTimeCollectionView:
            numberOfItem = shower.count
        case cleanHabitCollectionView:
            numberOfItem = cleanHabit.count
        default:
            numberOfItem = shower.count
        }
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat = 8
        return interSpacing
    }
}

extension LifeStyleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        
        switch collectionView {
        case showerTimeCollectionView:
            cellSize = CGSize(width: (currentScreenWidth - 48) / 2, height: 48)
        case cleanHabitCollectionView:
            cellSize = CGSize(width: (currentScreenWidth - 56) / 3, height: 48)
        default:
            cellSize = CGSize(width: (currentScreenWidth - 48) / 3, height: 48)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case showerTimeCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        case cleanHabitCollectionView:
            print("\(collectionView)의 \(indexPath.row) 선택")
        default:
            print("\(indexPath.row) 선택")
        }
        
    }
}


