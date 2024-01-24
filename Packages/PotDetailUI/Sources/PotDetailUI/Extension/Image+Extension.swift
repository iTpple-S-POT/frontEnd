//
//  File.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI

public extension Image {
    
    enum FileExtCase: String {
        case png = "png"
        case jpg = "jpg"
        case jpeg = "jpeg"
    }
    
    /**
     Bundle.module에 저장되어 있는 이미지 리소스를 불러들여 Image를 생성합니다.
     
     - Parameters
        - name: 파일의 이름
        - ext: 파일 익스텐션
     
     - Returns: 파일을 불러들여 생성한 Image인스턴스
     */
    static func makeImageFromBundle(bundle: Bundle, name: String, ext: FileExtCase) -> Image {
        
        let path = bundle.provideFilePath(name: name, ext: ext.rawValue)
        
        guard let uiImage = UIImage(named: path) else { fatalError("\(name).\(ext.rawValue)를 찾을 수 없음") }
        
        return Image(uiImage: uiImage)
    }
}

