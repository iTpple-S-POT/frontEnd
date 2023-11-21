import SwiftUI
import LoginUI

@main
struct SPOTFEApp: App {
    
    init() {
        KakaoLoginManager.shared.initKakaoSDKWith(appKey: getKakaoAppKey())
    }
    
    var body: some Scene {
        WindowGroup {
            LoginScreen()
                .onOpenURL { url in
                    KakaoLoginManager.shared.completeSocialLogin(url: url)
                }
        }
    }
    
    private func getKakaoAppKey() -> String {
        let path = Bundle.main.provideFilePath(name: "secret", ext: "json")
        
        if let contentsOfFile = try? Data(contentsOf: URL(filePath: path)), let decodedContents = try? JSONDecoder().decode(SecretModel.self, from: contentsOfFile) {
            return decodedContents.keys.kakao_native_app_key
        }
        fatalError("failed to get Kakao app key")
    }

    private struct SecretModel: Decodable {
        struct App_key: Decodable {
            var kakao_native_app_key: String
        }
        var keys: App_key
    }
}
