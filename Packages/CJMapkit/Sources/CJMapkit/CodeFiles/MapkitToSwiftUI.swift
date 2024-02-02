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
    
    var currentActiveCategoryDict: TagsDict!
    
    var mapState: MapViewState = .notDetermined
    
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
        
        let someAnnotation = annotation as! AnnotationClassType
        
        switch someAnnotation.identifier {
        case NSStringFromClass(PotAnnotation.self):
            
            let potAnnotation = someAnnotation as! PotAnnotation
            
            let reuseIdentifier = NSStringFromClass(PotAnnotationView.self)
            
            let reuseAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            var potAnnotationView: PotAnnotationView!
            
            if let reuseAnot = reuseAnnotationView as? PotAnnotationView {
                
                potAnnotationView = reuseAnot
                
                potAnnotationView.annotation = potAnnotation
                potAnnotationView.setUp(annotation: potAnnotation)
            } else {
                
                // 새로운 AnnotationView생성
                potAnnotationView = PotAnnotationView(annotation: potAnnotation, reuseIdentifier: NSStringFromClass(PotAnnotationView.self))
            }
            
            return potAnnotationView
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


// MARK: - 테스트중

extension MKAnnotationView {
    
    private struct Holder {
        static var heldSavedCollision = [String: CollisionMode]()
        static var heldSavedAnnotation = [String: MKAnnotation]()
    }
    
    var savedAnnotation: MKAnnotation? {
        get { return Holder.heldSavedAnnotation[debugDescription] ?? nil }
        set(newValue) { Holder.heldSavedAnnotation[debugDescription] = newValue }
    }
    
    // used for saving and restoring collisionmode
    var savedCollision: CollisionMode? {
        get { return Holder.heldSavedCollision[debugDescription] ?? nil }
        set(newValue) { Holder.heldSavedCollision[debugDescription] = newValue }
    }
    
    func hideAnimated(withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        savedAnnotation = self.annotation
        self.savedCollision = self.collisionMode
        
        let dispGroup = DispatchGroup()
        dispGroup.enter()
        DispatchQueue.main.async(group: dispGroup) {
            // small delay is needed to make the collisons recalculate
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseInOut,
                           animations: { self.alpha = 0 },
                           completion: { _ in dispGroup.leave()})
        }
        
        dispGroup.notify(queue: .main) {
            self.collisionMode = .none
            
            // don't complete the animation if the annotation has changed meanwhile
            // when using reusable annotations the annotation could have changed
            // while the animation was running
            // therefore we dont want to complete the animation when the annotation has changed
            
            if self.hasAnnotationChanged() {
                completion?()
                return
                
            } else {
                self.alpha = 0
                self.isHidden = true
                completion?()
            }
            
        }
    }
    
    func hide() {
        savedCollision = collisionMode
        collisionMode = .none
        alpha = 0
        isHidden = true
    }
    
    private func hasAnnotationChanged() -> Bool {
        return !(self.savedAnnotation?.title == self.annotation?.title && self.savedAnnotation?.subtitle == self.annotation?.subtitle)
    }
    
    func showAnimated(withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        savedAnnotation = self.annotation
        collisionMode = savedCollision ?? .rectangle
        
        isHidden = false
        
        let dispGroup = DispatchGroup()
        dispGroup.enter()
        DispatchQueue.main.async(group: dispGroup) {
            // small delay is needed to make the collisons recalculate
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseInOut,
                           animations: { self.alpha = 1.0 },
                           completion: { _ in dispGroup.leave() }
            )
        }
        
        dispGroup.notify(queue: .main) {
            // don't complete the animation if the annotation has changed meanwhile
            if self.hasAnnotationChanged() {
                completion?()
                return
            } else {
                self.alpha = 1
                completion?()
            }
        }
        
    }
    
    func show() {
        collisionMode = savedCollision ?? .rectangle
        alpha = 1
        isHidden = false
    }
}

extension MKMapView {
    
    func unhideAnnotation(_ annotation: MKAnnotation, animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                          completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let annotationView = self.view(for: annotation) {
                if animated {
                    annotationView.showAnimated(withDuration: withDuration , delay: delay,  completion: completion)
                } else {
                    annotationView.show()
                    completion?()
                }
            }
        }
    }
    
    /**
     shows all given annotations
     completion is run after all annotations are shown
     */
    func unhideAnnotations(_ annotations: [MKAnnotation], animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                           completion: (() -> Void)? = nil) {
        
        let dispGroup = DispatchGroup()
        for annotation in annotations {
            dispGroup.enter()
            unhideAnnotation(annotation, animated: animated, withDuration: withDuration , delay: delay, completion: {
                dispGroup.leave()
            })
        }
        
        dispGroup.notify(queue: .main) {
            completion?()
        }
        
    }
    
    
    func hideAnnotation(_ annotation: MKAnnotation, animated: Bool = false, withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let annotationView = self.view(for: annotation) {
                if animated {
                    annotationView.hideAnimated(withDuration: withDuration , delay: delay, completion: completion)
                } else {
                    annotationView.hide()
                    completion?()
                }
            } else {
                // when no annotationview is found run the completion
                completion?()
            }
        }
    }
    
    func hideAnnotations(_ annotations: [MKAnnotation], animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                         completion: (() -> Void)? = nil) {
        let dispGroup = DispatchGroup()
        for annotation in annotations {
            dispGroup.enter()
            hideAnnotation(annotation, animated: animated, withDuration: withDuration , delay: delay,  completion: {
                dispGroup.leave()
            })
        }
        
        dispGroup.notify(queue: .main) {
            completion?()
        }
    }
    
}
