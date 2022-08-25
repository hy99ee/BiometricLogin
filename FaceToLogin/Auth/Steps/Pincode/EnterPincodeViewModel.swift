import Foundation
import Combine

final class EnterPincodeViewModel: StateSender, ObservableObject {
    typealias StateType = PincodeState
    @Published var state: StateType = .start

    var stateSubject: PassthroughSubject<StateType, Never> = .init()

    let pincode: PassthroughSubject<String, Never> = .init()

    @Published var pinsVisible: String = ""

    private let maxCount = 4
    private var currentCount = 0
    private var currentPincode = ""

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
        
        $state
            .sink { [unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)

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
            .compactMap { [unowned self] number -> String? in
                currentPincode += String(number)
                if currentPincode.count == maxCount {
                    self.pincode.send(currentPincode)
                } else if currentPincode.count > maxCount {
                    return nil
                }
                return currentPincode
            }
            .print("+++")
            .map {
                var visible = ""
                for _ in $0 {
                    visible.append(contentsOf: " ● ")
                }
                return visible
            }
            .assign(to: &$pinsVisible)

        pincode
            .sink { [unowned self] _ in self.state = .request(status: true) }
            .store(in: &anyCancellables)
        
        pincode
            .delay(for: 3, scheduler: RunLoop.main)
            .map { [unowned self] _ in
                self.state = .request(status: false)
                self.currentPincode = ""
                return self.currentPincode
            }
            .assign(to: &$pinsVisible)
    }

    func createButtonAction(_ str: String) -> () -> Void {
        switch str {
        case PincodeActions.login.rawValue: return {[weak self] in self?.authenticateRequest.send() }
        case PincodeActions.logout.rawValue: return {[weak self] in self?.logoutRequest.send() }
        default: return { [weak self] in if let number = Int(str) { self?.numberClick.send(number) } }
        }
    }
    
}
