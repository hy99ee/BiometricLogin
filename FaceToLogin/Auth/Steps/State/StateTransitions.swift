import Foundation
import Combine

protocol StateSender {
    associatedtype StateType: State
    var stateSubject: PassthroughSubject<StateType, Never> { get }

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
    var statePublished: Published<State> { get }
    var statePublisher: Published<State>.Publisher { get set }
}

