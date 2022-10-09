import Foundation
import Combine

// Map received states
protocol StateMapper {
    func mapState(_ state: StateType) -> StateType?
}
protocol WithStateMapper {
    var stateMapper: StateMapper? { get }
}

// Filter for internal states
typealias StateFilter = (_ state: StateType) -> Bool
protocol WithStateFilter {
    var stateFilter: StateFilter { get }
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> AnyPublisher<StateType, Never> {
        self
            .map { mapper?.mapState($0) ?? $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func filterState(filter: @escaping StateFilter) -> AnyPublisher<Self.Output, Never> {
        self
            .filter { filter($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

