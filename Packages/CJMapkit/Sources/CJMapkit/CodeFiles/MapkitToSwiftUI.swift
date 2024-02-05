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

// MARK: - Coordinator
public class MkMapViewCoordinator: NSObject {
    
    var mapView: MKMapView!
    
    var currentActiveCategoryDict: TagsDict!
    
    var mapState: MapViewState = .notDetermined
    
    var mapCenterChangedAfterCoordinationSubscriber: AnyCancellable!
    
    var mapCenterChangedSubscriber: AnyCancellable!
    
    let mapCenterChangedAfterCoordinationPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    let mapCenterChangedPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    private static let potAnnotationViewIdentifier = NSStringFromClass(PotAnnotationView.self)
    private static let potClusterAnnotationViewIdentifier = NSStringFromClass(PotClusterAnnotationView.self)
    private static let potClusterAnnotationId = "potAnnotation"
    
    override init() {
        super.init()
        registerAnnotation()
    }
    
    // Annotation
    private func registerAnnotation() {
        guard let mapView = self.mapView else { return }
        
        mapView.register(PotAnnotationView.self, forAnnotationViewWithReuseIdentifier: Self.potAnnotationViewIdentifier)
        mapView.register(PotClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: Self.potClusterAnnotationViewIdentifier)
    }
    
    func setUserMapEqual(location: CLLocationCoordinate2D) {
        
        print("맵과 유저위치를 일치시킵니다..")
        mapState = .movingToEqual
        
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
        
        switch annotation {
        case let potAnnot as PotAnnotation:
            let reuseAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Self.potAnnotationViewIdentifier)
            
            if let reusable = reuseAnnotationView {

                reusable.annotation = potAnnot
                
                return reusable
            }
            
            // 새로운 AnnotationView생성
            let potAnnotationView = PotAnnotationView(annotation: potAnnot, reuseIdentifier: Self.potAnnotationViewIdentifier)
            
            potAnnotationView.clusteringIdentifier = Self.potClusterAnnotationId
            
            return potAnnotationView
        case let potClusterAnnot as MKClusterAnnotation:
            
            let reuseAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Self.potClusterAnnotationViewIdentifier)
            
            if let reusable = reuseAnnotationView {
                
                reusable.annotation = potClusterAnnot
                
                return reusable
            }
            
            // 새로운 AnnotationView생성
            return PotClusterAnnotationView(annotation: potClusterAnnot, reuseIdentifier: Self.potClusterAnnotationViewIdentifier)
        default:
            return nil
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // 맵중심 변동 Publisher
        mapCenterChangedPublisher.send(mapView.centerCoordinate)
        
        switch mapState {
        case .movingToEqual:
            // 3박자 조정중 맵이 움직이는 경우
            print("위치가 일치합니다.")
            
            mapState = .userMapEqual
        case .userMapEqual:
            // 조정후 움직임: 유저가 지도를 움직임
            
            let movedCoordinate = mapView.region.center
            // 무조건 일치하지 않음으로
            mapState = .userMapNotEqual
            
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
    
    @Binding var activeCategoryDict: TagsDict
    
    @Binding var potObjects: Set<PotObject>
    
    var latestCenter: CLLocationCoordinate2D
    
    var mapCenterReciever: (CLLocationCoordinate2D) -> Void
    
    public init(isLastestCenterAndMapEqual: Binding<Bool>, activeCategoryDict: Binding<TagsDict>, potObjects: Binding<Set<PotObject>> ,latestCenter: CLLocationCoordinate2D, mapCenterReciever: @escaping (CLLocationCoordinate2D) -> Void) {
        self._isLastestCenterAndMapEqual = isLastestCenterAndMapEqual
        self._activeCategoryDict = activeCategoryDict
        self._potObjects = potObjects
        self.latestCenter = latestCenter
        self.mapCenterReciever = mapCenterReciever
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        let coordinator = context.coordinator
        
        coordinator.mapView = mapView
    
        // 현재 카테고리를 저장
        coordinator.currentActiveCategoryDict = self.activeCategoryDict
        
        mapView.delegate = coordinator
        
        coordinator.mapView = mapView
        
        setSubscription(coordinator: coordinator)
        
        let center = CJLocationManager.getUserLocationFromLocal()
        
        mapView.setRegion(coordinator.regionWith(center: center), animated: false)
        
        return mapView
    }
    
    public func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // 카테고리 필터링
        let coordinator = context.coordinator
        
        let activeCategoryDict = self.activeCategoryDict
        
        if coordinator.currentActiveCategoryDict != activeCategoryDict {
            
            coordinator.currentActiveCategoryDict = activeCategoryDict
            
            filterAnnotations(mapView: uiView)
        }
        
        
        // Annotation적용
        makePotAnnotationsFrom(mapView: uiView, potObjects: potObjects)
        
        // True로 바인딩이 변경됬을때만 호출
        // 버튼클릭, 최초 위치이동의 경우 밖에 없음
        if self.isLastestCenterAndMapEqual {
            
            let coordi = context.coordinator
            
            coordi.setUserMapEqual(location: latestCenter)
            
        }
        
    }
    
    func makePotAnnotationsFrom(mapView: MKMapView, potObjects: Set<PotObject>) {
        
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
    
    func filterAnnotations(mapView: MKMapView) {
        
        let dict = self.activeCategoryDict
        
        if dict[.all]! {
            
            mapView.unhideAnnotations(mapView.annotations)
            return
        }
        
        if dict[.hot]! {
            
            // TODO: 팟인기순 정렬
        }
        
        var willDisplayAnnotations: [MKAnnotation] = []
        var wiilHideAnnotations: [MKAnnotation] = []
        
        let activeCategoryIds: [Int] = dict.compactMap { $1 ? $0.id : nil }
        
        mapView.annotations.forEach { annotation in
            
            if let potAnot = annotation as? PotAnnotation {
                
                let annotationCatId = potAnot.potObject.categoryId
                
                if activeCategoryIds.contains(Int(annotationCatId)) {
                    
                    willDisplayAnnotations.append(potAnot)
                } else {
                    
                    wiilHideAnnotations.append(potAnot)
                }
            }
        }
        
        mapView.hideAnnotations(wiilHideAnnotations)
        mapView.unhideAnnotations(willDisplayAnnotations)
    }
}
