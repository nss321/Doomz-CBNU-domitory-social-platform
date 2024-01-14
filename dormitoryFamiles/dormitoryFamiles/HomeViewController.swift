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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuLabel.sizeToFit()
//        let stackViewBottomConstraint = timeLabel.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 16)
//        stackViewBottomConstraint.isActive = true
        
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
