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


public struct PotDetailView: View {
    
    @State var potObject: PotObject
    
    let dismissAction: () -> Void
    
    public init(potObject: PotObject, dismissAction: @escaping () -> Void) {
        
        self._potObject = State<PotObject>(wrappedValue: potObject)
        self.dismissAction = dismissAction
    }
    
    private var timeIntervalString: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let expirationDate = formatter.date(from: potObject.expirationDate)!
        
        let calendar = Calendar.current
        
        let creationDate = calendar.date(byAdding: .hour, value: -24, to: expirationDate)!
        
        let timeInterval = creationDate.distance(to: Date.now)
        
        let hour = Int(timeInterval / (3600))
        
        if hour > 0 {
            
            return "\(hour)시간 전"
        }
        
        return "방금전"
    }
    
    private var tagObject: TagCases { TagCases[potObject.categoryId ] }
    
    public var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea(.container, edges: .top)
            
            GeometryReader { geo in
                
                KFImage(URL(string: potObject.imageKey?.getPreSignedUrlString() ?? "")!)
                    .resizable()
                    .fade(duration: 0.5)
                    .scaledToFill()
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
            
            VStack {
                
                // 상단
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
                        
                        HStack(spacing: 0) {
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
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
                            
                            Text("\(potObject.viewCount)")
                            
                            Spacer()
                        }
                        .frame(height: 24)
                    }
                    .shadow(color: .black, radius: 3, y: 2)
                    .foregroundStyle(.white)
                    .padding(.top, 12)
                    
                }
                .padding(.horizontal, 21)
                
                
                Spacer(minLength: 0)
                
            }
        }
        .onAppear {
            
            Task.detached {
             
                do {
                    
                    let object = try await APIRequestGlobalObject.shared.getPotForPotDetailAbout(potId: potObject.id)
                    
                    DispatchQueue.main.async {
                        self.potObject = potObject
                    }
                } catch {
                    print(error.localizedDescription)
                    print("single pot데이터 가져오기 실패")
                }
            }
        }
    }
}


#Preview {
    ZStack {
        
        Color.gray
            .ignoresSafeArea(.container)
        
        PotDetailView(
            potObject: {
                var potObject = PotObject(
                    id: 1,
                    userId: 1,
                    categoryId: 1,
                    content: "반갑습니다 울산에서온 최준영이라고 합니다",
                    imageKey: "!!!",
                    expirationDate: "2024-02-08T11:21:11.006112312312" ,
                    latitude: 0,
                    longitude: 0,
                    viewCount: 20
                )
                
                potObject.viewCount = 20
                                                        
                return potObject
            }()
        ) {
            
        }
            .padding(.bottom, 64)
        
        
    }
}
