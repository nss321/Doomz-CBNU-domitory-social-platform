//
//  FontManager.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit

enum FontSize: CGFloat {
    case fourTeen = 14
    case sixTeen = 14
    case eightTeen = 14
    case twenty = 14
    case twentyFour = 14
}

enum PretendardType: String {
    case variable = "PretendardVariable"
    case bold = "Pretendard-Bold"
    case semiBold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

enum NPSType: String {
    case bold = "NPSfont_bold"
}

struct FontManager {
    static let shared = FontManager()
     
    func pretendard(_ type: PretendardType, _ size: FontSize) -> UIFont {
        return UIFont(name: type.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
    func nps(_ type: NPSType, _ size: FontSize) -> UIFont {
        return UIFont(name: type.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
}

extension FontManager {
    static func head1() -> UIFont {
        FontManager.shared.nps(.bold, .twentyFour)
    }
    static func head2() -> UIFont {
        FontManager.shared.nps(.bold, .twenty)
    }
    static func title1() -> UIFont {
        FontManager.shared.pretendard(.bold, .twenty)
    }
    static func title2() -> UIFont {
        FontManager.shared.pretendard(.bold, .eightTeen)
    }
    static func title3() -> UIFont {
        FontManager.shared.pretendard(.semiBold, .eightTeen)
    }
    static func title4() -> UIFont {
        FontManager.shared.pretendard(.bold, .sixTeen)
    }
    static func title5() -> UIFont {
        FontManager.shared.pretendard(.semiBold, .sixTeen)
    }
    static func subtitle1() -> UIFont {
        FontManager.shared.pretendard(.medium, .sixTeen)
    }
    static func subtitle2() -> UIFont {
        FontManager.shared.pretendard(.medium, .fourTeen)
    }
    static func body1() -> UIFont {
        FontManager.shared.pretendard(.regular, .sixTeen)
    }
    static func body2() -> UIFont {
        FontManager.shared.pretendard(.regular, .fourTeen)
    }
    static func button() -> UIFont {
        FontManager.shared.pretendard(.medium, .fourTeen)
    }
    
}
