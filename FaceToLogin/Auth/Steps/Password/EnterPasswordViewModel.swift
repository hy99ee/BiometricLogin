import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: ObservableObject {
    @Published var stage: AuthenticateStage = .startPassword
    private let store: AuthenticateStore
    
    private var anyCancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticateStore) {
        self.store = store
    }
    
    func configured() -> Self {
        
        return self
    }

    func saveUser() {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: "Hy99ee",
                                                accessGroup: KeychainConfiguration.accessGroup)
        try? passwordItem.savePassword("newPassword")
        store.isLogin = true

        stage = .finishPassword
    }
    

}
