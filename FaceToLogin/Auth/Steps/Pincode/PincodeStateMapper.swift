import Foundation

class PincodeStateMapper: StateMapper {
    let store: AuthenticateStore
    init(store: AuthenticateStore) {
        self.store = store
    }
    
    func mapState(_ state: StateType) -> StateType? {
        guard let state = state as? PincodeStateType else { return nil }
        return pincodeMapState(state)
    }
    
    private func pincodeMapState(_ state: PincodeStateType) -> PincodeStateType? {
        switch state {
        case let state as PincodeState:
            switch state {
            case .start: return isFirstLoginState()
            default: return nil
            }

        case let state as EnterPincodeState:
            switch state {
            case .finish: return PincodeState.logout
            default: return nil
            }

        case let state as CreatePincodeState:
            switch state {
            case .finish: return PincodeState.finish
            default: return nil
            }

        default:
            return state
        }
    }
    
    private func isFirstLoginState() -> PincodeStateType {
        self.store.isLogin ?  EnterPincodeState.start : CreatePincodeState.start
    }
}

class PincodeMockMapper: StateMapper {
    func mapState(_ state: StateType) -> StateType? {
        PincodeState.logout
    }
}
