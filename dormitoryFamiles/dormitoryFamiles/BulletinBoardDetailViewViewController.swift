//
//  BulletinBoardDetailViewViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/13.
//

import UIKit

class BulletinBoardDetailViewViewController: UIViewController {
    @IBOutlet weak var roundLine: UIView!
    
    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.font = .body2
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
