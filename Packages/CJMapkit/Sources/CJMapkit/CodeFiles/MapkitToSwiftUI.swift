import SwiftUI
import UIKit
import MapKit
import Combine
import CoreData
import GlobalObjects

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
    
    var mapCenterChangedAfterCoordinationSubscriber: AnyCancellable!
    
    var mapCenterChangedSubscriber: AnyCancellable!
    
    let mapCenterChangedAfterCoordinationPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    let mapCenterChangedPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
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
            
            guard let potAnnotation = someAnnotation as? PotAnnotation else {
                fatalError("어노테이션 타입 변환 실패")
            }
            
            let annotationView = PotAnnotationView(annotation: potAnnotation, reuseIdentifier: NSStringFromClass(PotAnnotationView.self))
            
            annotationView.frame.size = CGSize(width: 54, height: 54)
            
            return annotationView
        default:
            return nil
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // 맵중심 변동 Publisher
        mapCenterChangedPublisher.send(mapView.centerCoordinate)
        
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
            mapCenterChangedAfterCoordinationPublisher.send(movedCoordinate)
        default:
            return
        }
        
    }
    

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? PotAnnotation {
                // 선택된 어노테이션 정보를 전달하며 notification을 post합니다.
                NotificationCenter.default.post(name: Notification.Name("annotationDidSelect"), object: annotation)
            }
        }
}

// MARK: - UIViewRepresentable
public struct MapkitViewRepresentable: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    @Binding var isLastestCenterAndMapEqual: Bool
    
    @Binding var selectedCategory: TagCases
    
    @Binding var potObjects: [PotObject]
    
    var latestCenter: CLLocationCoordinate2D
    
    var mapCenterReciever: (CLLocationCoordinate2D) -> Void
    
    public init(isLastestCenterAndMapEqual: Binding<Bool>, selectedCategory: Binding<TagCases>, potObjects: Binding<[PotObject]> ,latestCenter: CLLocationCoordinate2D, mapCenterReciever: @escaping (CLLocationCoordinate2D) -> Void) {
        self._isLastestCenterAndMapEqual = isLastestCenterAndMapEqual
        self._selectedCategory = selectedCategory
        self._potObjects = potObjects
        self.latestCenter = latestCenter
        self.mapCenterReciever = mapCenterReciever
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        let coordi = context.coordinator
        
        coordi.mapView = mapView
        
        mapView.delegate = coordi
        
        coordi.mapView = mapView
        
        setSubscription(coordinator: coordi)
        
        let center = CJLocationManager.getUserLocationFromLocal()

        mapView.setRegion(coordi.regionWith(center: center), animated: false)
        
        return mapView
    }
    
    public func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // Annotation적용
        makePotAnnotationsFrom(mapView: uiView, potObjects: potObjects)
        
        // True로 바인딩이 변경됬을때만 호출
        // 버튼클릭, 최초 위치이동의 경우 밖에 없음
        if self.isLastestCenterAndMapEqual {
            
            let coordi = context.coordinator
            
            coordi.setUserMapEqual(location: latestCenter)
            
        }
        
    }
    
    func makePotAnnotationsFrom(mapView: MKMapView, potObjects: [PotObject]) {
        
        let annotations = potObjects.map { PotAnnotation(potObject: $0) }
        
        let ids = mapView.annotations.compactMap { anot in
            if let potAnot = anot as? PotAnnotation {
                
                return potAnot.potObject.id
                
            } else {
                return nil
            }
        }
        
        let newAnnotations = annotations.filter { anot in
            !ids.contains { id in anot.potObject.id == id }
        }
        
        mapView.addAnnotations(newAnnotations)
    }
    
    
    func setSubscription(coordinator: MkMapViewCoordinator) {
        
        coordinator.mapCenterChangedAfterCoordinationSubscriber = coordinator.mapCenterChangedAfterCoordinationPublisher.sink { _ in
            print("맵 센터 퍼블리셔 연결 종료")
        } receiveValue: { coordinate in
            
            // 위치일치후 유저가 맵을 움직였을 때 한번만 호출됨
            
            // 메인에서 실행할 필요 없음
            DispatchQueue.main.async {
                self._isLastestCenterAndMapEqual.wrappedValue = false
            }
            
            print("위치 일치후 유저가 맵을 움직임")
            
        }
        
        coordinator.mapCenterChangedSubscriber = coordinator.mapCenterChangedPublisher.sink { coordinate in
            
            print("유저가 맵을 움직임")
            
            // 새로운 지도의 중심
            mapCenterReciever(coordinate)
            
        }
    }
}
