import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore

    @Published var prepincode: String = ""
    @Published var pincode: String = ""

    let stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    let prepincodeRequest: PassthroughSubject<String, Never> = .init()
    let pincodeRequest: PassthroughSubject<String, Never> = .init()

    let removeClick: PassthroughSubject<Void, Never> = .init()
    let numberClick: PassthroughSubject<Int, Never> = .init()
    
    private let maxCount = 4
    private var currentCount = 0

    private var anyCancellables: Set<AnyCancellable> = []

    init(store: AuthenticateStore) {
        self.store = store

        $state
            .print("===")
//            .subscribe(stateSubject)
//            .subscribe(stateSubject)
//            .receive(on: DispatchQueue.main)
            .bindState(to: self)
            .store(in: &anyCancellables)

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
            .store(in: &anyCancellables)
        
        prepincodeRequest
            .map { _ in CreatePincodeState.approve }
            .assign(to: &$state)

        pincodeRequest
            .map { _ in CreatePincodeState.loading }
            .assign(to: &$state)

        pincodeRequest
            .delay(for: 3, scheduler: DispatchQueue.main)
            .map { [unowned self] _ in
                let isApprove = prepincode == pincode
                self.prepincode = ""
                self.pincode = ""
                return .request(status: isApprove)
            }
            .assign(to: &$state)
    }
}
