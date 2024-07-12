//
//  chattingHomeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/12.
//

import UIKit
import SnapKit

class chattingHomeViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        
        self.navigationItem.title = "채팅"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.head1,
                .foregroundColor: UIColor.doomzBlack // 텍스트 색상 설정
            ]
            self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let chatSearchImage = UIImage(named: "chatSearch")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "bulletinBoardLogo")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: chatSearchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(logoButtonTapped))
        
    }
    
    @objc func searchButtonTapped() {
        print("돋보기 버튼 눌림")
    }
    
    @objc func logoButtonTapped() {
        print("로고 버튼 눌림")
    }
    
   
    
    
}
