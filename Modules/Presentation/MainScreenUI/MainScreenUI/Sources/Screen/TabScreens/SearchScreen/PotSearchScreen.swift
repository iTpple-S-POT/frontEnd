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

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

class PotSearchScreenModel: ObservableObject {
    
    @Published var presentResultView = false
    
    @Published var potModels: [PotModel] = []

    let hashTagSelectPublisher = PassthroughSubject<HashTagDTO, Never>()
    
    var subscriptions: Set<AnyCancellable> = []
    
    @Published var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    var alertAction: (() -> Void)?
    
    init() {
        
        hashTagSelectPublisher
            .receive(on: DispatchQueue.main)
            .sink { hashTag in
    
                Task {
                    
                    do {
                        
                        self.potModels = try await self.getPotFromHashTag(hashTagId: hashTag.hashtagId)
                        
                        self.presentResultView = true
                    } catch {
                        
                        self.showSearchFailed()
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func getPotFromHashTag(hashTagId: Int64) async throws -> [PotModel] {
        
        let models = try await self.requestPotFromHashTag(hashTagId: hashTagId)
        
        return models
    }
    
    func requestPotFromHashTag(hashTagId: Int64) async throws -> [PotModel] {
        
        guard let coordinate = CJLocationFetcher.shared.manager.location?.coordinate else {
            
            throw PotUploadPrepareError.cantGetUserLocation(function: #function)
        }
        
        let potObjects = try await APIRequestGlobalObject.shared.getPots(latitude: coordinate.latitude, longitude: coordinate.longitude, diameter: 1000, hashTagId: Int(hashTagId))
        
        return potObjects.map { PotModel.makePotModelFrom(potObject: $0) }
    }
    
    func showSearchFailed() {
        
        showAlert = true
        alertTitle = "검색 실패"
        alertMessage = "잠시후 다시시도해주세요"
    }
}

struct PotSearchScreen: View {
    
    @State private var searchString: String = ""
    
    @State private var isKeyboardPresented = false
    
    @StateObject private var viewModel = PotSearchScreenModel()
    
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
                    pub: viewModel.hashTagSelectPublisher,
                    isTouchEnable: !isKeyboardPresented
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
                            models: viewModel.potModels)
                    }
                }
                .slideTransition(
                    from: CGPoint(x: 0, y: height/3),
                    to: CGPoint(x: 0, y: 0)
                )
                .animation(.easeIn(duration: 0.3), value: viewModel.presentResultView)
            }
            .zIndex(3)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            
            Button("확인") {
                viewModel.alertAction?()
            }
            
        } message: {
            
            Text(viewModel.alertMessage)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(keyboardPublisher) { value in
            
            isKeyboardPresented = value
        }
    }
}

struct HashTagAutoForamtListView: View {
    
    @Binding var inputString: String
    
    let pub: PassthroughSubject<HashTagDTO, Never>
    
    var isTouchEnable: Bool
    
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
                        .allowsHitTesting(isTouchEnable)
                        
                        Rectangle()
                            .fill(.light_gray)
                            .frame(height: 1)
                    }
                }
            }
        }
        .onChange(of: inputString) { newStr in
            
            getAutoStrings(str: newStr)
        }
        .onAppear {
            
            getAutoStrings(str: inputString)
        }
    }
    
    func getAutoStrings(str: String) {
        
        Task {
            
            do {
                
                let newList = try await APIRequestGlobalObject.shared.getHashTagFrom(string: str)
                
                DispatchQueue.main.async {
                    
                    self.showingList = newList
                }
                
            } catch {
                
                print("해시태그 검색결과 불러오기 실패")
            }
        }
    }
}

struct PotListViewWithHashTag: View {
    
    @Binding var present: Bool
    
    var title: String
    
    @State var models: [PotModel]
    
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
                
                Spacer()
            }
            .padding(.top, 56)
            .zIndex(0.0)
            
            VStack {
                
                PotCollectionView(models: $models)
                
                Spacer()
            }
            .padding(.top, 112)
            .zIndex(0.0)
        }
    }
}

#Preview {
    PotSearchScreen()
}
