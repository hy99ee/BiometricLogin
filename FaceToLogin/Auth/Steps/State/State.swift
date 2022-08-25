import Foundation

protocol State {
    var externalValue: Self? { get }
}

enum PincodeState: State {
    case start
    case finish
    case logout

    case request(status: Bool)

    var externalValue: Self? {
        switch self {
        case .request(_): return nil
        default: return self
        }
    }
}

enum PasswordState: Int, State {
    case start
    case finish
    
    var externalValue: Self? {
        self
    }
}
