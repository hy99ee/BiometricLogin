import Foundation
import Combine

class PincodeViewModel: StateSender, StateReciever, ObservableObject {
    typealias SenderStateType = PincodeState

    @Published var state: StateType
    var stateSubject: PassthroughSubject<SenderStateType, Never>  = .init()
 
    var statePublisher: Published<StateType>.Publisher {
        get { $state }
        set { $state = newValue }
    }

    var statePublished: Published<StateType> { _state }

    let stateMapper: StateMapper?
    let store: AuthenticateStore
    
    private var anyCancellables: Set<AnyCancellable> = []

    init(store: AuthenticateStore, mapper: StateMapper? = nil) {
        self.store = store
        self.stateMapper = mapper == nil ? PincodeStateMapper(store: store) : mapper

        let state = stateMapper!.mapState(SenderStateType.start) ?? PincodeState.logout
        self.state = state

        $state
            .print("---")
            .compactMap{ $0 as? SenderStateType }
            .receive(on: DispatchQueue.main)
            .bindState(to: self)
//            .subscribe(stateSubject)
            .store(in: &anyCancellables)
    }
}

