import SwiftUI
import UIKit
import MapKit


// MARK: - Coordinator
public class MkMapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView?
    
    override init() {
        super.init()
        registerAnnotation()
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
        
        uiView.camera.centerCoordinate = self.userLocation
        
    }
}
