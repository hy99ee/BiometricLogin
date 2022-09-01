import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, StateReciever, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: StateType = CreatePincodeState.start
    @Published var store: AuthenticateStore = AuthenticateStore()
    
    var statePublisher: Published<StateType>.Publisher {
        get { $state }
        set { $state = newValue }
    }
    var statePublished: Published<StateType> { _state }

    var stateMapper: StateMapper?

    var stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    private var anyCancellables: Set<AnyCancellable> = []

    init() {
        $state
            .print("Сreate View Model state: ")
            .compactMap{ $0 as? SenderStateType }
            .sink {[unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)
    }
}
