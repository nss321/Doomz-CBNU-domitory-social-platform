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
        
        setTintAdjustmentModeForButtons(in: self.view)
        //        for family in UIFont.familyNames {
        //            print(family)
        //            for name in UIFont.fontNames(forFamilyName: family) {
        //                print(name)
        //            }
        //        }
        
    }
    
    
    
    //액션시트를 동작하였을때 버튼의 컬러가 변하지 않게 하는 함수
    func setTintAdjustmentModeForButtons(in view: UIView) {
        //받아온 뷰를 돌며 타입이 버튼이거나 버튼을 상속받은 엘리먼트들만
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.tintAdjustmentMode = .normal
            }
            //버튼이 아니라면 그 내부를 또 탐색
            setTintAdjustmentModeForButtons(in: subview)
        }
    }
    
    
    
    func setDormitoryButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .init(4)
        dormitoryButton.configuration = configuration
        dormitoryButton?.tintAdjustmentMode = .normal
    }
    
    
    
    @IBAction func menuButtonTapped(_ sender: RoundButton) {
        
        [morningButton, lunchButton, dinnerButton].forEach{
            $0?.backgroundColor = .secondary
            $0?.tintColor = .black
        }
        sender.backgroundColor = .white
        sender.tintColor = .primary
    }
    
    
    
    @IBAction func dormitoryButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "기숙사 선택", preferredStyle: .actionSheet)
        let dormitories = ["개성재", "양성재", "양진재"]
        
        for dormitory in dormitories {
            let action = UIAlertAction(title: dormitory, style: .default) { _ in
                self.dormitoryButton.head2 = dormitory
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
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
