//
//  profileSettingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/25.
//

import UIKit
import DropDown

final class ProfileSettingViewController: UIViewController {
    
    let array: [(abstract: String, detail: [String])] =
    [("인문대학",["국어국문학과", "중어중문학과", "영어영문학과", "독일언어문화학과", "프랑스언어문화학과", "러시안언어문화학과", "철학과", "사학과", "고고미술사학과"]),
     ("사회과학대학", ["사회학과", "심리학과", "행정학과", "정치외교학과", "경제학과"]),
     ("자연과학대학", ["수학과, 정보통계학과", "물리학과", "화학과", "생물학과", "미생물학과", "생화학과", "천문우주학과", "지구환경과학과"]),
     ("경영대학", ["경영학부", "국제경영학과", "경영정보학과"]),
     ("공과대학", ["토목공학부", "기계공학부", "화학공학과", "신소재공학과", "건축공학과", "안전공학과", "환경공학과", "공업화학과", "도시공학과", "건축학과", "테크노산업공학과"]),
     ("전자정보대학", ["전기공학부", "전자공학부", "반도체공학부", "정보통신공학부", "컴퓨터공학과", "소프트웨어학부", "지능로봇공학과"]),
     ("농업생명환경대학", ["산림학과", "지역건설공학과", "바이오시스템공학과", "목재종이과학과", "농업경제학과", "식물자원학과", "환경생명화학과", "축산학과", "식품생명공학과", "특용식물학과", "원예과학과", "식물의학과"]),
     ("사범대학", ["교육학과", "국어교육과", "영어교육과", "역사교육과", "지리교육과", "사회교육과", "윤리교육과", "물리교육과", "화학교육과", "생물교육과", "지구과학교육과", "수학교육과", "체육교육과"]),
     ("생활과학대학", ["식품영양학과", "아동복지학과", "의류학과(패션디자인정보학과)", "주거환경학과", "소비자학과"]),
     ("수의과대학", ["수의예과", "수의학과"]),
     ("약학대학", ["약학과", "제약학과"]),
     ("의과대학", ["의예과", "의학과", "간호학과"]),
     ("바이오헬스공유대학", ["바이오헬스공유대학"]),
     ("자율전공학부", ["자율전공학부"]),
     ("융합학과군(조형예술학과/디자인학과)", ["조형예술학과", "디자인학과"]),
     ("바이오헬스학부", ["바이오헬스학부"])
    ]
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var identifierNumberLabel: UILabel!
    @IBOutlet weak var dormitoryLabel: UILabel!
    let dropDown = DropDown()
    @IBOutlet weak var collegeOfCollegesButton: UIButton!
    @IBOutlet weak var departmentSelectionButton: UIButton!
    @IBOutlet weak var dormitoryButton: UIButton!
    @IBOutlet weak var nextButton: RoundButton!
    
    @IBOutlet weak var studentNumberTextField: UITextField!
    private var departmentObserver: NSKeyValueObservation?
    private var collegeOfCollegesObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfield()
        departmentObserver = departmentSelectionButton.titleLabel?.observe(\.text, options: [.new, .old], changeHandler: { [weak self] (label, change) in
            if let newText = change.newValue {
                self?.departmentTextDidChange(newText: newText)
            }
        })
        collegeOfCollegesObserver = collegeOfCollegesButton.titleLabel?.observe(\.text, options: [.new, .old], changeHandler: { [weak self] (label, change) in
            if let newText = change.newValue {
                self?.collegeOfCollegesTextDidChange(newText: newText)
            }
        })
        [universityLabel, departmentLabel, identifierNumberLabel, dormitoryLabel].forEach{$0.asColor(targetString: ["*"], color: .primary!)}
        setDropDown()
        nextButton.isEnabled = false
        dormitoryButton.setTitle("진리관", for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setTextfield() {
        studentNumberTextField.delegate = self
        studentNumberTextField.keyboardType = .numberPad
        studentNumberTextField.autocorrectionType = .no
        studentNumberTextField.spellCheckingType = .no
    }
    
    @objc private func dismissKeyboard() {
          view.endEditing(true)
      }
    
    private func  departmentTextDidChange(newText: String?) {
        if (newText != "학과선택") && (studentNumberTextField.text != "") {
        } else {
        }
        updateButtonTitleColors() // 버튼 타이틀 색상 업데이트
        enableNextButton()
    }
    
    private func collegeOfCollegesTextDidChange(newText: String?) {
        departmentSelectionButton.setTitle("학과선택", for: .normal)
        updateButtonTitleColors() // 버튼 타이틀 색상 업데이트
        enableNextButton()
        
    }
    
    private func updateButtonTitleColors() {
        if collegeOfCollegesButton.currentTitle == "단과대학교" {
            collegeOfCollegesButton.setTitleColor(.gray4, for: .normal)
        } else {
            collegeOfCollegesButton.setTitleColor(.black, for: .normal)
        }
        
        if departmentSelectionButton.currentTitle == "학과선택" {
            departmentSelectionButton.setTitleColor(.gray4, for: .normal)
        } else {
            departmentSelectionButton.setTitleColor(.black, for: .normal)
        }
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
    
    @IBAction func showDropDown(_ sender: UIButton) {
        
        //버튼에 따라 데이터 소스 세팅
        switch sender {
        case collegeOfCollegesButton:
            dropDown.dataSource = self.array.map { $0.abstract }
        case departmentSelectionButton:
            if let collegeTitle = collegeOfCollegesButton.currentTitle {
                for element in self.array {
                    if element.abstract == collegeTitle {
                        dropDown.dataSource = element.detail
                        break
                    }
                }
            }
        case dormitoryButton:
            dropDown.dataSource = ["진리관","정의관","개척관","계영원","지선관","명덕관","신민관","인의관","예지관","등용관"]
        default:
            dropDown.dataSource = []
        }
        
        //공통된 작업
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!-5))
        
        if sender == departmentSelectionButton && collegeOfCollegesButton.currentTitle == "단과대학교"{
            return
        }else {
            sender.borderColor = .primaryMid
        }
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.setTitle(item, for: .normal)
            sender.borderColor = .gray1
            //enableNextButton()
        }
        
        dropDown.cancelAction = { [weak self] in
            self?.collegeOfCollegesButton.borderColor = .gray1
            self?.departmentSelectionButton.borderColor = .gray1
            self?.dormitoryButton.borderColor = .gray1
        }
        
    }
    
    private func enableNextButton() {
        if (departmentSelectionButton.currentTitle != "학과선택") && (studentNumberTextField.text != "") {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .primary
            UserInformation.shared.setProfile(collegeType: collegeOfCollegesButton.currentTitle ?? "", departmentType: departmentSelectionButton.currentTitle ?? "", studentNumber: Int(studentNumberTextField.text ?? "") ?? 0, dormitoryType: dormitoryButton.currentTitle ?? "")
        }else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray3
        }
    }
    
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textFieldMaxLength = 10
        let text = textField.text ?? ""
        if text.count > textFieldMaxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: textFieldMaxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
        enableNextButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
