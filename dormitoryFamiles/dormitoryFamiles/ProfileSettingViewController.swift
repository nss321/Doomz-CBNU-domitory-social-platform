//
//  profileSettingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import UIKit
import DropDown

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var identifierNumberLabel: UILabel!
    
    @IBOutlet weak var dormitoryLabel: UILabel!
    
    @IBOutlet weak var kindUnicersityButton: UIButton!
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [universityLabel, departmentLabel, identifierNumberLabel, dormitoryLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
        setDropDown()
        setDropDown()
    }
    
    private func setDropDown() {
        dropDown.dataSource = ["아~","뭐~"]
        DropDown.startListeningToKeyboard()
        dropDown.anchorView = kindUnicersityButton
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0


         
        

    }

    @IBAction func kindUniversityButtonTapped(_ sender: UIButton) {
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            kindUnicersityButton.setTitle(item, for: .normal)
        }
    }
}
