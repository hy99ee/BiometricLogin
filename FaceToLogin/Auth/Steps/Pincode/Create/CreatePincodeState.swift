import Foundation

enum CreatePincodeState: PincodeStateType {
    case start
    case approve
    case loading
    case failure
    case request(status: Bool)
    case finish
}
