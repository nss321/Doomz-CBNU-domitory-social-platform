//
//  homeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/14.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var todayMenuLabel: UILabel!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    @IBOutlet weak var morningButton: RoundButton!
    
    @IBOutlet weak var lunchButton: RoundButton!
    
    @IBOutlet weak var dinnerButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuLabel.sizeToFit()
        self.menuLabel.lineSpacing(12)
        self.menuLabel.textAlignment = .center
        
        setDormitoryButton()
       
        
        let stackViewBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -16)
        stackViewBottomConstraint.isActive = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        for family in UIFont.familyNames {
//            print(family)
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print(name)
//            }
//        }
        
    }
    
    func setDormitoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .init(4)
        dormitoryButton.configuration = configuration
    }
    
    @IBAction func setDormitoryButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func menuButtonTapped(_ sender: RoundButton) {
        
        [morningButton, lunchButton, dinnerButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        
        sender.backgroundColor = .white
        sender.tintColor = .primary
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
