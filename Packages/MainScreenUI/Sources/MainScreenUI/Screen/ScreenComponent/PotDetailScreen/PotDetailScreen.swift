//
//  File.swift
//  
//
//  Created by 최유빈 on 1/6/24.
//

import Foundation
import SwiftUI
import CJMapkit
import CoreLocation

struct PotDetailScreen: View {
    var annotation: PotAnnotation // PotAnnotation 인스턴스를 저장하기 위한 프로퍼티
       
       public init(annotation: PotAnnotation) {
           self.annotation = annotation
       }
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ImageScreen()
                .navigationBarTitle("모임", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        // 백 버튼 액션
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    },
                    trailing: Button(action: {
                        // 닫기 버튼 액션
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                )
        }
    }
}

struct PotDetailScreen_Previews: PreviewProvider {
    
    static var annotationDummies: [PotAnnotation] {
    
        let longRange = 126.9244669...126.9254901
        let latRange = 37.550756...37.557527
        
        return PotAnnotationType.allCases.map {
            
            let long = Double.random(in: longRange)
            let lat = Double.random(in: latRange)
            
            return PotAnnotation(type: $0, coordinate: CLLocationCoordinate2DMake(lat, long))
            
        }
        
    }
    
    static var previews: some View {
        
        // 더미 PotAnnotation을 사용하여 PotDetailScreen 프리뷰 생성
        PotDetailScreen(annotation: annotationDummies[0])
    }
}
