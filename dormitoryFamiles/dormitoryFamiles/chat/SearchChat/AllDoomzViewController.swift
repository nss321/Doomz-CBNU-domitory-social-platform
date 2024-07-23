//
//  AllDoomzViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class AllDoomzViewController: UIViewController {
    private var allDoomzData: [MemberProfile] = []
    private var allDoomzPage = 0
    private var isAllDoomzLast = false
    
    let allDoomzLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "전체 둠즈"
        return label
    }()
    
    let allDoomzCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .vertical)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        addComponents()
        setConstraints()
        allDoomzApiNetwork(url: Url.allDoomz(page: allDoomzPage, size: nil))
    }
    
    private func setCollectionView() {
        allDoomzCollectionView.delegate = self
        allDoomzCollectionView.dataSource = self
    }
    
    private func addComponents() {
        [allDoomzLabel, allDoomzCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        allDoomzLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        allDoomzCollectionView.snp.makeConstraints{
            $0.top.equalTo(allDoomzLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
        }
    }
    
    private func allDoomzApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<AllDoomzResponse, Error>) in
            switch result {
            case .success(let response):
                self.allDoomzData += response.data.memberProfiles
                //self.isAllDoomzLast = response.data.isLast
                DispatchQueue.main.async {
                    self.allDoomzCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
extension AllDoomzViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDoomzData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
        
        let profile = allDoomzData[indexPath.row]
        cell.configure(text: profile.nickname, profileUrl: profile.profileUrl)
        return cell
    }
}
