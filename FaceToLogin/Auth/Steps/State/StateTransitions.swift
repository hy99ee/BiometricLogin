import Foundation
import Combine

protocol StateSender {
    associatedtype StateTypeSender: StateType
    var stateSubject: PassthroughSubject<StateTypeSender, Never> { get }

    func bindState<T: StateReciever>(to reciever: T) -> Self
}

extension StateSender {
    func bindState<T: StateReciever>(to reciever: T) -> Self {
        stateSubject
            .receive(on: DispatchQueue.main)
            .mapState(mapper: reciever.stateMapper)
            .assign(to: &reciever.statePublisher)

        return self
    }
}

protocol StateReciever: ObservableObject, WithStateMapper {
    var statePublished: Published<StateType> { get }
    var statePublisher: Published<StateType>.Publisher { get set }
}

