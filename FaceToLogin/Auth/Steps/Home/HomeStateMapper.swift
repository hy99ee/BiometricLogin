import Foundation

class HomeStateMapper: StateMapper {
    func mapState(_ state: StateType) -> StateType? {
        switch state {
        case PasswordState.finish:
            return PincodeState.start

        case PincodeState.logout:
            return PasswordState.start

        default:
            return state.externalValue
        }
    }
}
