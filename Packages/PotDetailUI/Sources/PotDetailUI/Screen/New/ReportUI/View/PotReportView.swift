//
//  PotReportView.swift
//
//
//  Created by 최준영 on 3/5/24.
//

import SwiftUI
import DefaultExtensions
import GlobalUIComponents
import GlobalObjects
import Combine

extension ShapeStyle where Self == Color {
    
    static var basicUiColor: Color { Color(hex: "343330", alpha: 0.7) }
    
    static var floatingBackColor: Color { Color(hex: "221E1D", alpha: 0.7) }
    
    static var medium_gray: Color { Color(hex: "C7C7C7") }
    
}

extension UIColor {
    
    static var medium_gray: UIColor { UIColor(hex: "C7C7C7") }
}

enum PotReportViewState {
    case makingReport
    case waitingResponse
    case checkSuccess
}

struct PotReportView: View {
    
    @Binding var present: Bool
    
    var potId: Int
    
    @StateObject private var reportViewModel = ReportViewModel(apiRequester: APIRequestGlobalObject.shared)
    
    @State private var showReportTypeScrollView = false
    
    @State private var showReportView = true
    
    @State private var viewState: PotReportViewState = .makingReport
    
    @State private var showAlert = false
    
    @State private var alertMessage = ""
    
    @FocusState var focusState
    
    private var isPostable: Bool {
        
        reportViewModel.reportType != nil
    }
    
    init(present: Binding<Bool>, potId: Int) {
        
        self._present = present
        
        self.potId = potId
    }
    
    var body: some View {
        ZStack {
            
            Color.floatingBackColor.opacity(0.7)
                .ignoresSafeArea(.all)
            
            switch viewState {
            case .makingReport:
                VStack {
                    
                    Spacer()
                        .layoutPriority(1.0)
                    
                    // 신고내역 작성뷰
                    VStack(spacing: 0) {
                        
                        ZStack {
                            
                            RoundedCorners(tl: 10, tr: 10, bl: 0, br: 0)
                                .fill(.white)
                            
                            VStack(alignment: .leading) {
                                
                                // X버튼
                                
                                HStack {
                                    
                                    Spacer()
                                    
                                    Image.makeImageFromBundle(bundle: .module, name: "report_xmark", ext: .png)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.basicUiColor)
                                        .frame(width: 20)
                                        .contentShape(Circle())
                                        .onTapGesture {
                                            focusState = false
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                                
                                                present = false
                                            }
                                        }
                                }
                                .frame(height: 32)
                                
                                Text("신고 사유")
                                
                                HStack {
                                    
                                    Text(reportViewModel.reportType?.koreanString ?? "신고 사유를 선택해 주세요")
                                        .padding(.leading, 16)
                                        
                                    Spacer()
                                    
                                    Image.makeImageFromBundle(bundle: .module, name: "report_chevron", ext: .png)
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
                                        .strokeBorder(.gray, lineWidth: 1.0)
                                )
                                .overlay {
                                    
                                    if showReportTypeScrollView {
                                        
                                        GeometryReader { _ in
                                            
                                            VStack(spacing: 0) {
                                                HStack {
                                                    
                                                    Text("신고 사유를 선택해 주세요")
                                                        .padding(.leading, 16)
                                                        
                                                    Spacer()
                                                    
                                                    Image.makeImageFromBundle(bundle: .module, name: "report_chevron", ext: .png)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(.basicUiColor)
                                                        .frame(width: 22, height: 22)
                                                        .padding(10)
                                                        .rotationEffect(.degrees(90), anchor: .center)
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
                                                    .contentShape(Rectangle())
                                                    .onTapGesture {
                                                        
                                                        showReportTypeScrollView = false
                                                        reportViewModel.reportType = type
                                                    }
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
                                            .background {
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.white)
                                            }
                                            .overlay {
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .strokeBorder(.gray, lineWidth: 1.0)
                                            }
                                        }
                                    }
                                }
                                .zIndex(1.0)
                                
                                Text("신고 내용")
                                
                                GeometryReader { geo in
                                    
                                    ScrollView {
                                        
                                        VStack(alignment: .leading) {
                                            
                                            TextField("", text: $reportViewModel.reportDetailString, axis: .vertical)
                                                .textFieldStyle(TappableTextFieldStyle(verPadding: 12, horPadding: 12))
                                                .placeholder(when: reportViewModel.reportDetailString.isEmpty, placeholder: {
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
                                                .focused($focusState)
                                            
                                            Spacer()
                                        }
                                    }
                                    .frame(width: geo.size.width, height: geo.size.height)
                                }
                                .frame(height: 240)
                                
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.gray, lineWidth: 1.0)
                                )
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                    
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .padding(21)
                            
                        }
                        .zIndex(1.0)
                        
                        // 신고하기 버튼
                        Button {
                            
                            focusState = false
                            
                            reportViewModel.postReportRequest(potId: potId)
                            
                            viewState = .waitingResponse
                            
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
                        .disabled(!isPostable)
                    }
                    
                    Spacer()
                        .layoutPriority(1.0)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(.horizontal, 21)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            
                            Spacer()
                            
                            Button("입력 완료") {  focusState = false }
                                .padding(.trailing, 10)
                        }
                    }
                }
                .onReceive(Just(reportViewModel.reportDetailString)) { _ in limitText(250) }
                
            case .waitingResponse:
                EmptyView()
            case .checkSuccess:
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        Color.white
                        
                        VStack {
                            
                            Spacer()
                            
                            VStack(spacing: 5) {
                                
                                Text("팟 신고가")
                            
                                Text("완료되었습니다!")
                            }
                            .font(.system(size: 20, weight: .semibold))
                            
                            Spacer()
                            
                            Text("더욱 좋은 서비스로 보답하겠습니다.")
                                .font(.system(size: 16))
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    
                    Button {
                        
                        present = false
                        
                    } label: {
                        
                        Rectangle()
                            .fill(.red)
                            .frame(height: 56)
                            .overlay {
                                
                                Text("확인")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(height: 226)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 45)
            }
        }
        .animation(.easeInOut, value: viewState)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(reportViewModel.$reportResponseModel, perform: { _ in
            
            if reportViewModel.reportResponseModel != nil {
                
                viewState = .checkSuccess
            }
        })
        .onAppear {
            
            reportViewModel.onReportPostRequestFailed = { failure in
                
                if failure == .cantReportMySelf {
                    
                    self.alertMessage = "나의 팟을 신고할 수 없습니다"
                } else {
                    
                    self.alertMessage = "신고 전송에 실패했습니다"
                }
                
                self.showAlert = true
            }
        }
        .alert("신고 전송 실패", isPresented: $showAlert) {
            
            Button("닫기") { present = false }
            
        } message: {
            
            Text(alertMessage)
        }

    }
    
    func limitText(_ upper: Int) {
        if reportViewModel.reportDetailString.count > upper {
            reportViewModel.reportDetailString = String(reportViewModel.reportDetailString.prefix(upper))
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

//#Preview {
//    PotReportView()
//}
