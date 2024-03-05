//
//  PotReportView.swift
//
//
//  Created by 최준영 on 3/5/24.
//

import SwiftUI
import DefaultExtensions
import GlobalUIComponents

extension ShapeStyle where Self == Color {
    
    static var basicUiColor: Color { Color(hex: "343330", alpha: 0.7) }
    
    static var floatingBackColor: Color { Color(hex: "221E1D", alpha: 0.7) }
    
    static var medium_gray: Color { Color(hex: "C7C7C7") }
    
}

extension UIColor {
    
    static var medium_gray: UIColor { UIColor(hex: "C7C7C7") }
}

enum ReportTypeModel: CaseIterable {
    
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
    
    var koreanString: String {
        
        switch self {
        case .type1:
            "음란물 / 불법 촬영물 유통"
        case .type2:
            "유출 /사칭 / 사기"
        case .type3:
            "욕설 / 비하"
        case .type4:
            "게시물 도배 / 속임수"
        case .type5:
            "부적절한 카테고리"
        case .type6:
            "기타 사항"
        }
    }
    
    var getRequestType: String {
        
        switch self {
        case .type1:
            "INAPPROPRIATE"
        case .type2:
            "SPAM"
        case .type3:
            "INAPPROPRIATE"
        case .type4:
            "SPAM"
        case .type5:
            "INAPPROPRIATE"
        case .type6:
            "OTHER"
        }
    }
    
    
}

struct PotReportView: View {
    
    @State private var showReportTypeScrollView = false
    
    @State private var reportDescription = ""
    
    
    private var viewHeight: CGFloat {
        
        UIScreen.main.bounds.height * 0.7
    }
    
    var body: some View {
        ZStack {
            
            Color.floatingBackColor.opacity(0.7)
                .ignoresSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                // 신고내역 작성뷰
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        RoundedCorners(tl: 10, tr: 10, bl: 0, br: 0)
                            .fill(.white)
                        
                        VStack(alignment: .leading) {
                            
                            // X버튼
                            
                            HStack {
                                
                                Spacer()
                                
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.basicUiColor)
                                    .frame(width: 20)
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        
                                        // Exit
                                    }
                            }
                            .frame(height: 32)
                            
                            Text("신고 사유")
                            
                            HStack {
                                
                                Text("신고 사유를 선택해 주세요")
                                    .padding(.leading, 16)
                                    
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.basicUiColor)
                                    .frame(width: 22, height: 22)
                                    .padding(10)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        
                                        showReportTypeScrollView = true
                                    }
                                
                            }
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1.0)
                            )
                            .overlay {
                                
                                if showReportTypeScrollView {
                                    
                                    GeometryReader { _ in
                                        
                                        VStack(spacing: 0) {
                                            HStack {
                                                
                                                Text("신고 사유를 선택해 주세요")
                                                    .padding(.leading, 16)
                                                    
                                                Spacer()
                                                
                                                Image(systemName: "chevron.up")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundStyle(.basicUiColor)
                                                    .frame(width: 22, height: 22)
                                                    .padding(10)
                                                    .contentShape(Rectangle())
                                                    .onTapGesture {
                                                        
                                                        showReportTypeScrollView = false
                                                    }
                                            }
                                            .frame(height: 56)
                                            
                                            ForEach(ReportTypeModel.allCases, id: \.self) { type in
                                                
                                                HStack {
                                                    
                                                    Text(type.koreanString)
                                                        .font(.system(size: 16))
                                                        .padding(.leading, 16)
                                                        
                                                    Spacer()
                                                }
                                                .frame(height: 56)
                                                .overlay {
                                                    VStack {
                                                        
                                                        Spacer()
                                                        
                                                        Rectangle()
                                                            .fill(.light_gray)
                                                            .frame(height: 1.0)

                                                    }
                                                }
                                            }
                                        }
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.white)
                                                .overlay {
                                                    
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(.gray, lineWidth: 1.0)
                                                }
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                            .zIndex(1.0)
                            
                            
                            Text("신고 내용")
                                .padding(.top, 40)
                            
                            VStack {
                                
                                TextField("", text: $reportDescription, axis: .vertical)
                                    .textFieldStyle(TappableTextFieldStyle(verPadding: 12, horPadding: 12))
                                    .placeholder(when: reportDescription.isEmpty, placeholder: {
                                        DynamicText(
                                            "신고 내용을 작성해 주세요 (250자 이내)",
                                            textColor: .medium_gray,
                                            weight: .semibold,
                                            textAlignment: .left
                                        )
                                        .padding(.horizontal, 12)
                                            .foregroundStyle(.gray)
                                            .frame(height: 20)
                                    })
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                            }
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1.0)
                                )
                            
                            Spacer(minLength: 65)
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .padding(21)
                        
                    }
                    .zIndex(1.0)
                    
                    // 신고하기 버튼
                    Button {
                        
                        
                    } label: {
                        
                        RoundedCorners(tl: 0, tr: 0, bl: 10, br: 10)
                            .fill(.red)
                            .frame(height: 56)
                            .overlay {
                                
                                Text("신고하기")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(height: viewHeight)
                
                Spacer()
            }
            .padding(.horizontal, 21)
        }
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()

        return path
    }
}

struct TappableTextFieldStyle: TextFieldStyle {
    
    @FocusState private var textFieldFocused: Bool
    
    var verPadding: CGFloat
    
    var horPadding: CGFloat
    
    init(verPadding: CGFloat, horPadding: CGFloat) {
        self.verPadding = verPadding
        self.horPadding = horPadding
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, verPadding)
            .padding(.horizontal, horPadding)
            .focused($textFieldFocused)
            .onTapGesture { textFieldFocused = true }
    }
    
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    PotReportView()
}
