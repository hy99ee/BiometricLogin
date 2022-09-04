import Foundation
import Combine

protocol WithStateMapper {
    var stateMapper: StateMapper? { get }
}

protocol StateMapper {
    func mapState(_ state: StateType) -> StateType?
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> Publishers.ReceiveOn<Publishers.CompactMap<Self, StateType>, DispatchQueue> {
        self
            .compactMap {
                guard let mapper = mapper else { return $0 }
                return mapper.mapState($0)
            }
//            .withPrevious()
//            .scan(Optional<(StateType?, StateType)>.none) { ($0?.1, $1) }
//            .compactMap{ $0?.0 }
            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
    }

    func withPrevious() -> AnyPublisher<(previous: StateType?, current: StateType), Never> {
        scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func bindState<T>(to sender: T, initState: T.SenderStateType? = nil) -> AnyCancellable where T: StateSender, T: AnyObject, Output == T.SenderStateType {
        self.sink{[weak sender] in sender?.stateSubject.send($0) }
    }
}

