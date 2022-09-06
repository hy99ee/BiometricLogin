import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: StateSender, ObservableObject {    
    typealias SenderStateType = PasswordState
    @Published var state: SenderStateType = .start
    var stateSender: PassthroughSubject<PasswordState, Never> = .init()

    private let store: AuthenticateStore

    let loginRequest: PassthroughSubject<Void, Never> = .init()

    var cancelBag: CancelBag = []

    init(store: AuthenticateStore) {
        self.store = store

        setupBindings()
    }

    private func setupBindings() {
        stateSender.assign(to: &$state)

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordState.finish }
            .receive(on: DispatchQueue.main)
            .subscribe(stateSender)
            .store(in: &cancelBag)
    }
}
