//
//  profileSettingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var identifierNumberLabel: UILabel!
    
    @IBOutlet weak var dormitoryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        [universityLabel, departmentLabel, identifierNumberLabel, dormitoryLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
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
