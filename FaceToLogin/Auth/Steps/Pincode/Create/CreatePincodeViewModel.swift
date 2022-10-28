import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: SenderStateType = .start

    @Published var prepasscode = Passcode()
    @Published var passcode = Passcode()
    @Published var numbers = PasscodeNumbersViewModel()

    let stateSender: PassthroughSubject<SenderStateType, Never> = .init()

    var stateFilter: StateFilter? = BaseStateFilter(filter: {
        switch $0 {
        case CreatePincodeState.finish: return true
        case let CreatePincodeState.request(status): return status ? false : true
        default: return false
        }
    })

    private let store: AuthenticateStore

    var cancelBag: CancelBag = []

    init(store: AuthenticateStore) {
        self.store = store

        setupBindings()
    }
    
    private func setupBindings() {        
        stateSender.print("===>").assign(to: &$state)

        self.objectWillChange.sink { [unowned self] in self.numbers.objectWillChange.send() }.store(in: &cancelBag)
        prepasscode.objectWillChange.sink { [unowned self] in self.objectWillChange.send() }.store(in: &cancelBag)
        passcode.objectWillChange.sink { [unowned self] in self.objectWillChange.send() }.store(in: &cancelBag)

        numbers.rightButtonClicked
            .sink {[unowned self] in
                prepasscode.isFull && !passcode.emptyInputPasscode
                    ? passcode.removeElement.send()
                    : prepasscode.removeElement.send()
            }
            .store(in: &cancelBag)

        numbers.numberButtonClicked
            .handleEvents(receiveOutput: {[unowned self] in
                prepasscode.isFull
                ? passcode.newElement.send($0)
                : prepasscode.newElement.send($0)
            })
            .filter { [unowned self] _ in prepasscode.isFull && passcode.emptyInputPasscode }
            .map { _ in CreatePincodeState.approve }
            .subscribe(stateSender)
            .store(in: &cancelBag)
        
        prepasscode.removeElement
            .filter { [unowned self] _ in passcode.emptyInputPasscode }
            .map { _ in .start }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        passcode.passcode
            .combineLatest(prepasscode.passcode)
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { $0.0 == $0.1 ? .request(status: true) : .failure }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        passcode.passcode
            .combineLatest(prepasscode.passcode)
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .delay(for: 3, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.passcode.reset.send()
                self?.prepasscode.reset.send()
            })
            .map { $0.0 == $0.1 ? .request(status: false) : .start }
            .subscribe(stateSender)
            .store(in: &cancelBag)
    }
}
