import SwiftUI
import UIKit
import MapKit
import Combine

public enum MapViewState {
    
    case notDetermined
    case userMapNotEqual
    case userMapEqual
    case movingToEqual
}

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}


// MARK: - Coordinator
public class MkMapViewCoordinator: NSObject {
    
    var mapView: MKMapView!
    
    var state: MapViewState = .notDetermined
    
    var mapCenterSubscriber: AnyCancellable!
    
    let mapCenterPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    override init() {
        super.init()
        registerAnnotation()
    }
    
    // Annotation
    private func registerAnnotation() {
        guard let mapView = self.mapView else { return }
        
        mapView.register(PotAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PotAnnotationView.self))
    }
    
    func setUserMapEqual(location: CLLocationCoordinate2D) {
        
        print("맵과 유저위치를 일치시킵니다..")
        state = .movingToEqual
        
        mapView.setRegion(regionWith(center: location), animated: true)
    }
    
    // span을 동일하게 유지하기 위해
    func regionWith(center: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
        return MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        
    }
    
}

// MARK: - MKMapViewDelegate

extension MkMapViewCoordinator: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let someAnnotation = annotation as! AnnotationClassType
        
        switch someAnnotation.identifier {
        case NSStringFromClass(PotAnnotation.self):
            return PotAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(PotAnnotationView.self))
        default:
            return nil
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        switch state {
        case .movingToEqual:
            // 3박자 조정중 맵이 움직이는 경우
            print("위치가 일치합니다.")
            
            state = .userMapEqual
        case .userMapEqual:
            // 조정후 움직임: 유저가 지도를 움직임
            
            let movedCoordinate = mapView.region.center
            // 무조건 일치하지 않음으로
            state = .userMapNotEqual
            
            // 맵 스크린 컴포넌트 모델의 현재 위치를 업데이트
            mapCenterPublisher.send(movedCoordinate)
        default:
            return
        }
        
    }
    
}


// MARK: - UIViewRepresentable
public struct MapkitViewRepresentable: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    @Binding var isLastestCenterAndMapEqual: Bool
    
    var latestCenter: CLLocationCoordinate2D
    
    var annotations: [AnnotationClassType]
    
    public init(isLastestCenterAndMapEqual: Binding<Bool>, latestCenter: CLLocationCoordinate2D, annotations: [AnnotationClassType]) {
        self._isLastestCenterAndMapEqual = isLastestCenterAndMapEqual
        self.latestCenter = latestCenter
        self.annotations = annotations
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        let coordi = context.coordinator
        
        coordi.mapView = mapView
        
        mapView.delegate = coordi
        
        coordi.mapView = mapView
        
        coordi.mapCenterSubscriber = coordi.mapCenterPublisher.sink { _ in
            print("맵 센터 퍼블리셔 연결 종료")
        } receiveValue: { coordinate in
            
            // 위치일치후 유저가 맵을 움직였을 때 한번만 호출됨
            
            // 메인에서 실행할 필요 없음
            DispatchQueue.main.async {
                self._isLastestCenterAndMapEqual.wrappedValue = false
            }
            
            print("유저가 맵을 움직임")
            
        }

        
        let center = CJLocationManager.getUserLocationFromLocal()

        mapView.setRegion(coordi.regionWith(center: center), animated: false)
        
        // TODO: 상의하기
        mapView.isZoomEnabled = true
        
        // Add annotations
        mapView.addAnnotations(self.annotations)
        
        print("초기 설정 완")
        return mapView
    }
    
    public func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // True로 바인딩이 변경됬을때만 호출
        // 버튼클릭, 최초 위치이동의 경우 밖에 없음
        if self.isLastestCenterAndMapEqual {
            
            let coordi = context.coordinator
            
            coordi.setUserMapEqual(location: latestCenter)
            
        }
        
    }
}
