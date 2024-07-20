//
//  ChattingDetailViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit
import Kingfisher

class ChattingDetailViewController: UIViewController, ConfigUI {
    
    private var profileStackView: ChattingNavigationProfileStackView!
    var profileImageUrl: String?
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addComponents()
        setConstraints()
    }
    
    private func createProfileStackView() -> ChattingNavigationProfileStackView {
        profileStackView = ChattingNavigationProfileStackView(frame: .zero)
        if let url = profileImageUrl, let nickname = nickname {
            loadImage(url: url)
            self.profileStackView.configure(nickname: nickname)
        }
        return profileStackView
    }

    private func setNavigationBar() {
        let profileStackView = createProfileStackView()
        self.navigationItem.titleView = profileStackView
        let moreImage = UIImage(named: "chattingDetailMore")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(moreButtonTapped))
    }
    
    private func loadImage(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        self.profileStackView.profileImageView.kf.setImage(with: imageUrl)
    }
    
    func addComponents() {
        
    }
    
    func setConstraints() {
        
    }
    
    @objc func moreButtonTapped() {
        print("moreButtonTapped")
    }
    
}
