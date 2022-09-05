import Foundation
import Combine

class PincodeViewModel: StateSender, StateReciever, ObservableObject {    
    typealias SenderStateType = PincodeState
    var stateSender: PassthroughSubject<SenderStateType, Never> = .init()
    var stateReceiver: PassthroughSubject<StateType, Never> = .init()
    @Published var state: StateType

    let stateMapper: StateMapper?
    let store: AuthenticateStore
    
    private var anyCancellables: Set<AnyCancellable> = []
    var stateSubscription: AnyCancellable?

    init(store: AuthenticateStore, mapper: StateMapper? = nil) {
        self.store = store
        self.stateMapper = mapper == nil ? PincodeStateMapper(store: store) : mapper

        let state = stateMapper!.mapState(SenderStateType.start) ?? PincodeState.logout
        self.state = state

        if let state = state as? SenderStateType { stateSender.send(state) }
        
        stateReceiver
            .print("---")
            .compactMap{ $0 as? SenderStateType }
            .assign(to: &$state)
    }
}

