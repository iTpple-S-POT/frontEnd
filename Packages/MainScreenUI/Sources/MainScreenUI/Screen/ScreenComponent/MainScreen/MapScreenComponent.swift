import SwiftUI
import CJMapkit
import DefaultExtensions
import GlobalUIComponents
import GlobalObjects

//extension Notification.Name {
//    static let annotationDidSelect = Notification.Name("annotationDidSelect")
//}

struct MapScreenComponent: View {
    @State private var selectedAnnotation: PotAnnotation?
    
    @EnvironmentObject var mainScreenModel: MainScreenModel
    
    @StateObject private var screenModel = MapScreenComponentModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
        ,predicate: NSPredicate(format: "expirationDate >= %@", Date.now as NSDate)
    )
    private var potsFromLocal: FetchedResults<Pot>
    
    var body: some View {
      CJMapkitView(userLocation: CLLocation(latitude: 37.550756, longitude: 126.9254901), annotations: annotationDummies)
                    .onReceive(NotificationCenter.default.publisher(for: .annotationDidSelect)) { notification in
                        // 주석 선택 핸들러
                        if let annotation = notification.object as? PotAnnotation {
                            selectedAnnotation = annotation
                        }
                    }
                    .sheet(item: $selectedAnnotation) { annotation in
                        PotDetailScreen(annotation: annotation)
                    }
      
        ZStack {
            MapkitViewRepresentable(isLastestCenterAndMapEqual: $screenModel.isLastestCenterAndMapEqual, selectedCategory: $mainScreenModel.selectedTag, latestCenter: screenModel.lastestCenter) { mapCenter in
                
                print("지도 중심이 업데이트됨")
                
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


extension Notification.Name {
    static let annotationDidSelect = Notification.Name("annotationDidSelect")
}


#Preview {
    MapScreenComponent()
        .environmentObject(MainScreenModel())
}

