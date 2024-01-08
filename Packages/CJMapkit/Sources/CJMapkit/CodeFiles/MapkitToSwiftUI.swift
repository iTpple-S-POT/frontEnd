import SwiftUI
import UIKit
import MapKit
import Combine

public enum MapViewState {
    
    case notDetermined
    case userMapNotEqual
    case userMapEqual
    
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
        
        state = .userMapEqual
        
        
        var currentRegion = mapView.region
        
        currentRegion.center = location
        
        mapView.setRegion(currentRegion, animated: true)
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
        
        print("리전 업데이트")
        
        // 위치가 같은 상태에서 달라질 경우만 호출
        if state == .userMapEqual || state == .notDetermined {
            
            let movedCoordinate = mapView.region.center
            
            // 무조건 일치하지 않음으로
            state = .userMapNotEqual
            
            // 맵 스크린 컴포넌트 모델의 현재 위치를 업데이트
            mapCenterPublisher.send(movedCoordinate)
            
        }
        
    }
    
}


// MARK: - UIViewRepresentable
public struct MapkitViewRepresentable: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    @Binding var userLocation: CLLocationCoordinate2D
    
    var annotations: [AnnotationClassType]
    
    public init(userLocation: Binding<CLLocationCoordinate2D>, annotations: [AnnotationClassType]) {
        self._userLocation = userLocation
        self.annotations = annotations
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        context.coordinator.mapView = mapView
        
        mapView.delegate = context.coordinator
        
        context.coordinator.mapView = mapView
        
        context.coordinator.mapCenterPublisher.sink { _ in
            print("맵 센터 퍼블리셔 연결 종료")
        } receiveValue: { coordinate in
            
            // 메인에서 실행할 필요 없음
            userLocation = coordinate
            
            print("유저가 맵을 움직임")
            
        }

        
        let centerLocation = CJLocationManager.getUserLocationFromLocal()

        mapView.region = MKCoordinateRegion(center: centerLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.isZoomEnabled = false
        
        // Add annotations
        mapView.addAnnotations(self.annotations)
        
        return mapView
    }
    
    public func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let coordi = context.coordinator
        
        coordi.setUserMapEqual(location: userLocation)
        
    }
}
