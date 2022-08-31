import Foundation
import Combine

protocol WithStateMapper {
    var stateMapper: StateMapper? { get }
}

protocol StateMapper {
    func mapState(_ state: StateType) -> StateType?
}

extension Publisher where Output: StateType, Failure == Never {
    func mapState(mapper: StateMapper?) -> Publishers.CompactMap<Publishers.Map<Self, StateType?>, StateType> {
        self.map { guard let mapper = mapper else { return $0 }; return mapper.mapState($0) }.compactMap { $0 }
    }
}
