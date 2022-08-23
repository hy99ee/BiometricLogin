import Foundation
import Combine

protocol WithStateMapper {
    var stateMapper: StateMapper { get }
}

protocol StateMapper {
    func mapState(_ state: State) -> State?
}

extension Publisher where Output: State, Failure == Never {
    func mapState(mapper: StateMapper) -> Publishers.CompactMap<Publishers.Map<Self, State?>, State> {
        self.map { mapper.mapState($0) }.compactMap { $0 }
    }
}

