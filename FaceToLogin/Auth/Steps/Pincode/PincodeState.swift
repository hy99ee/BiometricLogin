import Foundation

enum PincodeState: PincodeStateType {
    case start
    case finish
    case logout
}

protocol PincodeStateType: StateType {}

enum EnterPincodeState: PincodeStateType {
    case start
    case finish
    case request(status: Bool)
}

enum CreatePincodeState: PincodeStateType {
    case start
    case finish
    case request(status: Bool)
}
