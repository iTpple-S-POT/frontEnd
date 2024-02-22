// The Swift Programming Language
import SwiftUI
import Combine
import GlobalObjects

public class Coordinator {
    
    var previousColleciton: CollectionTypeObject = .allPhoto
    
    var subscriptions: Set<AnyCancellable> = []
    
    deinit {
        
        subscriptions.removeAll()
    }
}

public struct CJPhotoCollectionView: UIViewControllerRepresentable {
    
    @Binding var collectionType: CollectionTypeObject
    
    // publisher가 퍼블리쉬시 호출되는 클로저 타입입니다.
    public var selectedPhotoCompletion: (ImageInformation?) -> ()
    public var selectCameraCompletion: () -> ()
    public var collectionTypesCompletion: ([CollectionTypeObject]) -> ()
    public var dismissCompletion: () -> ()
    
    public init(
        collectionType: Binding<CollectionTypeObject>,
        selectedPhotoCompletion: @escaping (ImageInformation?) -> (),
        selectCameraCompletion: @escaping () -> Void,
        collectionTypesCompletion: @escaping ([CollectionTypeObject]) -> (),
        dismissCompletion: @escaping () -> ()) {
        
        self._collectionType = collectionType
        self.selectedPhotoCompletion = selectedPhotoCompletion
        self.selectCameraCompletion = selectCameraCompletion
        self.collectionTypesCompletion = collectionTypesCompletion
        self.dismissCompletion = dismissCompletion
    }
    
    public typealias UIViewControllerType = CJPhotoCollectionViewController
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        
        let collectionViewController = CJPhotoCollectionViewController()
        
        let coordi = context.coordinator
        
        collectionViewController.selectedPhotoPub.sink { _ in
            
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
        .store(in: &coordi.subscriptions)
        
        collectionViewController.selectCameraPub.sink {
            
            selectCameraCompletion()
        }
        .store(in: &coordi.subscriptions)
        
        collectionViewController.collectionTypesPub.sink { _ in
            
            print("connecton finished")
            
        } receiveValue: { data in
            
            DispatchQueue.main.async {
             
                collectionTypesCompletion(data)
                
            }
            
        }
        .store(in: &coordi.subscriptions)
        
        collectionViewController.dismissPub.sink(receiveValue: { _ in
            
            dismissCompletion()
            
        })
        .store(in: &coordi.subscriptions)
        
        
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
