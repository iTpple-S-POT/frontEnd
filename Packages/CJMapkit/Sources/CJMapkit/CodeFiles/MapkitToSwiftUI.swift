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

public extension Notification.Name {
    static let singlePotSelection: Self = .init("singlePotSelection")
    static let multiplePotsSelection: Self = .init("multiplePotsSelection")
    static let potFromPotListView: Self = .init("potFromPotListView")
}


// MARK: - Coordinator
public class MkMapViewCoordinator: NSObject {
    
    var mapView: MKMapView!
    
    var currentActiveCategoryDict: TagsDict!
     
    private static let potAnnotationViewIdentifier = NSStringFromClass(PotAnnotationView.self)
    private static let potClusterAnnotationViewIdentifier = NSStringFromClass(PotClusterAnnotationView.self)
    private static let potClusterAnnotationId = "potAnnotation"
    
    override init() {
        super.init()
        
        registerAnnotation()
        
        configureNotification()
    }
    
    // Annotation
    private func registerAnnotation() {
        guard let mapView = self.mapView else { return }
        
        mapView.register(PotAnnotationView.self, forAnnotationViewWithReuseIdentifier: Self.potAnnotationViewIdentifier)
        mapView.register(PotClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: Self.potClusterAnnotationViewIdentifier)
    }
    
    private func configureNotification() {
        
        NotificationCenter.potMapCenter.addObserver(self, selector: #selector(makeMapToProjectCertaionCoordinate(_:)), name: .moveMapCenterToSpecificLocation, object: nil)
    }
    
    @objc
    func makeMapToProjectCertaionCoordinate(_ notification: Notification) {
        
        guard let coordinate = notification.object as? [String: CGFloat] else { return }
        
        let lat = coordinate["latitude"]!
        let lon = coordinate["longitude"]!
        
        let desRegion = regionWith(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        self.mapView.setRegion(desRegion, animated: true)
    }
    
    // span을 동일하게 유지하기 위해
    func regionWith(center: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
        return MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
}

// MARK: - MKMapViewDelegate
extension MkMapViewCoordinator: MKMapViewDelegate {
    
    // Annotation
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
            
            let height = PotAnnotationViewConfig.annotationSize.height
            
            potAnnotationView.centerOffset.y = -sqrt(2.0) * height/2
            
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
    
    // map위치 변동
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let coordinate = mapView.region.center
        
        let object: [String: CGFloat] = [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
        
        NotificationCenter.potMapCenter.post(name: .whenUserMoveTheMap, object: object)
    }
}

// MARK: - UIViewRepresentable
public struct MapkitViewRepresentable: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    var initialCoordinate: CLLocationCoordinate2D
    
    @Binding var activeCategoryDict: TagsDict
    
    @Binding var potViewModels: Set<PotViewModel>
    
    public init(
        initialCoordinate: CLLocationCoordinate2D,
        activeCategoryDict: Binding<TagsDict>,
        potViewModels: Binding<Set<PotViewModel>>
    ) {
        self.initialCoordinate = initialCoordinate
        self._activeCategoryDict = activeCategoryDict
        self._potViewModels = potViewModels
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        let coordinator = context.coordinator
        
        coordinator.mapView = mapView
    
        // 현재 카테고리를 저장
        coordinator.currentActiveCategoryDict = self.activeCategoryDict
        
        mapView.delegate = coordinator
        
        coordinator.mapView = mapView
        
        mapView.setRegion(coordinator.regionWith(center: initialCoordinate), animated: false)
        
        return mapView
    }
    
    public func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // 카테고리 필터링
        let coordinator = context.coordinator
        
        if coordinator.currentActiveCategoryDict != self.activeCategoryDict {
            
            // 값 업데이트
            coordinator.currentActiveCategoryDict = self.activeCategoryDict
            
            filterAnnotations(mapView: uiView)
        }
        
        // Annotation적용
        makePotAnnotationsFrom(mapView: uiView)
    }
    
    func makePotAnnotationsFrom(mapView: MKMapView) {
        
        let newPotModels: Set<PotViewModel> = self.potViewModels
        
        let oldPotModels: Set<PotViewModel> = Set(mapView.annotations.compactMap {
            
            guard let potAnnot = $0 as? PotAnnotation else { return nil }
            
            let vm = PotViewModel(model: potAnnot.potModel)
            
            return vm
        })
        
        let newMinusOld = newPotModels.subtracting(oldPotModels)
        
        let willAddAnnotations = newMinusOld.map { PotAnnotation(potModel: $0.model) }
        
        let willDiscardAnnotations = oldPotModels.subtracting(newPotModels).map { PotAnnotation(potModel: $0.model) }
        
        mapView.addAnnotations(willAddAnnotations)
        mapView.removeAnnotations(willDiscardAnnotations)
    }
    
    func filterAnnotations(mapView: MKMapView) {
        
        let dict = self.activeCategoryDict
        
        var potAnnots = mapView.annotations.compactMap { annot in
            annot as? PotAnnotation
        }
        
        if dict[.hot]! {
            
            let hotCount = 3
            
            potAnnots.sort { lhs, rhs in
                lhs.potModel.viewCount < rhs.potModel.viewCount
            }
            
            if potAnnots.count > hotCount {
                
                potAnnots = Array(potAnnots[0...2])
            }
            
            mapView.showHotMarks(potAnnots)
            
            return
        } else {
            
            mapView.hideHotMarks(potAnnots, withDuration: 0)
        }
        
        if dict[.all]! {
            
            mapView.unhideAnnotations(potAnnots)
            return
        }
        
        var willDisplayAnnotations: [MKAnnotation] = []
        var wiilHideAnnotations: [MKAnnotation] = []
        
        mapView.annotations.forEach { annotation in
            
            if let potAnot = annotation as? PotAnnotation {
                
                let annotationCatId = potAnot.potModel.categoryId
                
                if dict[TagCases(rawValue: Int(annotationCatId))!]! {
                    
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
