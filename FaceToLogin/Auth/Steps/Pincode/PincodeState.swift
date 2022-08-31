import Foundation

enum PincodeState: PincodeStateType {
    case start
    case finish
    case logout
}

protocol PincodeStateType: StateType {}
