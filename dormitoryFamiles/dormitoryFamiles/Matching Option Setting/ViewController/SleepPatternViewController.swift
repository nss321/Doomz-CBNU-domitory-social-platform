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
        "오전 1시", "오전 2시", "오전 3시 이후"
    ]
    
    let wakeupTimes: [String] = [
        "오전 4시 이전", "오전 4시", "오전 5시",
        "오전 6시", "오전 7시", "오전 8시",
        "오전 9시", "오전 10시", "오전 10시 이후"
    ]
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 38
        view.alignment = .center
        view.borderColor = .green
        view.borderWidth = 1
        return view
    }()
    
    private let logoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .center
        view.borderColor = .blue
        view.borderWidth = 1
        return view
    }()
    
    private let currentStep: UILabel = {
        let label = UILabel()
        label.text = "1 / 10"
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1
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
        view.borderColor = .red
        view.borderWidth = 1
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var testCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var test2CollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addComponents()
        setConstraints()
        setupNavigationBar("긱사생활 설정")
    }
    
    func addComponents() {
        let test =  createStackViewWithLabelAndSubview(string: "취침시간", subview: testCollectionView)
        let test2 =  createStackViewWithLabelAndSubview(string: "기상시간", subview: test2CollectionView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [logoStackView, sleepPatternStackView].forEach{ stackView.addArrangedSubview($0) }
        [currentStep, progressBar, sleepPatternLogo, contentLabel].forEach { logoStackView.addArrangedSubview($0) }
        [test, test2].forEach { sleepPatternStackView.addArrangedSubview($0) }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        testCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(160)
        }
        
        test2CollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalTo(view.snp.width).inset(20)
            $0.height.equalTo(160)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}

extension SleepPatternViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
        
        switch collectionView {
        case testCollectionView:
            cell.configure(with: goToSleepTimes[indexPath.row])
        case test2CollectionView:
            cell.configure(with: wakeupTimes[indexPath.row])
        default:
            cell.configure(with: goToSleepTimes[indexPath.row])
        }
        //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
        //
        //        if collectionView == testCollectionView {
        //            cell.configure(with: goToSleepTimes[indexPath.row])
        //        } else {
        //            cell.configure(with: wakeupTimes[indexPath.row])
        //        }
        //        return cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goToSleepTimes.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
    
extension SleepPatternViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 106, height: 48)
    }
}
    
extension SleepPatternViewController {
    func createStackViewWithLabelAndSubview(string: String, subview: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        
        let label = UILabel()
        label.text = string
        label.font = FontManager.subtitle1()
        label.textColor = .gray5
        label.addCharacterSpacing()
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(subview)
        
        return stackView
    }
}

