import Foundation
import Combine
import SwiftUI

final class EnterPincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = EnterPincodeState

    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore
    @Published var pinsVisible: String = ""

    var stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    let pincodeRequest: PassthroughSubject<String, Never> = .init()
    let authenticateRequest: PassthroughSubject<Void, Never> = .init()
    let logoutRequest: PassthroughSubject<Void, Never> = .init()

    let removeClick: PassthroughSubject<Void, Never> = .init()
    let numberClick: PassthroughSubject<Int, Never> = .init()
    
    private let maxCount = 4
    private var currentCount = 0
    private var currentPincode = ""

    private let biometric = BiometricIDAuth()
    
    private var anyCancellables: Set<AnyCancellable> = []

    init(store: AuthenticateStore) {
        self.store = store
        
        $state
            .bindState(to: self)
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
                    self.pincodeRequest.send(currentPincode)
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

        pincodeRequest
            .sink { [unowned self] _ in self.state = .request(status: true) }
            .store(in: &anyCancellables)
        
        pincodeRequest
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
