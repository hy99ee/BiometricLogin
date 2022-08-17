import Foundation
import Combine

enum PincodeActions: String {
    case login
    case logout
}

class EnterPincodeViewModel: ObservableObject {
    @Published var stage: AuthenticateStage = .startPincode
    @Published var pinsVisible: String = ""

    private let biometric = BiometricIDAuth()
    private var anyCancellables: Set<AnyCancellable> = []
    
    let authenticateRequest = PassthroughSubject<Void, Never>()
    let logoutRequest = PassthroughSubject<Void, Never>()

    let numberClick = PassthroughSubject<Int, Never>()

    init() {
        authenticateRequest
            .flatMap { [unowned self] in biometric.authenticateUser() }
            .filter { $0 }
            .map { _ in AuthenticateStage.finishPincode }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)

        numberClick
            .sink {[unowned self] _ in
                pinsVisible += "⚫️"
            }
            .store(in: &anyCancellables)
    }
    
    func logout() {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: "Hy99ee",
                                                accessGroup: KeychainConfiguration.accessGroup)

        try? passwordItem.deleteItem()
    }
    
}
