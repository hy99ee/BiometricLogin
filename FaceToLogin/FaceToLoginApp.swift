import SwiftUI

@main
struct FaceToLoginApp: App {
    private let store = AuthenticateStore()
    var body: some Scene {
        WindowGroup {
            HomeEnterView()
                .environmentObject(HomeEnterViewModel(mapper: HomeStateMapper()))
        }
    }
}
