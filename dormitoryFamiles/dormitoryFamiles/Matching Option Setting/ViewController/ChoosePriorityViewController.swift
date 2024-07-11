//
//  ChoosePriorityViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/9/24.
//

import UIKit
import SnapKit

final class ChoosePriorityViewController: UIViewController, ConfigUI {
    
    let priorities = [
        "취침 시간", "기상 시간", "잠버릇", "흡연 여부", "음주 빈도", "샤워 시간대", "청소 빈도", "더위", "추위", "본가가는 빈도",
        "야식", "휴대폰소리", "향수", "벌레"
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let string = "높은 우선순위대로 선택해주세요!"
        let attributedString = NSMutableAttributedString(string: string)
        
        attributedString.addAttributes([
            .font: FontManager.title2(),
            .foregroundColor: UIColor.doomzBlack
        ], range: NSRange(location: 0, length: 9))
        
        attributedString.addAttributes([
            .font: FontManager.body3(), 
            .foregroundColor: UIColor.doomzBlack
        ], range: NSRange(location: 10, length: 7))
        
        label.attributedText = attributedString
        label.textAlignment = .center
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "룸메 매칭에 도움이 됩니다.( 최소 4개까지 선택 가능 )"
        label.font = FontManager.body2()
        label.textAlignment = .center
        label.textColor = .gray4
        label.addCharacterSpacing()
        return label
    }()

    private lazy var prioritiesCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(PriorityCell.self, forCellWithReuseIdentifier: PriorityCell.identifier)
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
        setupNavigationBar("룸메 우선순위설정")
        addComponents()
        setConstraints()
        nextButton.setup(model: nextButtonModel)
    }
    
    func addComponents() {
        [titleLabel, contentLabel, prioritiesCollectionView, nextButton].forEach{ view.addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        
        prioritiesCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(158)
        }
        
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    @objc
    func didClickNextButton() {
        print("next")
//        self.navigationController?.pushViewController(MiscViewController(), animated: true)
    }
    
}

extension ChoosePriorityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriorityCell.identifier, for: indexPath) as? PriorityCell else { fatalError() }
        cell.configure(with: priorities[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return priorities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension ChoosePriorityViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.screenWidthLayoutGuide - 16) / 2, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(collectionView):  \(indexPath.row) 선택")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselect")
    }
    
}


