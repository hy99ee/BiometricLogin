import Foundation
import Combine

final class AuthenticateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault(key: AuthStoreConstants.username.key, defaultValue: "default")
    var username: String

    @UserDefault(key: AuthStoreConstants.isLogin.key, defaultValue: false)
    var isLogin: Bool

    private var didChangeCancellable: AnyCancellable?

    init() {
        didChangeCancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .subscribe(objectWillChange)
    }
    
    func login() -> AnyPublisher<Void, Never> {
        Deferred {
            Future { [unowned self] promise in
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: "Hy99ee",
                                                        accessGroup: KeychainConfiguration.accessGroup)
                try? passwordItem.savePassword("newPassword")
                isLogin = true
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func logout() -> AnyPublisher<Void, Never> {
        Deferred {
            Future { [unowned self] promise in
                
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: "Hy99ee",
                                                        accessGroup: KeychainConfiguration.accessGroup)

                try? passwordItem.deleteItem()
                isLogin = false
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}

enum AuthStoreConstants {
    case username
    case isLogin

    var key: String {
        switch self {
        case .username: return "user_username"
        case .isLogin: return "user_is_login"
        }
    }
}
