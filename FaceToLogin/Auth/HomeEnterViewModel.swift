import Foundation
import Combine

class HomeEnterViewModel: ObservableObject {
    @Published var stage: Stage
    @Published var isPresented = true
    @Published private var store: AuthenticateStore

    let pincodeViewModel: EnterPincodeViewModel
    let passwordViewModel: EnterPasswordViewModel
    
    private var anyCancellables: Set<AnyCancellable> = []

    init() {
        let store = AuthenticateStore()
        self.store = store
        stage = store.isLogin ? PincodeStage.start : PasswordStage.start

        pincodeViewModel = EnterPincodeViewModel(store: store)
        passwordViewModel = EnterPasswordViewModel(store: store)

        setupBindings()
    }
    
    private func setupBindings() {
        store.objectWillChange
            .sink { [unowned self] _ in objectWillChange.send() }
            .store(in: &anyCancellables)

        passwordViewModel.$stage
            .compactMap {  [unowned self] in transformStage($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)

        pincodeViewModel.$stage
            .compactMap {  [unowned self] in transformStage($0) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)
    }
    
    private func transformStage(_ stage: Stage) -> Stage? {
        switch stage {
        case PasswordStage.finish:
            return PincodeStage.start

        case PincodeStage.logout:
            return PasswordStage.start

        default:
            return stage
        }
    }
}
