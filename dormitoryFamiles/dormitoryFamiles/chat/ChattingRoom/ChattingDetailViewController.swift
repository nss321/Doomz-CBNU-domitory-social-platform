//
//  ChattingDetailViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit

class ChattingDetailViewController: UIViewController, ConfigUI {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        addComponents()
        setConstraints()
    }
    
    private func setNavigationBar() {
      
        let moreImage = UIImage(named: "chattingDetailMore")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(moreButtonTapped))
    }
    
    func addComponents() {
        
    }
    
    func setConstraints() {
        
    }
    
    @objc func moreButtonTapped() {
        dump("moreButtonTapped")
    }

}
