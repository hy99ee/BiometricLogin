import Foundation
import Combine

enum PincodeActions: String {
    case login
    case logout
}

final class EnterPincodeViewModel: StageableVieModel {
    typealias StageType = PincodeStage
    @Published var stage: StageType = .start

    @Published var pinsVisible: String = ""

    private let store: AuthenticateStore

    private let authenticateRequest = PassthroughSubject<Void, Never>()
    private let logoutRequest = PassthroughSubject<Void, Never>()

    let numberClick = PassthroughSubject<Int, Never>()

    private let biometric = BiometricIDAuth()
    private var anyCancellables: Set<AnyCancellable> = []

    let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [PincodeActions.logout.rawValue, "0", PincodeActions.login.rawValue]
    ]

    init(store: AuthenticateStore) {
        self.store = store

        authenticateRequest
            .flatMap { [unowned self] in biometric.authenticateUser() }
            .filter { $0 }
            .map { _ in PincodeStage.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)

        logoutRequest
            .flatMap { [unowned self] in self.store.logout() }
            .map { _ in PincodeStage.logout }
            .receive(on: DispatchQueue.main)
            .assign(to: &$stage)

        numberClick
            .sink {[unowned self] _ in
                pinsVisible += "⚫️"
            }
            .store(in: &anyCancellables)
    }

    func createButtonAction(_ str: String) -> () -> Void {
        switch str {
        case PincodeActions.login.rawValue: return {[weak self] in self?.authenticateRequest.send() }
        case PincodeActions.logout.rawValue: return {[weak self] in self?.logoutRequest.send() }
        default: return { [weak self] in if let number = Int(str) { self?.numberClick.send(number) } }
        }
    }
    
}
