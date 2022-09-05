import Foundation
import Combine

final class AuthenticateStore {
    @UserDefault(key: AuthStoreConstants.isLogin.key, defaultValue: false)
    var isLogin: Bool
    
    private let pincode = KeychainPincodeItem(service: KeychainConfiguration.serviceName,
                                              account: "Hy99ee",
                                              accessGroup: KeychainConfiguration.accessGroup)

    private var didChangeCancellable: AnyCancellable?

    init() {
    }
    
    func save(_ passcode: String) -> AnyPublisher<Void, Never> {
        Deferred {
            Future {[unowned self] promise in
                try? pincode.savePassword("newPassword")
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Void, Never> {
        Deferred {
            Future { [unowned self] promise in
                try? pincode.deleteItem()
                isLogin = false
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}

enum AuthStoreConstants {
    case isLogin

    var key: String {
        switch self {
        case .isLogin: return "user_is_login"
        }
    }
}
