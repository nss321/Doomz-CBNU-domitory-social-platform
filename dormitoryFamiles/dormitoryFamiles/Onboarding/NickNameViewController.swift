//
//  NickNameViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/06/20.
//

import UIKit

final class NickNameViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countTextFieldTextLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var availableLabel: UILabel!
    private let textFieldMaxLength = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUnauthenticatedState()
        textField.delegate = self
        
        textField.font = UIFont.subTitle1
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setTextField() {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/12"
    }
    
    private func changeFinishButtonBackgroundColor() {
        if countTextFieldTextLabel.text?.first == "0" {
            checkButton.backgroundColor = .gray3
        }else{
            checkButton.backgroundColor = .primary
        }
        
    }
    
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.backgroundColor == .gray3 {
            //중복확인이 활성화 되지 않았다면 아무런 반응이 없도록
        }else {
            //중복확인이 활성화 되었을때
            if availableNickname(nickName: textField.text ?? "") {
                changeAuthenticatedState()
            }else {
                availableLabel.isHidden = false
                availableLabel.text = "사용 불가능한 닉네임이에요. 다시 입력해주세요."
                textField.layer.borderWidth = 1
                textField.layer.borderColor = .init(red: 255, green: 126, blue: 141, alpha: 1)
            }
        }
    }
    
    private func availableNickname(nickName: String) -> Bool {
        //TODO: 백앤드api기다리는중
        return true
        
    }
    
    private func changeUnauthenticatedState() {
        checkImage.isHidden = true
        nextButton.backgroundColor = .gray3
        availableLabel.isHidden = true
        countTextFieldTextLabel.isHidden = false
        checkButton.backgroundColor = .gray3
        checkButton.tintColor = .white
        nextButton.isEnabled = false
    }
    
    private func changeAuthenticatedState() {
        nextButton.backgroundColor = .primary
        checkButton.backgroundColor = .gray3
        checkImage.isHidden = false
        countTextFieldTextLabel.isHidden = true
        availableLabel.isHidden = false
        nextButton.isEnabled = true
    }
    
}

extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        countTextFieldTextLabel.text = String(textField.text!.count) + "/" + String(textFieldMaxLength)
        let text = textField.text ?? ""
        if text.count > textFieldMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textFieldMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
        changeUnauthenticatedState()
        if textField.text != "" {
            checkButton.backgroundColor = .primary
        }else {
            checkButton.backgroundColor = .gray3
        }
    }
    
}
