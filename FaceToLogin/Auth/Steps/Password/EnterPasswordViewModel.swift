import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: StateSender, ObservableObject {
    typealias StateType = PasswordState
    @Published var state: StateType = .start

    var stateSubject: PassthroughSubject<StateType, Never> = .init()

    private let store: AuthenticateStore

    let loginRequest = PassthroughSubject<Void, Never>()

    private var anyCancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticateStore) {
        self.store = store

        $state
            .sink { [unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

}
