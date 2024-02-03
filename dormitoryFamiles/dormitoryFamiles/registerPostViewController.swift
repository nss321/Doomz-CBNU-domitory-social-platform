//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit
import DropDown

class registerPostViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    
    @IBOutlet weak var countTextFieldTextLabel: UILabel!
    
    let dropDown = DropDown()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropDown()
        setDelegate()
        setTextField()
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setDelegate() {
        textField.delegate = self
    }
    
    private func setDropDown() {
        DropDown.startListeningToKeyboard()
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0
        DropDown.appearance().selectionBackgroundColor = .gray0 ?? .white
        DropDown.appearance().textFont = UIFont(name: CustomFonts.defult.rawValue, size: 16)!
        
    }
    
    private func setTextField() {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/20"
    }
    
    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        switch sender {
        case dormitoryButton:
            //TODO: 기숙사 종류 넣어야함
            dropDown.dataSource = ["개성재", "양성재","양진재"]
        case categoryButton:
            dropDown.dataSource = ["도와주세요", "함께해요", "나눔해요", "분실신고"]
        default:
            dropDown.dataSource = []
        }
        
        //공통된 작업
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!-5))
        sender.borderColor = .primaryMid
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
            sender.borderColor = .gray1
        }
    }
}

extension registerPostViewController: UITextFieldDelegate {
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text.count == 20 {
//            return false
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //백스페이스는 언제나 true
        if string.isEmpty {
            countTextFieldTextLabel.text = String(textField.text!.count) + "/20"
            return true
        }
        
        //20글자가 넘어가면 false
        if textField.text!.count == 20 {
            return false
        }
        
        
        countTextFieldTextLabel.text = String(textField.text!.count + string.count) + "/20"
        return true
    }
    
    
}
