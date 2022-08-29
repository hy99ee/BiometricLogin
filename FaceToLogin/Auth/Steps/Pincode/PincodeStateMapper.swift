import Foundation

class PincodeStateMapper: StateMapper {
    let store: AuthenticateStore
    init(store: AuthenticateStore) {
        self.store = store
    }
    
    func mapState(_ state: StateType) -> StateType? {
        guard let state = state as? PincodeState else { return nil }
        return pincodeMapState(state)
    }
    
    private func pincodeMapState(_ state: PincodeState) -> PincodeState? {
        switch state {
        case .enterFinish, .createFinish:
            return .finish

        case .start:
            return isFirstLoginState()

        default:
            return state.externalValue
        }
    }
    
    private func isFirstLoginState() -> PincodeState {
        self.store.isLogin ? .enterStart : .createStart
    }
}
