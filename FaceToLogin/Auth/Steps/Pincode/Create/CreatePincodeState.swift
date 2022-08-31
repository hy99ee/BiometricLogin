import Foundation

enum CreatePincodeState: PincodeStateType {
    case start
    case finish
    case request(status: Bool)
}
