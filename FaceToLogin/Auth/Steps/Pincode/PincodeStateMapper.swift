import Foundation

class PincodeStateMapper: StateMapper {
    private let store: AuthenticateStore
    private var lastMappedStep: PincodeState?

    init(store: AuthenticateStore) {
        self.store = store
    }
    
    func mapState(_ state: StateType) -> StateType? {
        guard let state = state as? PincodeStateType else { return nil }
        return pincodeMapState(state)
    }
    
    private func pincodeMapState(_ state: PincodeStateType) -> PincodeState? {
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
            case let .request(status): return status ? nil : PincodeState.enter
            case .finish: return PincodeState.logout
            default: return nil
            }

        default:
            return PincodeState.logout
        }
    }
    
    private func isFirstLoginState() -> PincodeState {
        self.store.isLogin ?  .create : .enter
    }
}

class PincodeMockMapper: StateMapper {
    func mapState(_ state: StateType) -> StateType? {
        CreatePincodeState.start
    }
}
