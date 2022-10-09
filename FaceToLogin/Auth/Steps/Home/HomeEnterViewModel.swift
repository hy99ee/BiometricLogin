import Foundation
import Combine

class HomeEnterViewModel: ObservableObject, StateReciever {
    @Published var state: StateType
    @Published var isPresented = true
    
    var stateReceiver: PassthroughSubject<StateType, Never> = .init()
    let stateMapper: StateMapper?

    let store: AuthenticateStore

    var cancelBag: CancelBag = []

    init(mapper: StateMapper) {
        self.stateMapper = mapper

        store = AuthenticateStore()
        state = store.isLogin ? PincodeState.start : PasswordState.start
        
        stateReceiver
            .compactMap { mapper.mapState($0) }
            .assign(to: &$state)
    }
}
