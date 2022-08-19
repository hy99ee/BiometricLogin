import Foundation
import SwiftUI
import Combine

final class EnterPasswordViewModel: StageableVieModel {
    typealias StageType = PasswordStage
    @Published var stage: StageType = .start
    
    private let store: AuthenticateStore

    let loginRequest = PassthroughSubject<Void, Never>()

    private var anyCancellables: Set<AnyCancellable> = []
    
    init(store: AuthenticateStore) {
        self.store = store

        loginRequest
            .flatMap { [unowned self] in self.store.login() }
            .map { _ in PasswordStage.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)
    }

}
