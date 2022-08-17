import Foundation
import Combine

final class AuthenticateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault(key: AuthStoreConstants.username.key, defaultValue: "")
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
}

enum AuthStoreConstants {
    case username
    case isLogin
//    case isSeccussAuth

    var key: String {
        switch self {
        case .username: return "user_username"
        case .isLogin: return "user_is_login"
//        case .isSeccussAuth: return "user_is_seccess_auth"
        }
    }
}
