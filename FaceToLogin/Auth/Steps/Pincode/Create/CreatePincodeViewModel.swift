import Foundation
import Combine

final class CreatePincodeViewModel: StateSender, ObservableObject {
    typealias SenderStateType = CreatePincodeState

    @Published var state: SenderStateType = .start
    @Published var store: AuthenticateStore = AuthenticateStore()
    
    @Published var pinsVisible: String = ""

    let stateSubject: PassthroughSubject<SenderStateType, Never> = .init()

    let pincodeRequest: PassthroughSubject<String, Never> = .init()

    let numberClick: PassthroughSubject<Int, Never> = .init()
    
    private let maxCount = 4
    private var currentCount = 0
    private var currentPincode = ""

    private var anyCancellables: Set<AnyCancellable> = []

    init() {
        $state
            .bindState(to: self)
            .store(in: &anyCancellables)
        
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
}
