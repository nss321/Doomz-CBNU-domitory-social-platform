//
//  UIScreen+.swift
//  dormitoryFamiles
//
//  Created by BAE on 5/16/24.
//

import UIKit

extension UIScreen {
    static let currentScreenWidth:  Int = Int(UIScreen.main.bounds.width)
    static let currentScreenHeight:  Int = Int(UIScreen.main.bounds.height)
    static let screenWidthLayoutGuide:  Int = Int(UIScreen.main.bounds.width - 40)
    /// 직사각형 셀이 2열일 때 Width 값으로 사용합니다.
    static let cellWidth2Column: Int = Int(UIScreen.main.bounds.width - 48) / 2
    /// 직사각형 셀이 3열일 때 Width 값으로 사용합니다.
    static let cellWidth3Column: Int = Int(UIScreen.main.bounds.width - 56) / 3
    /// 원형 셀의 지름입니다. Width와 Height 값으로 사용할 수 있습니다.
    static let circleCellRadius: Int = Int(UIScreen.main.bounds.width - 86) / 4
    /// 직사각형 셀의 높이입니다.
    static let cellHeight: Int = 48
}
