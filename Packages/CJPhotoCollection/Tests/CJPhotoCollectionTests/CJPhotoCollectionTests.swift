import XCTest
@testable import CJPhotoCollection

final class CJPhotoCollectionTests: XCTestCase {
    
    
    func test_ImageInfoStringFromKey() throws {
        
        for key in CJPhotoCollectionViewController.ImageInfoKey.allCases {
            
            try key.getStringKey()
            
        }
        
    }
    
}
