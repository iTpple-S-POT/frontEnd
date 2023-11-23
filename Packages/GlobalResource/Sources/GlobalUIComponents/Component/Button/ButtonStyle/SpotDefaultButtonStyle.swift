//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import DefaultExtensions

public extension ButtonStyle where Self == SpotDefaultButtonStyle<PerfectRoundedRectangle> {
    /// 해당 스타일을 적용하기전 라벨의 frame을 지정해주세요
    static func spotDefault(backgroundColor: Color) -> some ButtonStyle {
        SpotDefaultButtonStyle(btnShape: PerfectRoundedRectangle(), backgroundColor: backgroundColor)
    }
}

internal extension ShapeStyle where Self == Color {
    static var btnColorWhenPressed: Color { Color(hex: "221E1D") }
}

/// 버튼을 클릭시  색상이 #221E1D이고 투명도가 20%인 전달받은 Shape형태로 버튼이 덮힙니다.
public struct SpotDefaultButtonStyle<ButtonShape: Shape>: ButtonStyle {
    let btnShape: ButtonShape
    let backgroundColor: Color
    
    public init(btnShape: ButtonShape, backgroundColor: Color) {
        self.btnShape = btnShape
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                PerfectRoundedRectangle()
                    .fill(backgroundColor)
            )
            .overlay {
                Rectangle()
                    .fill(configuration.isPressed ? .btnColorWhenPressed.opacity(0.2) : .clear)
                    .clipShape(btnShape)
                    .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
            }
    }
}

/// 양옆이 원처럼 둥근 Rounded Rectangle입니다.
public struct PerfectRoundedRectangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let middleTopPoint = CGPoint(x: rect.midX, y: rect.minY)
        let radius = rect.maxY/2
        
        path.move(to: middleTopPoint)
        path.addLine(to: CGPoint(x: radius, y: rect.minY))
        
        let leftCircleCenter = CGPoint(x: radius, y: rect.midY)
        
        path.addArc(center: leftCircleCenter, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.maxX-radius, y: rect.maxY))
        
        let rightCircleCenter = CGPoint(x: rect.maxX-radius, y: rect.midY)
        
        path.addArc(center: rightCircleCenter, radius: radius, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        
        path.addLine(to: middleTopPoint)
        path.closeSubpath()
        
        return path
    }
}
