import SwiftUI
import CJMapkit
import DefaultExtensions
import GlobalUIComponents
import GlobalObjects

struct MapScreenComponent: View {
    
    @EnvironmentObject private var mainScreenModel: MainScreenModel
    
    @StateObject private var screenModel = MapScreenComponentModel()
    
    var body: some View {
        
        ZStack {
            MapkitViewRepresentable(
                isLastestCenterAndMapEqual: $screenModel.isLastestCenterAndMapEqual,
                activeCategoryDict: $mainScreenModel.selectedTagDict,
                potObjects: $screenModel.potObjects,
                latestCenter: screenModel.lastestCenter) { mapCenter in
                
                print("지도 중심이 업데이트됨")
                
                screenModel.currentCenterPositionOfMap = mapCenter
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    if screenModel.userPositionIsAvailable {
                        
                        Button {
                            
                            screenModel.moveMapToCurrentLocation()
                            
                        } label: {
                            
                            Image.makeImageFromBundle(bundle: .module, name: "pos_image", ext: .png)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            
                        }
                        .padding(.leading, 21)
                        .transition(.opacity)
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 56)
                
            }
            
            VStack {
                
                Spacer()
                
                
                Button {
                    
                    screenModel.fetchPotsFromCurrentMapCenter()
                    
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
    }
}

#Preview {
    MapScreenComponent()
        .environmentObject(MainScreenModel())
}

