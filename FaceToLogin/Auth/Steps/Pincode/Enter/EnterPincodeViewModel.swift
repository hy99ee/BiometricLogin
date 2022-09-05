import Foundation
import Combine
import SwiftUI

final class EnterPincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = EnterPincodeState

    @Published var state: SenderStateType = .start

    @Published var passcode = Passcode()
    @Published var numbers = PasscodeNumbersViewModel()

    var stateSender: PassthroughSubject<EnterPincodeState, Never> = .init()

    let passcodeRequest: PassthroughSubject<[Int], Never> = .init()
    let authenticateRequest: PassthroughSubject<Void, Never> = .init()
    let logoutRequest: PassthroughSubject<Void, Never> = .init()

    private let store: AuthenticateStore

    private let maxCount = 4
    private var currentCount = 0

    private let biometric = BiometricIDAuth()
    
    var cancelBag: CancelBag = []

    init(store: AuthenticateStore) {
        self.store = store

        setupBindings()
    }
    
    var biomitricTypeImage: String? {
        switch biometric.biometricType {
        case .none: return nil
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        }
    }
    
    private func setupBindings() {
        stateSender.assign(to: &$state)

        self.objectWillChange.sink { [unowned self] in self.numbers.objectWillChange.send() }.store(in: &cancelBag)
        passcode.objectWillChange.sink { [unowned self] in self.objectWillChange.send() }.store(in: &cancelBag)

        authenticateRequest
            .flatMap { [unowned self] in biometric.authenticateUser() }
            .filter { $0 }
            .map { _ in EnterPincodeState.finish }
            .receive(on: DispatchQueue.main)
            .subscribe(stateSender)
            .store(in: &cancelBag)
        
        numbers.leftButtonClicked
            .subscribe(logoutRequest)
            .store(in: &cancelBag)

        numbers.rightButtonClicked
            .sink {[unowned self] in passcode.emptyInputPasscode ? authenticateRequest.send() : passcode.removeElement.send() }
            .store(in: &cancelBag)
        
        numbers.numberButtonClicked
            .subscribe(passcode.newElement)
            .store(in: &cancelBag)

        passcode.passcode
            .subscribe(passcodeRequest)
            .store(in: &cancelBag)

        logoutRequest
            .flatMap { [unowned self] in self.store.logout() }
            .map { _ in EnterPincodeState.finish }
            .receive(on: DispatchQueue.main)
            .subscribe(stateSender)
            .store(in: &cancelBag)

        passcodeRequest
            .map { _ in EnterPincodeState.request(status: true) }
            .subscribe(stateSender)
            .store(in: &cancelBag)
        
        passcodeRequest
            .delay(for: 3, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.passcode.reset.send() })
            .map { _ in .request(status: false) }
            .subscribe(stateSender)
            .store(in: &cancelBag)
    }
}
