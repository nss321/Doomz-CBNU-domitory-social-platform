//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit

class registerPostViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setNavigationBar()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
   

}
