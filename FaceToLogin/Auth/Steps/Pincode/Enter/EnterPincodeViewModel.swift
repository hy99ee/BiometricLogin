import Foundation
import Combine

final class EnterPincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = EnterPincodeState
    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore

    var stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    let pincode: PassthroughSubject<String, Never> = .init()

    @Published var pinsVisible: String = ""

    private let maxCount = 4
    private var currentCount = 0
    private var currentPincode = ""

    let authenticateRequest = PassthroughSubject<Void, Never>()
    let logoutRequest = PassthroughSubject<Void, Never>()
    let removeClick = PassthroughSubject<Void, Never>()
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
            .print("Enter View Model state: ")
            .sink { [unowned self] in stateSubject.send($0) }
            .store(in: &anyCancellables)

        authenticateRequest
            .flatMap { [unowned self] in biometric.authenticateUser() }
            .filter { $0 }
            .map { _ in EnterPincodeState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        removeClick
            .compactMap { [unowned self] _ -> String in
                if currentPincode.count > 0 {
                    self.currentPincode.removeLast()
                }
                return currentPincode
            }
            .map {
                var visible = ""
                for _ in $0 {
                    visible.append(contentsOf: " ● ")
                }
                return visible
            }
            .assign(to: &$pinsVisible)
        
        logoutRequest
            .flatMap { [unowned self] in self.store.logout() }
            .map { _ in EnterPincodeState.finish }
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
    
    var biomitricTypeImage: String? {
        switch biometric.biometricType {
        case .none: return nil
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        }
    }
}
