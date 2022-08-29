import Foundation
import Combine

class PincodeCoordinatorViewModel: StateSender, StateReciever, ObservableObject {
    typealias StateTypeSender = PincodeState
    var stateSubject: PassthroughSubject<StateTypeSender, Never>  = .init()
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
        state = stateMapper!.mapState(StateTypeSender.start)!

        $state
            .compactMap{ $0 as? StateTypeSender }
            .print()
            .sink {[unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)
    }
}

