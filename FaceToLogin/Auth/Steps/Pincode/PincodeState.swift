import Foundation

protocol PincodeStateType: StateType {}

enum PincodeState: PincodeStateType {
    case start
    case create
    case enter
    case logout
}
