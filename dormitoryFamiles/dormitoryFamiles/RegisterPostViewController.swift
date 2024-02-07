//
//  registerPostViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/08.
//

import UIKit
import DropDown

class RegisterPostViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var dormitoryButton: UIButton!
    
    
    @IBOutlet weak var dormitoryLabel: UILabel!
    
    @IBOutlet weak var bulletinBoardLabel: UILabel!
    
    @IBOutlet weak var countTextFieldTextLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let dropDown = DropDown()
    let textFieldMaxLength = 20
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDropDown()
        setDelegate()
        [dormitoryLabel, bulletinBoardLabel, countTextFieldTextLabel, titleLabel, descriptionLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
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

extension RegisterPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let addedText = string
        let newText = oldText + addedText
        let newTextLength = newText.count

        if newTextLength <= textFieldMaxLength {
            return true
        }

        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)])
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) }
        let separatedCharactersCount = separatedCharacters.count

        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 2 && addedText.isConsonant {
            return true
        }

        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }

        return false
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/" + String(textFieldMaxLength)
        var text = textField.text ?? ""
        if text.count > textFieldMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textFieldMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
    }
}

extension String {
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        
        let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
        
        return consonantScalarRange ~= scalar
    }
}
