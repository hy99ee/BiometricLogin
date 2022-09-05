import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: SenderStateType = .start

    @Published var prepasscode = Passcode()
    @Published var passcode = Passcode()
    @Published var numbers = PasscodeNumbersViewModel()

    let stateSender: PassthroughSubject<CreatePincodeState, Never> = .init()

    private let store: AuthenticateStore

    var cancelBag: CancelBag = []

    init(store: AuthenticateStore) {
        self.store = store

        setupBindings()
    }
    
    private func setupBindings() {        
        stateSender.assign(to: &$state)

        self.objectWillChange.sink { [unowned self] in self.numbers.objectWillChange.send() }.store(in: &cancelBag)
        prepasscode.objectWillChange.sink { [unowned self] in self.objectWillChange.send() }.store(in: &cancelBag)
        passcode.objectWillChange.sink { [unowned self] in self.objectWillChange.send() }.store(in: &cancelBag)

        numbers.rightButtonClicked
            .sink {[unowned self] in prepasscode.isFull && !passcode.emptyInputPasscode
                ? passcode.removeElement.send()
                : prepasscode.removeElement.send()
            }
            .store(in: &cancelBag)
        
        numbers.rightButtonClicked
            .filter { [unowned self] in prepasscode.isFull && passcode.emptyInputPasscode }
            .map { _ in .start }
            .subscribe(stateSender)
            .store(in: &cancelBag)

//        numbers.rightButtonClicked
//
//            .filter {[unowned self] in $0.count == 1 && prepasscode.isFull && !prepasscode.emptyInputPasscode }
//            .map { _ in .start }
//            .subscribe(stateSender)
//            .store(in: &cancelBag)

        numbers.numberButtonClicked
            .sink {[unowned self] in prepasscode.isFull
                ? passcode.newElement.send($0)
                : prepasscode.newElement.send($0)
            }
            .store(in: &cancelBag)

        prepasscode.passcode
            .filter{ !$0.isEmpty }
            .delay(for: .milliseconds(250), scheduler: RunLoop.main)
            .map { _ in CreatePincodeState.approve }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        passcode.passcode
            .combineLatest(prepasscode.passcode)
            .print("---")
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { $0.0 == $0.1 ? CreatePincodeState.request(status: true) : CreatePincodeState.failure }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        passcode.passcode
            .filter{ !$0.isEmpty }
            .delay(for: 3, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.passcode.reset.send()
                self?.prepasscode.reset.send()
            })
            .map { _ in .start }
            .subscribe(stateSender)
            .store(in: &cancelBag)

//        passcode.passcode
//            .print("+++")
//            .filter {[unowned self] in $0.isEmpty && prepasscode.isFull && !prepasscode.emptyInputPasscode }
//            .map { _ in .start }
//            .subscribe(stateSender)
//            .store(in: &cancelBag)
    }
}
