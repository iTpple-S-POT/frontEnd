// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import DefaultExtensions

public struct SplashScreen: View {
    
    var logo_image: Image {
        Image(uiImage: UIImage(named: Bundle.module.provideFilePath(name: "splash_logo", ext: "png"))!)
    }
    
    public init() { }
        
    public var body: some View {
        VStack {
            Spacer()
            logo_image
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
            Spacer()
        }
    }
}

#Preview {
    SplashScreen()
}
