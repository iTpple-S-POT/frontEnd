import SwiftUI
import UserInformationUI

@main
struct CameraApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            UserInformationConfigurationScreen()
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        
//        UserInformationConfigurationScreen()
        NavigationView {
            
//            ProfileEditView(userInfo: ) {
//                
//                
//            }
        }
    }
}

#Preview {
    
    ContentView()
}
