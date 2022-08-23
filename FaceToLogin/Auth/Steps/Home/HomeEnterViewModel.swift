import Foundation
import Combine

class HomeEnterViewModel: ObservableObject, WithStateMapper {
    @Published var state: State
    @Published var isPresented = true
    @Published private var store: AuthenticateStore

    let pincodeViewModel: EnterPincodeViewModel
    let passwordViewModel: EnterPasswordViewModel

    let stateMapper: StateMapper

    private var anyCancellables: Set<AnyCancellable> = []

    init(mapper: StateMapper) {
        self.stateMapper = mapper

        let store = AuthenticateStore()
        self.store = store
        state = store.isLogin ? PincodeState.start : PasswordState.start

        pincodeViewModel = EnterPincodeViewModel(store: store)
        passwordViewModel = EnterPasswordViewModel(store: store)

        setupBindings()
    }
    
    private func setupBindings() {
        store.objectWillChange
            .sink { [unowned self] _ in objectWillChange.send() }
            .store(in: &anyCancellables)

        passwordViewModel.$state
            .mapState(mapper: stateMapper)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        pincodeViewModel.$state
            .mapState(mapper: stateMapper)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    

}
