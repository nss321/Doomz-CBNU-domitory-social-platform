//
//  ViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import UIKit

final class MealMenuViewController: UIViewController {
    
    @IBOutlet weak var weekDateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        weekDateLabel.button = DateUtility.weekRangeString()
    }
    
}
