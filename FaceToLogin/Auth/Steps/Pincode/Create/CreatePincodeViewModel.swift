import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore

    @Published var prepincode: String = ""
    @Published var pincode: String = ""

    let stateSender: PassthroughSubject<CreatePincodeState, Never> = .init()

    let prepincodeRequest: PassthroughSubject<String, Never> = .init()
    let pincodeRequest: PassthroughSubject<String, Never> = .init()

    let removeClick: PassthroughSubject<Void, Never> = .init()
    let numberClick: PassthroughSubject<Int, Never> = .init()
    
    private let maxCount = 4
    private var currentCount = 0

    var cancelBag: CancelBag = []

    init(store: AuthenticateStore) {
        self.store = store

        setupBindings()
    }
    
    private func setupBindings() {
        
        stateSender.assign(to: &$state)

        numberClick
            .sink { [unowned self] number in
                switch self.state {
                case .start:
                    prepincode += String(number)
                    if prepincode.count == maxCount {
                        self.prepincodeRequest.send(pincode)
                    }
                case .approve:
                    pincode += String(number)
                    if pincode.count == maxCount {
                        self.pincodeRequest.send(pincode)
                    }
                default: break
                }
            }
            .store(in: &cancelBag)
        
        prepincodeRequest
            .map { _ in CreatePincodeState.approve }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        pincodeRequest
            .map { _ in CreatePincodeState.loading }
            .subscribe(stateSender)
            .store(in: &cancelBag)

        pincodeRequest
            .delay(for: 3, scheduler: DispatchQueue.main)
            .map { [unowned self] _ in
                let isApprove = prepincode == pincode
                self.prepincode = ""
                self.pincode = ""
                return .request(status: isApprove)
            }
            .subscribe(stateSender)
            .store(in: &cancelBag)
    }
}
