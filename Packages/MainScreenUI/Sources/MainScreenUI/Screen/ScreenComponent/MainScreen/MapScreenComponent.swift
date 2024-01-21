import SwiftUI
import CJMapkit
import CoreLocation

//extension Notification.Name {
//    static let annotationDidSelect = Notification.Name("annotationDidSelect")
//}

struct MapScreenComponent: View {
    @State private var selectedAnnotation: PotAnnotation?
    
    var annotationDummies: [PotAnnotation] {
        
        let longRange = 126.9244669...126.9254901
        let latRange = 37.550756...37.557527
        
        return PotAnnotationType.allCases.map {
            
            let long = Double.random(in: longRange)
            let lat = Double.random(in: latRange)
            
            return PotAnnotation(type: $0, coordinate: CLLocationCoordinate2DMake(lat, long))
            
        }
        
    }
    
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
    }
}

extension Notification.Name {
    static let annotationDidSelect = Notification.Name("annotationDidSelect")
}

#Preview {
    MapScreenComponent()
}

