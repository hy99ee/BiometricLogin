import Foundation

protocol PincodeStateType: StateType {}

enum PincodeState: PincodeStateType {
    case start
    case finish
    case logout
}
