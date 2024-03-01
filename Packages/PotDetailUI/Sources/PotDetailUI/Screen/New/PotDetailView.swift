//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2/7/24.
//

import SwiftUI
import GlobalObjects
import DefaultExtensions
import Kingfisher
import GlobalUIComponents

enum PotDetailViewError: Error {
    case reactionRequestFailed
}

class PotDetailViewModel: ObservableObject {
    
    @Published var presentReactionView = false
    
    @Published var selectedReactionModel: ReactionModel?
    
    @Published var showAlert = false
    
    @Published var presentUploaderProfile = false
    
    var alertTitle = ""
    var alertContent = ""
    
    let animTime = 0.25
    
    func onDissmissReaction() {
        
        presentReactionView = false
        selectedReactionModel = nil
    }
    
    func showSendingReactionFailed() {
        
        showAlert = true
        alertTitle = "반응 실패"
        alertContent = "다시 시도해 주세요"
    }
    
    func showDuplicationFailed() {
        
        showAlert = true
        alertTitle = "반응 실패"
        alertContent = "이미 반응한 팟이에요"
    }
}


public struct PotDetailView: View {
    
    @StateObject private var viewModel = PotDetailViewModel()
    
    @StateObject var potModel: PotModel
    
    @State private var userInfo: UserInfoObject?
    
    @State private var isLineLimit = true
    
    private var isDataFetched = false
    
    let dismissAction: () -> Void
    
    public init(
        potModel: PotModel,
        userInfo: UserInfoObject?,
        dismissAction: @escaping () -> Void) {
        
        self._potModel = StateObject(wrappedValue: potModel)
        self._userInfo = State(wrappedValue: userInfo)
        self.dismissAction = dismissAction
            
            
        if userInfo != nil {
                
            isDataFetched = true;
        }
    }
    
    private var timeIntervalString: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let expirationDate = formatter.date(from: potModel.expirationDate)!
        
        let calendar = Calendar.current
        
        let creationDate = calendar.date(byAdding: .hour, value: -24, to: expirationDate)!
        
        let timeInterval = creationDate.distance(to: Date.now)
        
        let hour = Int(timeInterval / (3600))
        
