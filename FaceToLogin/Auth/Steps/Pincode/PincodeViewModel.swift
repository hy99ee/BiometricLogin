import Foundation
import Combine

class PincodeViewModel: StateSender, StateReciever, ObservableObject {
    typealias SenderStateType = PincodeState
    var stateSubject: PassthroughSubject<SenderStateType, Never>  = .init()
    @Published var state: StateType
 
    var statePublisher: Published<StateType>.Publisher {
        get { $state }
        set { $state = newValue }
    }

    var statePublished: Published<StateType> { _state }

    var stateMapper: StateMapper?
    let store: AuthenticateStore
    
    private var anyCancellables: Set<AnyCancellable> = []

    init(store: AuthenticateStore) {
        self.store = store
        self.stateMapper = PincodeStateMapper(store: store)
        state = stateMapper!.mapState(SenderStateType.start)!

        $state
            .compactMap{ $0 as? SenderStateType }
            .sink {[unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)
    }
}

