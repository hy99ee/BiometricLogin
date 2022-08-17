import Foundation
import Combine

class HomeEnterViewModel: ObservableObject {
    @Published var store: AuthenticateStore

    @Published var internalStage: AuthenticateStage
    let externalStage = PassthroughSubject<AuthenticateStage, Never>()

    @Published var isPresented = true
    
    private var anyCancellables: Set<AnyCancellable> = []
    
    init() {
        let store = AuthenticateStore()
        self.store = store
        internalStage = store.isLogin ? .startPincode : .startPassword

        externalStage
            .map { [unowned self] in emitNextStage($0) }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$internalStage)

        store.objectWillChange
            .sink { [unowned self] _ in objectWillChange.send() }
            .store(in: &anyCancellables)
    }
    
    private func emitNextStage(_ stage: AuthenticateStage) -> AuthenticateStage? {
        switch stage {
        case .startPassword:
            return nil

        case .finishPassword:
            return .startPincode

        case .startPincode:
            return nil

        case .finishPincode:
            return .authSeccuss

        case .authSeccuss:
            return nil
        }
    }
}
