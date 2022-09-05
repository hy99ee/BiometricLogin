import Foundation
import Combine
import SwiftUI

final class EnterPincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = EnterPincodeState

    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore
    @Published var pincode = ""

    var stateSender: PassthroughSubject<EnterPincodeState, Never> = .init()

    let pincodeRequest: PassthroughSubject<String, Never> = .init()
    let authenticateRequest: PassthroughSubject<Void, Never> = .init()
    let logoutRequest: PassthroughSubject<Void, Never> = .init()

    let removeClick: PassthroughSubject<Void, Never> = .init()
    let numberClick: PassthroughSubject<Int, Never> = .init()
    
    private let maxCount = 4
    private var currentCount = 0

    private let biometric = BiometricIDAuth()
    
    private var anyCancellables: Set<AnyCancellable> = []
    var stateSubscription: AnyCancellable?

    init(store: AuthenticateStore) {
        self.store = store
        
        stateSender.assign(to: &$state)

        authenticateRequest
            .flatMap { [unowned self] in biometric.authenticateUser() }
            .filter { $0 }
            .map { _ in EnterPincodeState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        removeClick
            .sink { [unowned self] _ in
                if pincode.count > 0 {
                    self.pincode.removeLast()
                }
            }
            .store(in: &anyCancellables)
        
        logoutRequest
            .flatMap { [unowned self] in self.store.logout() }
            .map { _ in EnterPincodeState.finish }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)

        numberClick
            .sink { [unowned self] number in
                pincode += String(number)
                if pincode.count == maxCount {
                    self.pincodeRequest.send(pincode)
                }
            }
            .store(in: &anyCancellables)

        pincodeRequest
            .map { _ in EnterPincodeState.request(status: true) }
            .assign(to: &$state)
        
        pincodeRequest
            .delay(for: 3, scheduler: RunLoop.main)
            .map { [unowned self] _ in
                self.state = .request(status: false)
                return ""
            }
            .assign(to: &$pincode)
    }
    
    var biomitricTypeImage: String? {
        switch biometric.biometricType {
        case .none: return nil
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        }
    }
}
