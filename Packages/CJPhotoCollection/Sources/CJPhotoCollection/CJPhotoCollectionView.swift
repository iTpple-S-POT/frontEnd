// The Swift Programming Language
import SwiftUI
import Combine
import GlobalObjects

public class Coordinator {
    
    var previousColleciton: CollectionTypeObject = .allPhoto
    
    var selectedPhotoSub: AnyCancellable?
    
    var collectionListSub: AnyCancellable?
    
    deinit {
        
        selectedPhotoSub?.cancel()
        collectionListSub?.cancel()
    }
}

public struct CJPhotoCollectionView: UIViewControllerRepresentable {
    
    @Binding var collectionType: CollectionTypeObject
    
    // publisher가 퍼블리쉬시 호출되는 클로저 타입입니다.
    public var selectedPhotoCompletion: (ImageInformation?) -> ()
    public var collectionTypesCompletion: ([CollectionTypeObject]) -> ()
    
    public init(collectionType: Binding<CollectionTypeObject>, selectedPhotoCompletion: @escaping (ImageInformation?) -> (), collectionTypesCompletion: @escaping ([CollectionTypeObject]) -> ()) {
        
        self._collectionType = collectionType
        self.selectedPhotoCompletion = selectedPhotoCompletion
        self.collectionTypesCompletion = collectionTypesCompletion
    }
    
    public typealias UIViewControllerType = CJPhotoCollectionViewController
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        
        let collectionViewController = CJPhotoCollectionViewController()
        
        let coordi = context.coordinator
        
        coordi.selectedPhotoSub = collectionViewController.selectedPhotoPub.sink { _ in
            
            print("connecton finished")
            
        } receiveValue: { result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    
                    selectedPhotoCompletion(data)
                    
                }
            case .failure(let error):
                switch error {
                    
                case .invalidSuffix(let orignalExt):
                    print("\(orignalExt)를 png로 변경 실패")
                default:
                    print(error.localizedDescription)
                }
                
                selectedPhotoCompletion(nil)
            }
            
        }
        
        coordi.collectionListSub = collectionViewController.collectionTypesPub.sink { _ in
            
            print("connecton finished")
            
        } receiveValue: { data in
            
            DispatchQueue.main.async {
             
                collectionTypesCompletion(data)
                
            }
            
        }
        
        return collectionViewController
        
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        let coodi = context.coordinator
        
        if coodi.previousColleciton == collectionType {
            
            return
        }
        
        // Binding 프롵퍼티 수정시 호출
        coodi.previousColleciton = collectionType
        
        uiViewController.fetchPhotos(typeObject: collectionType)
        uiViewController.collectionView.reloadData()
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}
