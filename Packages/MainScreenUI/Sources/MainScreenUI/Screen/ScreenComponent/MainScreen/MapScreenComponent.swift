//
//  MapScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import CJMapkit
import DefaultExtensions
import GlobalUIComponents
import GlobalObjects

struct MapScreenComponent: View {
    
    @EnvironmentObject var mainScreenModel: MainScreenModel
    
    @StateObject private var screenModel = MapScreenComponentModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
        ,predicate: NSPredicate(format: "expirationDate >= %@", Date.now as NSDate)
    )
    private var potsFromLocal: FetchedResults<Pot>
    
    var body: some View {
        ZStack {
            MapkitViewRepresentable(isLastestCenterAndMapEqual: $screenModel.isLastestCenterAndMapEqual, latestCenter: screenModel.lastestCenter, pots: potsFromLocal.map { $0 as Pot }) { mapCenter in
                
                screenModel.currentCenterPositionOfMap = mapCenter
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Button {
                        
                        screenModel.moveMapToCurrentLocation()
                        
                    } label: {
                        
                        Image.makeImageFromBundle(bundle: .module, name: "pos_image", ext: .png)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                    }
                    .padding(.leading, 21)
                    
                    Spacer()
                    
                }
                .padding(.bottom, 56)
                
            }
            
            VStack {
                
                Spacer()
                
                
                Button {
                    
                    
                    
                } label: {
                    
                    
                    
                    HStack(spacing: 5) {
                        
                        Image.makeImageFromBundle(bundle: .module, name: "pot_search_image", ext: .png)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                        
                        Text("여기에서 재검색")
                            .foregroundStyle(.white)
                    }
                    .frame(height: 32)
                    .padding(.horizontal, 16)
                    .background(
                        PerfectRoundedRectangle()
                            .fill(.btn_red_nt)
                    )
                    
                    
                }
                .padding(.bottom, 12)
                
            }
            
        }
        .onAppear {
            
            do {
                
                // makeUIView이후에 정보가 들어오도록 설정
                screenModel.registerLocationSubscriber()
                
                try screenModel.checkLocationAuthorization()
                
            }
            catch {
                
                print("권한이 없음")
                
            }
            
        }
        .onChange(of: potsFromLocal) { newValue in
            
            print("Pots가 업데이트 되었습니다.")
            
            
        }
        
    }
}

extension FetchedResults: Equatable where Result == Pot {
    
    public static func == (lhs: FetchedResults, rhs: FetchedResults) -> Bool {
        if lhs.count == rhs.count {
            
            for index in (0..<lhs.count) {
                
                let p1 = lhs[index] as Pot
                let p2 = rhs[index] as Pot
                
                if p1.isActive != p2.isActive {
                    
                    return false
                }
                
            }
            
            return true
        } else {
            
            return false
        }
        
    }
    
}


#Preview {
    MapScreenComponent()
        .environmentObject(MainScreenModel())
}
