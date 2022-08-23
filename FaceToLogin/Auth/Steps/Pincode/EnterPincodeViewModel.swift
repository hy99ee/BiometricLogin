import Foundation
import Combine

enum PincodeActions: String {
    case login
    case logout
}

final class EnterPincodeViewModel: ObservableObject {
    typealias StateType = PincodeState
    @Published var state: StateType = .start

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
            .map { _ in PincodeState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        logoutRequest
            .flatMap { [unowned self] in self.store.logout() }
            .map { _ in PincodeState.logout }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

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
