//
//  FontManager.swift
//  dormitoryFamiles
//
//  Created by BAE on 3/16/24.
//

import UIKit

enum FontSize: CGFloat {
    case fourTeen = 14
    case sixTeen = 16
    case eightTeen = 18
    case twenty = 20
    case twentyFour = 24
}

enum PretendardType: String {
    case variable = "PretendardVariable"
    case bold = "PretendardVariable-Bold"
    case semiBold = "PretendardVariable-SemiBold"
    case medium = "PretendardVariable-Medium"
    case regular = "PretendardVariable-Regular"
}

enum NPSType: String {
    case bold = "NPS-font-Bold"
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
    static func body3() -> UIFont {
        FontManager.shared.pretendard(.regular, .eightTeen)
    }
    static func button() -> UIFont {
        FontManager.shared.pretendard(.medium, .fourTeen)
    }
    
}
