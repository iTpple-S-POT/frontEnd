//
//  PotSearchScreen.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI
import DefaultExtensions
import GlobalObjects

public struct FrameToFitTextField: TextFieldStyle {
    
    @FocusState private var textFieldFocused: Bool
    
    public init() { }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        
        GeometryReader { geo in
            configuration
                .focused($textFieldFocused)
                .frame(width: geo.size.width, height: geo.size.height)
                .contentShape(Rectangle())
                .onTapGesture { textFieldFocused = true }
        }
    }
    
}

class PotSearchScreenModel: ObservableObject {
    
    @Published var presentResultView = false
    
    @Published private(set) var searchedModels: [PotModel] = []
}

struct PotSearchScreen: View {
    
    @State private var searchString: String = ""
    
    @State private var textFieldDisabled = false
    
    @StateObject private var viewModel = PotSearchScreenModel()
    
    var body: some View {
        ZStack {
            
            // 검색뷰
            VStack {
                
                HStack {
                    
                    Text("검색")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.leading, 21)
                    
                    Spacer()
                    
                }
                .frame(height: 56)
                .background(Rectangle().fill(.white).shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2))
                
                Spacer()
            }
            .zIndex(1.0)
            
            VStack {
                
                HStack(spacing: 12) {
                    
                    Image.makeImageFromBundle(bundle: .module, name: "search_icon", ext: .png)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    
                    TextField("seach_field", text: $searchString)
                        .textFieldStyle(FrameToFitTextField())
                        .placeholder(when: searchString.isEmpty, placeholder: {
                            Text("#관심있는 해시태그를 검색해 보세요!")
                                .foregroundStyle(.gray)
                        })
                        .font(.system(size: 16))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .disabled(textFieldDisabled)
                        .onSubmit {
                            
                            textFieldDisabled = true
                            
                            Task {
                                
                                do {
                                    
                                    //1. 해쉬테그 아이디 확득
                                    //2. 해당 아이디로 팟을 서칭
                                    //3. 서칭된 팟 모델을 사용하여 결과뷰 표시
                                    
//                                    let hashTagId = try await APIRequestGlobalObject.shared.getHashTagFrom(string: searchString)
                                    
//                                    let models = try await APIRequestGlobalObject.shared.getPots(
//                                        latitude: <#T##Double#>,
//                                        longitude: <#T##Double#>,
//                                        diameter: <#T##Double#>,
//                                        hashTagId: hashTagId
//                                    )
                                    
                                } catch {
                                    
                                    
                                }
                            }
                        }
                        
                    Spacer(minLength: 0)
                }
                .padding(.leading, 12)
                .frame(height: 56)
                .background(RoundedRectangle(cornerRadius: 10).fill(.light_gray))
                .padding(.horizontal, 21)
                .padding(.top, 43)
                
                Spacer()
                
            }
            .zIndex(0)
            
            
            GeometryReader { geo in
                
                let height = geo.size.height
                
                // 결과 화면
                Group {
                    
                    if viewModel.presentResultView {
                        
                        PotListView(
                            present: $viewModel.presentResultView,
                            title: "해시태그 검색",
                            models: viewModel.searchedModels
                        )
                    }
                }
                .slideTransition(
                    from: CGPoint(x: 0, y: height/3),
                    to: CGPoint(x: 0, y: 0)
                )
                .animation(.easeIn(duration: 0.3), value: viewModel.presentResultView)
            }
        }
    }
}

#Preview {
    PotSearchScreen()
}
