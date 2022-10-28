import Foundation
import Combine
import SwiftUI

final class PincodeViewModel: StateTransitor, ObservableObject {
    typealias SenderStateType = PincodeState
    var stateSender: PassthroughSubject<SenderStateType, Never> = .init()
    var stateReceiver: PassthroughSubject<StateType, Never> = .init()

    @Published var state: StateType

    let stateMapper: StateMapper?
    let store: AuthenticateStore

    var stateFilter: StateFilter? = BaseStateFilter(filter: {
        switch $0 {
        case PincodeState.logout: return true
        default: return false
        }
    })

    var cancelBag: CancelBag = []

    init(store: AuthenticateStore, mapper: StateMapper? = nil) {
        self.store = store
        self.stateMapper = mapper == nil ? PincodeStateMapper(store: store) : mapper

        let state = stateMapper!.mapState(PincodeState.start) ?? PincodeState.logout
        self.state = state
        
        setupBindings()
    }
    
    private func setupBindings() {
        self.bindState(
            sender: self,
            receiver: self,
            viewState: &$state
        )
    }
}
