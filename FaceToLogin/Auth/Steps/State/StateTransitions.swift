import Foundation
import Combine
import SwiftUI

protocol StateType {}

protocol WithCancelBag: AnyObject {
    var cancelBag: CancelBag { get set }
}

protocol StateSender: WithStateFilter, WithCancelBag {
    associatedtype SenderStateType: StateType
    var stateSender: PassthroughSubject<SenderStateType, Never> { get }
}

extension StateSender {
    @discardableResult
    func bindState<Receiver: StateReciever>(receiver: Receiver) -> Self {
        stateSender
            .filterState(filter: stateFilter)
            .mapState(mapper: receiver.stateMapper)
            .subscribe(receiver.stateReceiver)
            .store(in: &cancelBag)

        return self
    }
}

protocol StateReciever: WithStateMapper, WithCancelBag {
    var stateReceiver: PassthroughSubject<StateType, Never> { get }
}

extension StateReciever {
    @discardableResult
    func bindState<T: StateSender>(sender: T) -> Self {
        stateReceiver
            .compactMap { $0 as? T.SenderStateType }
            .mapState(mapper: stateMapper)
            .compactMap { $0 as? T.SenderStateType }
            .subscribe(sender.stateSender)
            .store(in: &cancelBag)

        return self
    }
}

protocol StateTransitor: StateSender, StateReciever {}

extension StateTransitor {
    @discardableResult
    func bindState<Sender: StateSender, Receiver: StateReciever>(
        sender: Sender,
        receiver: Receiver,
        viewState: inout Published<StateType>.Publisher
    ) -> Self {
        let stateTransition: PassthroughSubject<SenderStateType, Never> = .init()

        stateReceiver
            .compactMap { $0 as? SenderStateType }
            .mapState(mapper: stateMapper)
            .compactMap { $0 as? SenderStateType }
            .subscribe(stateTransition)
            .store(in: &cancelBag)

        stateTransition
            .filterState(filter: stateFilter)
            .subscribe(stateSender)
            .store(in: &cancelBag)

        stateTransition
            .map { $0 }
            .assign(to: &viewState)

        return self
    }
}
