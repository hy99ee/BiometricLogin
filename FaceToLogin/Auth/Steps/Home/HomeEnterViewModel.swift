import Foundation
import Combine

class HomeEnterViewModel: ObservableObject, StateReciever {
    var statePublisher: Published<State>.Publisher {
        get { $state }
        set { $state = newValue }
    }

    var statePublished: Published<State> { _state }

    @Published var state: State

    @Published var isPresented = true
    @Published var store: AuthenticateStore

    let stateMapper: StateMapper

    private var anyCancellables: Set<AnyCancellable> = []

    init(mapper: StateMapper) {
        self.stateMapper = mapper

        let store = AuthenticateStore()
        self.store = store

        state = store.isLogin ? PincodeState.start : PasswordState.start

        setupBindings()
    }
    
    private func setupBindings() {
        store.objectWillChange
            .sink { [unowned self] _ in
                state = store.isLogin ? PincodeState.start : PasswordState.start
                objectWillChange.send()
            }
            .store(in: &anyCancellables)
    }
}
