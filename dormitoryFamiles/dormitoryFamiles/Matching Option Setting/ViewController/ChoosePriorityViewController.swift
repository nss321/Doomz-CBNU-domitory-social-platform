//
//  ChoosePriorityViewController.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/9/24.
//

import UIKit
import SnapKit

final class ChoosePriorityViewController: UIViewController, ConfigUI {
    
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
//
//    private lazy var prioritiesCollectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        view.register(SleepPatternCollectionViewCell.self, forCellWithReuseIdentifier: SleepPatternCollectionViewCell.identifier)
//        view.backgroundColor = .clear
//        view.dataSource = self
//        view.delegate = self
//        return view
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar("룸메 우선순위설정")
        addComponents()
        setConstraints()
    }
    
    func addComponents() {
        [titleLabel, contentLabel].forEach{ view.addSubview($0) }
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
    }
    
}
//
//extension ChoosePriorityViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        switch collectionView {
//        case bedTiemCollectionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
//            cell.configure(with: goToSleepTimes[indexPath.row])
//            return cell
//        case wakeupTimeCollcetionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
//            cell.configure(with: wakeupTimes[indexPath.row])
//            return cell
//        case sleepingHabitsCollectionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCircleCollectionViewCell.identifier, for: indexPath) as? SleepPatternCircleCollectionViewCell else { fatalError() }
//            cell.configure(with: habits[indexPath.row])
//            return cell
//        case sleepSensitivityCollectionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
//            cell.configure(with: sensitivity[indexPath.row])
//            return cell
//            
//        default:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SleepPatternCollectionViewCell.identifier, for: indexPath) as? SleepPatternCollectionViewCell else { fatalError() }
//            cell.configure(with: goToSleepTimes[indexPath.row])
//            return cell
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let numberOfItem: Int
//        
//        switch collectionView {
//        case sleepingHabitsCollectionView:
//            numberOfItem = habits.count
//        case sleepSensitivityCollectionView:
//            numberOfItem = sensitivity.count
//        default:
//            numberOfItem = goToSleepTimes.count
//        }
//        return numberOfItem
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        let lineSpacing: CGFloat
//        
//        switch collectionView {
//        case sleepingHabitsCollectionView, sleepSensitivityCollectionView:
//            lineSpacing = 0
//        default:
//            lineSpacing = 8
//        }
//        return lineSpacing
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        let interSpacing: CGFloat
//        
//        switch collectionView {
//        case sleepingHabitsCollectionView:
//            interSpacing = 15
//        default:
//            interSpacing = 8
//        }
//        return interSpacing
//    }
//}
//
//extension ChoosePriorityViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize: CGSize
//        
//        switch collectionView {
//        case sleepingHabitsCollectionView:
//            // MARK: cell 간격
//            cellSize = CGSize(width: (currentScreenWidth - 86) / 4, height: (currentScreenWidth - 86) / 4 )
//        default:
//            cellSize = CGSize(width: (currentScreenWidth - 58) / 3, height: 48)
//        }
//        return cellSize
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView {
//        case bedTiemCollectionView:
//            print("\(collectionView)의 \(indexPath.row) 선택")
//        case wakeupTimeCollcetionView:
//            print("\(collectionView)의 \(indexPath.row) 선택")
//        case  sleepingHabitsCollectionView:
//            print("\(collectionView)의 \(indexPath.row) 선택")
//        default:
//            print("\(indexPath.row) 선택")
//        }
//        
//    }
//}
