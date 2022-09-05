import Foundation
import Combine

class PincodeViewModel: StateSender, StateReciever, ObservableObject {    
    typealias SenderStateType = PincodeState
    var stateSender: PassthroughSubject<SenderStateType, Never> = .init()
    var stateReceiver: PassthroughSubject<StateType, Never> = .init()
    @Published var state: StateType

    let stateMapper: StateMapper?
    let store: AuthenticateStore
    
    var cancelBag: CancelBag = []

    init(store: AuthenticateStore, mapper: StateMapper? = nil) {
        self.store = store
        self.stateMapper = mapper == nil ? PincodeStateMapper(store: store) : mapper

        let state = stateMapper!.mapState(SenderStateType.start) ?? PincodeState.logout
        self.state = state
        
        setupBindings()
        
        stateReceiver.send(state)
    }
    
    private func setupBindings() {
        self.bindState(on: self)

        stateSender
            .compactMap{ $0 }
            .assign(to: &$state)
    }
}

