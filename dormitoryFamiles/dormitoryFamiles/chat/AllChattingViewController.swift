//
//  AllChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit

class AllChattingViewController: UIViewController {

    let sampleData = [
        "code": 200,
        "data": [
            "totalPageNumber": 1,
            "nowPageNumber": 0,
            "isLast": true,
            "memberProfiles": [
                [
                    "memberId": 5,
                    "nickname": "유림잉",
                    "profileUrl": "https://dormitory-family-images-bucket.s3.ap-northeast-2.amazonaws.com/a0345319-feff-4998-b098-b2322261acba_IMG_0338.JPG"
                ],
                [
                    "memberId": 3,
                    "nickname": "해나짱",
                    "profileUrl": "http://k.kakaocdn.net/dn/cTaX1s/btsFAgXr5mH/n2AXHaWczRKt2Fxmt8hJMk/img_640x640.jpg"
                ]
            ]
        ]
    ] as [String : Any]
    
    let followingLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let allDoomzLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "전체둠즈", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let chattingRoomLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "채팅방", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let messageLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "메세지", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        setConstraints()
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, allDoomzLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, messageLabelAndButtonStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        followingLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
    }
}
