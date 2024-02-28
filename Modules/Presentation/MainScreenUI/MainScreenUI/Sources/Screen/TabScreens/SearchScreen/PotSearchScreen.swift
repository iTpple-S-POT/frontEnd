//
//  PotSearchScreen.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI
import DefaultExtensions
import GlobalObjects
import Combine
import CJMapkit
import GlobalUIComponents

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
    
    var onPresentResultView: (() -> Void)?

    let hashTagSelectPublisher = PassthroughSubject<HashTagDTO, Never>()
    
    var selectedHashTagId: Int64?
    
    var subscriptions: Set<AnyCancellable> = []
    
    init() {
        
        hashTagSelectPublisher
            .receive(on: DispatchQueue.main)
            .sink { hashTag in
                
                self.selectedHashTagId = hashTag.hashtagId

                self.presentResultViewFunc()
            }
            .store(in: &subscriptions)
    }
    
    func presentResultViewFunc() {
        
        onPresentResultView?()
        
        presentResultView = true
    }
}

struct PotSearchScreen: View {
    
    @State private var searchString: String = ""
    
    @StateObject private var viewModel = PotSearchScreenModel()
    
    @FocusState private var focusState
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
                .zIndex(0)
            
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
            .zIndex(2)
            
            VStack {
                
                HStack(spacing: 12) {
                    
                    Image.makeImageFromBundle(bundle: .module, name: "search_icon", ext: .png)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    
                    TextField("", text: $searchString)
                        .textFieldStyle(FrameToFitTextField())
                        .placeholder(when: searchString.isEmpty, placeholder: {
                            Text("#관심있는 해시태그를 검색해 보세요!")
                                .foregroundStyle(.gray)
                        })
                        .font(.system(size: 16))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .focused($focusState)
                        
                    Spacer(minLength: 0)
                }
                .padding(.leading, 12)
                .frame(height: 56)
                .background(RoundedRectangle(cornerRadius: 10).fill(.light_gray))
                .padding(.horizontal, 21)
                .padding(.top, 43)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                HashTagAutoForamtListView(
                    inputString: $searchString,
                    pub: viewModel.hashTagSelectPublisher
                )
                .padding(.horizontal, 21)
                
                Spacer()
                    
                
            }
            .padding(.top, 56)
            .zIndex(1)
            
            GeometryReader { geo in
                
                let height = geo.size.height
                
                // 결과 화면
                Group {
                    
                    if viewModel.presentResultView {
                        
                        PotListViewWithHashTag(
                            present: $viewModel.presentResultView,
                            title: "해시태그 검색",
                            hashTagId: viewModel.selectedHashTagId!
                        )
                        .zIndex(3)
                        .slideTransition(
                            from: CGPoint(x: 0, y: height/3),
                            to: CGPoint(x: 0, y: 0)
                        )
                    }
                }
                .animation(.easeIn(duration: 0.3), value: viewModel.presentResultView)
            }
            .zIndex(3)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            
            viewModel.onPresentResultView = {
                
                focusState = false
            }
        }
    }
}

struct HashTagAutoForamtListView: View {
    
    @Binding var inputString: String
    
    let pub: PassthroughSubject<HashTagDTO, Never>
    
    @State private var showingList: [HashTagDTO] = []
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                ForEach(showingList, id: \.hashtagId) { element in
                    
                    VStack(spacing: 0) {
                        
                        HStack {
                            
                            Text(element.hashtag)
                                .font(.system(size: 16))
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            Text("선택")
                                .font(.system(size: 16))
                                .foregroundStyle(.gray)
                                .padding(.trailing, 16)
                        }
                        .frame(height: 56)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                            pub.send(element)
                        }
                        
                        Rectangle()
                            .fill(.light_gray)
                            .frame(height: 1)
                    }
                }
            }
        }
        .onChange(of: inputString) { newStr in
            
            Task {
                
                do {
                    
                    let newList = try await APIRequestGlobalObject.shared.getHashTagFrom(string: newStr)
                    
                    DispatchQueue.main.async {
                        
                        self.showingList = newList
                    }
                    
                } catch {
                    
                    print("해시태그 검색결과 불러오기 실패")
                }
            }
        }
    }
}

struct PotListViewWithHashTag: View {
    
    @Binding var present: Bool
    
    var title: String
    
    var hashTagId: Int64
    
    @State private var models: [PotModel] = []
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var alertAction: (() -> Void)?
    
    var body: some View {
        
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            VStack(spacing: 0) {
                
                SpotNavigationBarView(title: title) {
                    
                    withAnimation {
                        present = false;
                    }
                }
                
                Spacer()
            }
            .zIndex(1.0)
            
            VStack {
                
                HStack {
                    
                    (
                        Text("검색결과 ")
                        
                        +
                        
                        Text("\(models.count)건")
                            .fontWeight(.semibold)
                    )
                    .font(.system(size: 16))
                    
                    Spacer()
                    
                }
                .frame(height: 56)
                .padding(.leading, 21)
                
                PotCollectionView(models: $models)
                
                Spacer()
            }
            .padding(.top, 56)
            .zIndex(0.0)
        }
        .task {
            
            do {
                
                let models = try await self.requestPotFromHashTag(hashTagId: hashTagId)
                
                DispatchQueue.main.async {
                    
                    self.models = models
                }
            } catch {
                
                print("검색실패")
                
                DispatchQueue.main.async {
                    
                    self.showSearchFailed()
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
                
            Button("확인") {
                alertAction?()
            }
            
        } message: {
            
            Text(alertMessage)
        }
    }
    
    func requestPotFromHashTag(hashTagId: Int64) async throws -> [PotModel] {
        
        guard let location = CJLocationManager.shared.currentUserLocation else {
            
            throw PotUploadPrepareError.cantGetUserLocation(function: #function)
        }
        
        let potObjects = try await APIRequestGlobalObject.shared.getPots(latitude: location.latitude, longitude: location.longitude, diameter: 1000, hashTagId: Int(hashTagId))
        
        return potObjects.map { PotModel.makePotModelFrom(potObject: $0) }
    }
    
    func showSearchFailed() {
        
        showAlert = true
        alertTitle = "검색 실패"
        alertMessage = "잠시후 다시시도해주세요"
        alertAction = { present = false }
    }
}

#Preview {
    PotSearchScreen()
}