        if hour > 24 {
            
            return "\(Int(hour / 24))일 전"
        } else if hour < 24 {
            
            return "\(hour)시간 전"
        } else {
            
            let minute = Int(timeInterval) % 3600 / 60
            
            if minute >= 1 {
                
                return "\(minute)분 전"
            } else {
                
                return "방금 전"
            }
        }
    }
    
    private var reactionCount: Int {
        
        potModel.reactionTypeCounts.reduce(0) { partial, reaction in
            
            Int(partial) + Int(reaction.count)
        }
    }
    
    private var tagObject: TagCases { TagCases[potModel.categoryId ] }
    
    public var body: some View {
        ZStack {
            
            Color
                .lowBlack
                .ignoresSafeArea()
            
            GeometryReader { geo in
                
                KFImage(URL(string: potModel.imageKey?.getPreSignedUrlString() ?? "")!)
                    .resizable()
                    .fade(duration: 0.5)
                    .backgroundDecode()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height+geo.safeAreaInsets.top)
                    .position(x: geo.size.width/2, y: (geo.size.height+geo.safeAreaInsets.top)/2)
            }
            .ignoresSafeArea(.container, edges: .top)
            
            // Gradient
            VStack {
                
                Spacer()
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .lowBlack, location: 0),
                        Gradient.Stop(color: .lowBlack.opacity(0.54), location: 0.65),
                        Gradient.Stop(color: .lowBlack.opacity(0), location: 1.0),
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 240)
            }
            
            // Like
            
            HStack {
                
                Spacer()
                
                // 공유, 좋아요, 댓글 컨테이너
                VStack {
                    
                    Spacer()
                    Spacer()
                    
                    // 좋아요 아이템
                    VStack(spacing: 5) {
                        Image.makeImageFromBundle(bundle: .module, name: "emotion_Btn", ext: .png)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .contentShape(Circle())
                            .onTapGesture {
                                
                                if userInfo != nil {
                                        
                                    viewModel.presentReactionView = true
                                }
                            }
                        
                        Text("\(reactionCount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 50)
                    
                    Spacer()
                    
                }
                .padding(.trailing, 21)
                
            }
            
            // ZStack위의 최초 VStack
            VStack {
                
                VStack {
                    
                    // 나가기, 카테고리
                    ZStack {
                        
                        HStack(spacing: 8) {
                            
                            Spacer(minLength: 28)
                            
                            tagObject.getIcon(type: .point)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28)
                            
                            Text(tagObject.getKorString())
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                        }
                        .commonShadow()
                        
                        HStack(spacing: 0) {
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4)
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .onTapGesture {
                                    
                                    dismissAction()
                                }
                            
                            Spacer(minLength: 0)
                            
                        }
                        
                    }
                    .frame(height: 56)
                    
                    // 지난 시간, 뷰 카운트
                    VStack(spacing: 6) {
                        
                        HStack(spacing: 8) {
                            Image.makeImageFromBundle(bundle: .module, name: "passed_time", ext: .png)
                                .resizable()
                                .scaledToFit()
                            
                            Text(timeIntervalString)
                                .font(.system(size: 16))
                            
                            Spacer()
                        }
                        .frame(height: 24)
                        
                        HStack(spacing: 8) {
                            Image.makeImageFromBundle(bundle: .module, name: "view_count", ext: .png)
                                .resizable()
                                .scaledToFit()
                            
                            Text("\(potModel.viewCount)")
                            
                            Spacer()
                        }
                        .frame(height: 24)
                    }
                    .commonShadow()
                    .foregroundStyle(.white)
                    .padding(.top, 12)
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            // 유저 프로필
                            HStack(spacing: 12) {
                                
                                Group {
                                    
                                    if let imageUrl = userInfo?.profileImageUrl, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40)
                                        
                                    } else {
                                       Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.white)
                                            .frame(width: 40)
                                    }
                                    
                                }
                                .contentShape(Circle())
                                .onTapGesture {
                                    viewModel.presentUploaderProfile = true
                                }
                                
                                Text(userInfo?.nickname ?? "비지정 닉네임")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Spacer(minLength: 0)
                                
                                
                            }
                            
                            // 팟내용
                            Text(potModel.content)
                                .lineLimit(isLineLimit ? 2 : .max)
                            
                            // 더보기및 접기
                            if !potModel.content.isEmpty {
                                
                                Button {
                                    
                                    isLineLimit.toggle()

                                } label: {
                                    
                                    Text(isLineLimit ? "더보기" : "접기")
                                        .fontWeight(.semibold)
                                        .underline(true, color: .white)
                                }
                            }
                        }
                        
                        // 댓글 좋아요등을 위한 Spacer
                        Spacer(minLength: 44)
                        
                    }
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    
                }
                .padding(.horizontal, 21)
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 8) {
                        Spacer()
                            .frame(height: 21)
                        
                        ForEach(potModel.hashTagList, id: \.self) { tag in
                            
                            Text("#\(tag.hashtag)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(height: 32)
                                .padding(.horizontal, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            
                        }
                        
                    }
                    .shadow(color: .black, radius: 3, y: 2)
                    
                }
                .scrollIndicators(.hidden)
                .frame(height: 32)
                .padding(.vertical, 20)
            }
            
            if viewModel.presentReactionView {
                
                ReactionView()
            }
        }
        .animation(.easeInOut(duration: viewModel.animTime), value: viewModel.presentReactionView)
        .onAppear {
            
            Task.detached {
             
                do {
                    
                    let potObject = try await APIRequestGlobalObject.shared.getPotForPotDetailAbout(potId: potModel.id)

                    let userObject = try await APIRequestGlobalObject.shared.getUserInfo(userId: Int(potObject.userId))
                    
                    // viewCount update
                    DispatchQueue.main.async {
                        
                        self.userInfo = userObject
                        self.potModel.viewCount = potObject.viewCount
                        self.potModel.hashTagList = potObject.hashtagList
                        self.potModel.reactionTypeCounts = potObject.reactionTypeCounts
                    }
                } catch {
                    print(error.localizedDescription)
                    print("single pot데이터 가져오기 실패")
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.presentUploaderProfile) {
            
            UploaderProfileView(userInfo: userInfo!)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert, actions: {
            Button("확인") { }
        }, message: {
            Text(viewModel.alertContent)
        })
        .environmentObject(viewModel)
        .environmentObject(potModel)
    }
}

#Preview {
    ZStack {
        
        Color.gray
            .ignoresSafeArea(.container)
        
        PotDetailView(
            potModel: {
                var potModel = PotModel(
                    id: 1,
                    userId: 1,
                    categoryId: 1,
                    content: "반갑습니다 울산에서온 최준영이라고 합니다",
                    imageKey: "!!!",
                    expirationDate: "2024-02-08T11:21:11.006112312312" ,
                    latitude: 0,
                    longitude: 0,
                    hashTagList: [],
                    viewCount: 20,
                    reactionTypeCounts: []
                )
                                                        
                return potModel
            }(),
            userInfo: nil
        ) {
            
        }
            .padding(.bottom, 64)
        
        
    }
}
