import Foundation

enum EnterPincodeState: PincodeStateType {
    case start
    case finish
    case request(status: Bool)
}
