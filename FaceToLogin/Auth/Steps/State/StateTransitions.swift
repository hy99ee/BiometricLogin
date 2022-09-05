import Foundation
import Combine

protocol StateType {}

protocol StateSender: ObservableObject {
    associatedtype SenderStateType: StateType
    var stateSender: PassthroughSubject<SenderStateType, Never> { get }
    var stateSubscription: AnyCancellable? { get set }

    func bindState<T: StateReciever>(to reciever: T) -> Self
}

extension StateSender {
    func bindState<T: StateReciever>(to reciever: T) -> Self {
        stateSubscription = stateSender
            .mapState(mapper: reciever.stateMapper)
            .receive(on: DispatchQueue.main)
            .subscribe(reciever.stateReceiver)

        return self
    }
}

protocol StateReciever: ObservableObject, WithStateMapper {
    var stateReceiver: PassthroughSubject<StateType, Never> { get }
    var stateSubscription: AnyCancellable? { get set }
}

extension StateReciever {
    func bindState<T: StateSender>(to sender: T) -> Self {
        stateSubscription = sender.stateSender
            .mapState(mapper: stateMapper)
            .receive(on: DispatchQueue.main)
            .subscribe(stateReceiver)

        return self
    }
}
