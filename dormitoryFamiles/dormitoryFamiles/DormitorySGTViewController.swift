//
//  DormitorySGTViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/03.
//

import UIKit

class DormitorySGT {

    static let shared = DormitorySGT()
    var kind = "본관"
    private init() {
           
        }
    
    @objc func dormitoryChangeNotification(_ notification: Notification) {
        if notification.object is String {
            dormitoryButton.head1 = SelectedDormitory.shared.domitory
            dormitoryButton.setTitle(SelectedDormitory.shared.domitory, for: .normal)
        }
    
    func changeKind(_ kind: Dormitory) {
        self.kind = kind.rawValue
    }

}
