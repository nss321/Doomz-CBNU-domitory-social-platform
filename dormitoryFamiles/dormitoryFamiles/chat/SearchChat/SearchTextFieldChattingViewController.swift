//
//  SearchTextFieldChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class SearchTextFieldChattingViewController: UIViewController {
    
    private let navigationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력해주세요."
        textField.font = .subTitle2
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        setDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationTextField.becomeFirstResponder()
    }
    
    private func setNavigationBar() {
        let containerView = RoundLabel()
        containerView.backgroundColor = .gray0
        containerView.isUserInteractionEnabled = true
        
        navigationItem.titleView = containerView
        
        containerView.addSubview(navigationTextField)
        navigationTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
    }
    
    private func setDelegate() {
        navigationTextField.delegate = self
    }
}

extension SearchTextFieldChattingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //리턴 버튼이 눌린다면
        //이전 화면의 keyword변경
        
        //이전화면으로 돌아가면서 willAppear 실행시키도록
        return true
    }
}
