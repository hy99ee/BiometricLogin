import Foundation
import Combine

class HomeEnterViewModel: ObservableObject, StateReciever {
    var statePublisher: Published<StateType>.Publisher {
        get { $state }
        set { $state = newValue }
    }

    var statePublished: Published<StateType> { _state }

    @Published var state: StateType

    @Published var isPresented = true
    let store: AuthenticateStore

    let stateMapper: StateMapper?

    private var anyCancellables: Set<AnyCancellable> = []

    init(mapper: StateMapper) {
        self.stateMapper = mapper

        store = AuthenticateStore()
        state = store.isLogin ? PincodeState.start : PasswordState.start
    }
}
