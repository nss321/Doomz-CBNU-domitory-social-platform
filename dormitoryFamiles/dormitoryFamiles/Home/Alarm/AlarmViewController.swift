//
//  AlarmViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/30/24.
//

import UIKit

class AlarmViewController: UIViewController, ConfigUI {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addComponents()
        setConstraints()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar("알림")
    }
    
    func addComponents() {
        
    }
    
    func setConstraints() {
        
    }

}
