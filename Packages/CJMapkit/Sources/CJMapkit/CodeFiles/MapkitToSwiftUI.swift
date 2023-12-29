import SwiftUI
import UIKit
import MapKit


// MARK: - Coordinator
internal class MkMapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView?
    
    override init() {
        super.init()
        registerAnnotation()
        
        // Closure등록
        CJLocationManager.shared.registerUpdatingCenterClosure(closure: updateCenter(location:))
        
        CJLocationManager.shared.requestAuthorization()
    }
    
    
    private func registerAnnotation() {
        guard let mapView = self.mapView else { return }
        
        mapView.register(PotAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PotAnnotationView.self))
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let someAnnotation = annotation as! AnnotationClassType
        
        switch someAnnotation.identifier {
        case NSStringFromClass(PotAnnotation.self):
            return PotAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(PotAnnotationView.self))
        default:
            return nil
        }
    }
    
    /// User의 현재 위치로 center를 지정
    func updateCenter(location: CLLocation) {
        mapView?.region.center = location.coordinate
    }
}

// MARK: - UIViewRepresentable
internal struct MapkitView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    var center: CLLocationCoordinate2D
    
    var annotations: [AnnotationClassType]
    
    init(firstLocation: CLLocation, annotations: [AnnotationClassType]) {
        self.annotations = annotations
        self.center = firstLocation.coordinate
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        // Set span
        let mapCenterCoordinate = self.center
        let cr = MKCoordinateRegion(center: mapCenterCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.region = cr
        mapView.isZoomEnabled = false
        
        // Add annotations
        mapView.addAnnotations(self.annotations)
        
        return mapView
    }
    
    func makeCoordinator() -> MkMapViewCoordinator {
        MkMapViewCoordinator()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) { }
}

// MARK: - SwiftUI View
public struct CJMapkitView: View {
    public var userLocation: CLLocation
    public var annotations: [AnnotationClassType]
    
    public init(userLocation: CLLocation, annotations: [AnnotationClassType]) {
        self.userLocation = userLocation
        self.annotations = annotations
    }

    public var body: some View {
        MapkitView(firstLocation: userLocation, annotations: annotations)
    }
}
