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
protocol StateFilter {
    typealias FilterHandler = (_ state: StateType) -> Bool
    var filter: FilterHandler { get }
}
class BaseStateFilter: StateFilter {
    init(filter: @escaping FilterHandler) { self.filter = filter }
    let filter: FilterHandler
}
protocol WithStateFilter {
    var stateFilter: StateFilter? { get }
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> AnyPublisher<StateType, Never> {
        self
            .map { mapper?.mapState($0) ?? $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func filterState(stateFilter: StateFilter?) -> AnyPublisher<Self.Output, Never> {
        self
            .filter { stateFilter?.filter($0) ?? true }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

