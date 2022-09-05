import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: StateSender, ObservableObject {    
    typealias SenderStateType = PasswordState
    @Published var state: SenderStateType = .start
    var stateSender: PassthroughSubject<PasswordState, Never> = .init()

    private let store: AuthenticateStore

    let loginRequest: PassthroughSubject<Void, Never> = .init()

    private var anyCancellables: Set<AnyCancellable> = []
    var stateSubscription: AnyCancellable?

    init(store: AuthenticateStore) {
        self.store = store

        stateSender
            .assign(to: &$state)
//            .store(in: &anyCancellables)

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

}
