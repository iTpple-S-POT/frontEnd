//
//  MyPotScreen.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/25/24.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

extension Notification.Name {
    static let potUploadSuccess: Self = .init("potUploadSuccess")
}

class MyPotScreenModel: ObservableObject {
    
    @Published private(set) var myPotModels: [PotModel] = []
    
    init() {
        
        NotificationCenter.potSelection.addObserver(self, selector: #selector(addMyPotModel(_:)), name: .potUploadSuccess, object: nil)
        
        Task {
            
            await getMyPotFromServer()
        }
    }
    
    @objc
    func addMyPotModel(_ notification: Notification) {
        
        if let to = notification.object as? [String: Any], let model = to["model"] as? PotModel {
            
            DispatchQueue.main.async {
                
                withAnimation {
                    self.myPotModels.insert(model, at: 0)
                }
            }
        }
    }
    
    func getMyPotFromServer() async {
        
        do {
            let potObjects = try await APIRequestGlobalObject.shared.getMyPot()
            
            let models = potObjects.map { PotModel.makePotModelFrom(potObject: $0) }
            
            print("불러온 나의 팟 \(models.count)")
            
            DispatchQueue.main.async {
                
                withAnimation {
                    self.myPotModels = models
                }
            }
        } catch {
            print("나의 팟 불러오기 실패")
        }
    }
}


struct MyPotScreen: View {
    
    @StateObject private var screenModel = MyPotScreenModel()
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    private let itemSpacing: CGFloat = 1.0
    
    private var itemSize: CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let itemWidth = (screenWidth-itemSpacing)/2
        
        return CGSize(width: itemWidth, height: itemWidth * 1.33)
    }
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            VStack {
                HStack {
                    
                    Text("나의 POT")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                }
                .frame(height: 56)
                .padding(.horizontal, 21)
                .background(
                    Rectangle().fill(.white)
                        .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
                )
                
                Spacer()
            }
            .zIndex(1.0)
            
            ScrollView {
                
                VStack(spacing: 0) {
                    
                    LazyVGrid(columns: columns, spacing: itemSpacing) {
                        
                        ForEach(screenModel.myPotModels, id: \.id) { model in
                            
                            MyPotCell(model: model)
                                .frame(
                                    width: itemSize.width,
                                    height: itemSize.height
                                )
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 56)
            .zIndex(0.0)
        }
    }
}

struct MyPotCell: View {
    
    var model: PotModel
    
    private var creationData: String {
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        isoFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let expirationDate = isoFormatter.date(from: model.expirationDate)!
        
        let calendar = Calendar.current
        
        let creationDate = calendar.date(byAdding: .day, value: -1, to: expirationDate)!
        
        let presentFormatter = DateFormatter()
        presentFormatter.dateFormat = "yyyy.MM.dd.HH:ss"
        
        return presentFormatter.string(from: creationDate)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                // Background
                PotListCell(
                    potModel: model,
                    itemSize: geo.size
                )
                .frame(
                    width: geo.size.width,
                    height: geo.size.height
                )
                .clipShape(Rectangle())
                .position(
                    x: geo.size.width/2,
                    y: geo.size.height/2
                )
                .zIndex(0)
                
                //
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0.5), location: 0),
                        Gradient.Stop(color: .clear, location: 0.75),
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .allowsHitTesting(false)
                .zIndex(1)
                
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        
                        DynamicText(creationData, textColor: .white)
                            .frame(
                                width: geo.size.width*2/3,
                                height: 25
                            )
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                        
                }
                .allowsHitTesting(false)
                .zIndex(2)
                
            }
            .frame(
                width: geo.size.width,
                height: geo.size.height
            )
            .position(
                x: geo.size.width/2,
                y: geo.size.height/2
            )
        }
    }
}

#Preview {
    MyPotScreen()
}
