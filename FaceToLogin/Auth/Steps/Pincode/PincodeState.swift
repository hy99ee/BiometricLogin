import Foundation

enum PincodeState: StateType {
    case start
    case finish
    case logout

    case createStart
    case createFinish
    case enterStart
    case enterFinish

    case request(status: Bool)

    var externalValue: Self? {
        switch self {
        case .start, .finish, .logout: return self
        default: return nil
        }
    }
}
