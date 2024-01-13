import SwiftUI

extension ShapeStyle where Self == Color {
    
    /// 전체 테마에 사용되는 빨간색
    static var mainScreenRed: Color { Color(hex: "FF533F") }
    
    /// 버튼에  사용되는 라이트 그레이
    static var btn_light_grey: Color { Color(hex: "F5F4F4") }
    
    /// 버튼에 사용되는 레드
    static var btn_red: Color { Color(hex: "FF533F", alpha: 0.5) }
    
    static var btn_red_nt: Color { Color(hex: "FF533F") }
    
    static var midium_gray: Color { Color(hex: "C7C7C7") }
    
}
