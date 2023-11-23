// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import GlobalFonts
import GlobalUIComponents

public struct UserInformationScreen: View {
    @StateObject private var screenModel = MainScreenModel()
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            
            BarView(state: screenModel.inputScreenOrder, countOfState: screenModel.inputScreenCount)
                .padding(.top, 50)
                .padding(.bottom, 42)
            
            
            //Views
            NickNameInputView()
            
            
            Spacer()
            
            Button {
                withAnimation {
                    screenModel.nextScreen()
                }
                
            } label: {
                HStack {
                    Spacer()
                    Text("다음")
                        .font(.suite(type: .SUITE_SemiBold, size: 20))
                        .foregroundStyle(.white)
                        .frame(height: 25)
                    Spacer()
                }
                .frame(height: 56)
            }
            .buttonStyle(.spotDefault(backgroundColor: .spotRed))
            
            Button {
                
            } label: {
                Text("건너뛰기")
                    .font(.suite(type: .SUITE_Light, size: 20))
                    .foregroundStyle(.black)
                    .frame(height: 22)
            }
            .padding(.vertical, 22)
        }
        .padding(.horizontal, 16)
    }
}

struct BarView: View {
    
    var state: Int
    
    var countOfState: Int
    
    var body: some View {
        
        GeometryReader { geo in
            let geoWidth = geo.size.width
            let barSizePerProcess = geoWidth / CGFloat(countOfState)
            let currentBarSize = barSizePerProcess * CGFloat(state)
            
            VStack(spacing: 0) {
                
                /// 숫자텍스트
                HStack(spacing: 0) {
                    Spacer()
                    Text("\(state)")
                        .animation(nil)
                    Text("/\(countOfState)")
                }
                .font(.suite(type: .SUITE_Regular, size: 17))
                .frame(height: 20)
                
                Spacer()
                
                /// 검정바
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.lightGeryForBar)
                        .frame(height: 4)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.black)
                            .frame(width: currentBarSize, height: 4)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .frame(height: 28)
    }
}




#Preview {
    UserInformationScreen()
}
