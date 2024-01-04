// The Swift Programming Language
import SwiftUI
import Combine
import GlobalObjects

class MySub {
    
    var sub: AnyCancellable?
    
}

public struct CJPhotoCollectionView: UIViewControllerRepresentable {
    
    public typealias SubClosure = (ImageInformation?) -> ()
    
    // publisher가 퍼블리쉬시 호출되는 클로저 타입입니다.
    public var completion: SubClosure
    
    private var mySub = MySub()
    
    public init(completion: @escaping SubClosure) {
        
        self.completion = completion
        
    }
    
    public typealias UIViewControllerType = CJPhotoCollectionViewController
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        
        let collectionViewController = CJPhotoCollectionViewController()
        
        mySub.sub = collectionViewController.pub.sink { _ in
            
            print("connecton finished")
            
        } receiveValue: { data in
            
            DispatchQueue.main.async {
                
                completion(data)
                
            }
            
        }
        
        return collectionViewController
        
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        // Binding 프롵퍼티 수정시 호출
        
    }
    
}
