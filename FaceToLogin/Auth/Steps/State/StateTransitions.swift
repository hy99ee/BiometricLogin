import Foundation
import Combine

protocol StateType {}

protocol WithCancelBag: AnyObject {
    var cancelBag: CancelBag { get set }
}

protocol StateSender: WithCancelBag {
    associatedtype SenderStateType: StateType
    var stateSender: PassthroughSubject<SenderStateType, Never> { get }

    func bindState<T: StateReciever>(to reciever: T) -> Self
}

extension StateSender {
    @discardableResult
    func bindState<T: StateReciever>(to reciever: T) -> Self {
        stateSender
            .mapState(mapper: reciever.stateMapper)
            .subscribe(reciever.stateReceiver)
            .store(in: &cancelBag)

        return self
    }
}

protocol StateReciever: WithStateMapper, WithCancelBag {
    var stateReceiver: PassthroughSubject<StateType, Never> { get }
}

extension StateReciever {
    @discardableResult
    func bindState<T: StateSender>(on sender: T) -> Self {
        stateReceiver
            .compactMap { $0 as? T.SenderStateType }
            .mapState(mapper: stateMapper)
            .compactMap { $0 as? T.SenderStateType }
            .subscribe(sender.stateSender)
            .store(in: &cancelBag)

        return self
    }
}
