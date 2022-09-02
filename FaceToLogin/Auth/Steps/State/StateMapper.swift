import Foundation
import Combine

protocol WithStateMapper {
    var stateMapper: StateMapper? { get }
}

protocol StateMapper {
    func mapState(_ state: StateType) -> StateType?
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> AnyPublisher<StateType, Failure> {
        self
            .map { guard let mapper = mapper else { return $0 }; return mapper.mapState($0) }
//            .scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .withPrevious()
            .compactMap { $0.0 }
//            .eraseToAnyPublisher()
            
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
        scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func bindState<T>(to sender: T, initState: T.SenderStateType? = nil) -> AnyCancellable where T: StateSender, T: AnyObject, Output == T.SenderStateType {
        self
//            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
//            .scan(Optional<(Output?, Output)>.none) { (initState, $1) }
//            .print("scan")
//            .compactMap { $0?.0 }
//            .print("compactMap")
//            .withPrevious(initState)
//            .compactMap { $0?.0 }
//            .receive(on: DispatchQueue.main)
//            .print("===")
            .sink{[weak sender] in sender?.stateSubject.send($0) }
    }
}

