import Foundation
import Combine

protocol WithStateMapper {
    var stateMapper: StateMapper? { get }
}

protocol StateMapper {
    func mapState(_ state: StateType) -> StateType?
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> AnyPublisher<StateType, Never> {
        self
            .map { mapper?.mapState($0) ?? $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

