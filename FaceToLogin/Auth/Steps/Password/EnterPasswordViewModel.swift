import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: ObservableObject {
    typealias StateType = PasswordState
    @Published var state: StateType = .start
    
    private let store: AuthenticateStore

    let loginRequest = PassthroughSubject<Void, Never>()

    private var anyCancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticateStore) {
        self.store = store

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

}
