import SwiftUI
import DefaultExtensions

extension ShapeStyle where Self == Color {
    
    /// 전체 테마에 사용되는 빨간색
    static var mainScreenRed: Color { Color(hex: "FF533F") }
    
    /// 버튼에  사용되는 라이트 그레이
    static var btn_light_grey: Color { Color(hex: "F5F4F4") }
    
    /// 버튼에 사용되는 레드
    static var btn_red: Color { Color(hex: "FF533F", alpha: 0.5) }
    
    static var btn_red_nt: Color { Color(hex: "FF533F") }
    
    static var medium_gray: Color { Color(hex: "C7C7C7") }
    
    static var regular_gray: Color { Color(hex: "878787") }
    
}

extension UIColor {
    
    static let medium_gray = UIColor(hex: "C7C7C7")
    
}

// 테그 색
extension ShapeStyle where Self == Color {
    
    static var tag_black: Color { Color.black }
    static var tag_red: Color { Color(hex: "FF533F") }
    static var tag_yellow: Color { Color(hex: "FFB800") }
    static var tag_green: Color { Color(hex: "86CC40") }
    static var tag_purple: Color { Color(hex: "D092ED") }
    static var tag_blue: Color { Color(hex: "5EA7FF") }
    
}
