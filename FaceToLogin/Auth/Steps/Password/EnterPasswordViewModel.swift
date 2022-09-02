import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: StateSender, ObservableObject {
    typealias SenderStateType = PasswordState
    @Published var state: SenderStateType = .start

    var stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    private let store: AuthenticateStore

    let loginRequest = PassthroughSubject<Void, Never>()

    private var anyCancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticateStore) {
        self.store = store

        $state
            .bindState(to: self)
            .store(in: &anyCancellables)

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

}
