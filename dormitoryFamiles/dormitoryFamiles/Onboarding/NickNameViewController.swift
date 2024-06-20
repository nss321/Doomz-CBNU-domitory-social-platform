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
    let textFieldMaxLength = 12
    
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
            }
        }
    }
    
    private func availableNickname(nickName: String) -> Bool {
        //TODO: 기획쪽에서 닉네임 규칙이 정해지면 업데이트 해야함 지금은 무조건 되게 처리
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
