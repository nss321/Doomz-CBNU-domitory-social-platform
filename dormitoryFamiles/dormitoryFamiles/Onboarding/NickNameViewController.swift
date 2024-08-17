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
    private let textFieldMaxLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUnauthenticatedState()
        setTextField()
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setTextField() {
        textField.delegate = self
        textField.font = UIFont.subTitle1
        self.textField.clipsToBounds = true
        self.textField.layer.cornerRadius = 12
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
    }
    
    private func changeFinishButtonBackgroundColor() {
        if countTextFieldTextLabel.text?.first == "0" {
            checkButton.backgroundColor = .gray3
        }else{
            checkButton.backgroundColor = .primary
        }
        
    }
    
    @objc private func dismissKeyboard() {
          view.endEditing(true)
      }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.backgroundColor == .gray3 {
            // 중복확인이 활성화 되지 않았다면 아무런 반응이 없도록
        } else {
            // 중복확인이 활성화 되었을 때
            guard let nickname = textField.text, !nickname.isEmpty else { return }
            checkNicknameAvailability(nickname: nickname)
        }
    }
    
    private func checkNicknameAvailability(nickname: String) {
        nicknameApi(url: Url.getNickname(nickname: nickname), nickname: nickname) { [weak self] isAvailable in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if isAvailable {
                    self.changeAuthenticatedState()
                    self.availableLabel.text = "사용 가능한 닉네임이예요."
                    self.textField.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor
                    UserInformation.shared.setNickname(text: nickname)
                } else {
                    self.availableLabel.isHidden = false
                    self.availableLabel.text = "사용 불가능한 닉네임이에요. 다시 입력해주세요."
                    self.textField.layer.borderColor = UIColor(red: 255/255, green: 126/255, blue: 141/255, alpha: 1).cgColor
                }
            }
        }
    }
    
    private func nicknameApi(url: String, nickname: String, completion: @escaping (Bool) -> Void) {
        Network.getMethod(url: url) { (result: Result<NicknameResponse, Error>) in
            switch result {
            case .success(let response):
                completion(!response.data.isDuplicated)
            case .failure(let error):
                print("Error: \(error)")
                completion(false)
            }
        }
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
    
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
}
