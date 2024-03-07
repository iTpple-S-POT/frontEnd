import SwiftUI
import CJMapkit
import DefaultExtensions
import GlobalUIComponents
import GlobalObjects

struct MapScreenComponent: View {
    
    @EnvironmentObject private var mainScreenModel: MainScreenModel

    @StateObject private var mapPotController = MapPotController(
        potFetcher: APIRequestGlobalObject.shared,
        locationFetcher: locationFetcher
    )
    
    static let locationFetcher = CJLocationFetcher()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        
        ZStack {
            
            MapkitViewRepresentable(
                initialCoordinate: mapPotController.locationVMForCurrentUser.getCLCoordinate2D(),
                activeCategoryDict: $mainScreenModel.selectedTagDict,
                potViewModels: $mapPotController.potViewModels
            )
            .zIndex(0)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Button {
                        
                        mapPotController.moveMapToCurrentUserLocation()
                        
                    } label: {
                        
                        Image.makeImageFromBundle(bundle: .module, name: "pos_image", ext: .png)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                    }
                    .padding(.leading, 21)
                    .transition(.opacity)
                    
                    Spacer()
                    
                }
                .padding(.bottom, 56)
                
            }
            .zIndex(1)
            
            VStack {
                
                Spacer()
                
                
                Button {
                    
                    mapPotController.requestPots()
                    
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
            .zIndex(1)
            
        }
        .onReceive(NotificationCenter.Publisher(center: .potMapCenter, name: .needsOptionSettingForLocation, object: nil)) { _ in
            
            showNeedsAuthAlert()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            
            Button("닫기") { }
        } message: {
            
            Text(alertMessage)
        }

    }
    
    func showNeedsAuthAlert() {
        
        showAlert = true
        alertTitle = "위치정보 제공 동의가 필요합니다"
        alertMessage = "설정 > S:POT > 위치"
        
    }
}

#Preview {
    MapScreenComponent()
        .environmentObject(MainScreenModel())
}

