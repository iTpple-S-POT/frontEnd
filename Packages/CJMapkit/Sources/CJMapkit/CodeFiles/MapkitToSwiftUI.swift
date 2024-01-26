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
        setContextPublihser()
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


// MARK: - Annotation
extension MkMapViewCoordinator {
    
    func setContextPublihser() {
        
        let name = Notification.Name.NSManagedObjectContextObjectsDidChange
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextChangeCallback(_:)), name: name, object: nil)
        
    }
    
    @objc
    func contextChangeCallback(_ notification: Notification) {
        
        // 삽입된 오브젝트
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<Pot> {
            addAnnotation(insertedObjects)
        }
        
        // 수정된 오브젝트
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<Pot> {
            updateAnnotation(updatedObjects)
        }
        
        // 삭제된 오브젝트
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<Pot> {
            deleteAnnotation(deletedObjects)
        }
        
    }
    
    func addAnnotation(_ pots: Set<Pot>) {
        
        let potAnnotations = pots.map { pot in
            
            let object = makePotObjectFrom(pot: pot)
            
            return PotAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: pot.latitude, longitude: pot.longitude),
                isActive: pot.isActive,
                potObject: object,
                thumbNailIamge: pot.imageData
                )
        }
        
        DispatchQueue.main.async {
            
            self.mapView.addAnnotations(potAnnotations)
        }
        
        print("어노테이션 삽입 완료")
    }
    
    func updateAnnotation(_ pots: Set<Pot>) {
        
        var willDeleteAnnotation: [PotAnnotation] = []
        
        mapView.annotations.forEach { someAnot in
            
            if let prevPotAnot = someAnot as? PotAnnotation {
                
                pots.forEach { updatedObject in
                    
                    if prevPotAnot.potObject.id == updatedObject.id {
                        
                        willDeleteAnnotation.append(prevPotAnot)
                        
                    }
                    
                }
                
            }
            
        }
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(willDeleteAnnotation)
        }
        
        let updatedObjects = pots.map {
            PotAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                isActive: $0.isActive,
                potObject: makePotObjectFrom(pot: $0),
                thumbNailIamge: $0.imageData
            )
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(updatedObjects)
        }
        
//        print("어노테이션 업데이트 완료")
    }
    
    func deleteAnnotation(_ pots: Set<Pot>) {
        
        var willRemoveList: [PotAnnotation] = []
        
        mapView.annotations.forEach { potAnnotation in
            
            if let target = potAnnotation as? PotAnnotation {
                
                pots.forEach { deletedAnnotation in
                    
                    if target.potObject.id == deletedAnnotation.id {
                        
                        willRemoveList.append(target)
                        
                    }
                }
            }
        }
        DispatchQueue.main.async {
            
            self.mapView.removeAnnotations(willRemoveList)
        }
//        print("어노테이션 삭제완료")
    }
    
    func makePotObjectFrom(pot: Pot) -> PotObject {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        var dateString = ""
        
        if let expDate = pot.expirationDate {
            var dateString = dateFormatter.string(from: expDate)
        }
        
        return PotObject(id: pot.id, userId: pot.userId, categoryId: pot.categoryId, content: pot.content ?? "", imageKey: pot.imageKey ?? "", expirationDate: dateString, latitude: pot.latitude, longitude: pot.longitude)
    }

    func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    func filteringAnnotations(category: TagCases) {
        
        
        let categoryNumber = category.id
        
        switch category {
        case .all:
            mapView.annotations.forEach {
                if let potAnot = $0 as? PotAnnotation {
                    potAnot.isHiiden = false
                }
            }
        case .hot:
            // TODO: 인기순 처리
            return
        case .life, .question, .information, .party:
            mapView.annotations.forEach { anot in
                if let potAnot = anot as? PotAnnotation, potAnot.potObject.categoryId != categoryNumber {
                    
                    potAnot.isHiiden = true
                    
                }
            }
        }
    }
    
    func fetchPots() {
        
        do {
            let context = SpotStorage.default.mainStorageManager.context
            
            let pots = try context.fetch(Pot.fetchRequest())
            
            let potAnnotations = pots.map { pot in
                PotAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: pot.latitude, longitude: pot.longitude),
                    isActive: true,
                    potObject: makePotObjectFrom(pot: pot),
                    thumbNailIamge: pot.imageData
                )
            }
            
            mapView.addAnnotations(potAnnotations)
            
            print("로컬데이터 어노테이션화 성공")
            
        } catch {
            
            print("로컬데이터 어노테이션화 실패")
        }
        
    }
}


// MARK: - UIViewRepresentable
public struct MapkitViewRepresentable: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    @Binding var isLastestCenterAndMapEqual: Bool
    
    @Binding var selectedCategory: TagCases
    
    var latestCenter: CLLocationCoordinate2D
    
    var mapCenterReciever: (CLLocationCoordinate2D) -> Void
    
    public init(isLastestCenterAndMapEqual: Binding<Bool>, selectedCategory: Binding<TagCases>, latestCenter: CLLocationCoordinate2D, mapCenterReciever: @escaping (CLLocationCoordinate2D) -> Void) {
        self._isLastestCenterAndMapEqual = isLastestCenterAndMapEqual
        self._selectedCategory = selectedCategory
        self.latestCenter = latestCenter
        self.mapCenterReciever = mapCenterReciever
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        let coordi = context.coordinator
        
        coordi.mapView = mapView
        
        mapView.delegate = coordi
        
        coordi.mapView = mapView
        
        // 최초로 로컬의 팟들을 어노테이션으로 변환
        coordi.fetchPots()
        
        setSubscription(coordinator: coordi)
        
        let center = CJLocationManager.getUserLocationFromLocal()

        mapView.setRegion(coordi.regionWith(center: center), animated: false)
        
        // TODO: 상의하기
        mapView.isZoomEnabled = true
        
        print("MapView 초기 설정 완")
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
        
        // 필터링
        context.coordinator.filteringAnnotations(category: self.selectedCategory)
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
