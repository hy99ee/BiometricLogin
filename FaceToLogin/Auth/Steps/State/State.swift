import Foundation

protocol StateType {
    var externalValue: Self? { get }
}

final class AnyState: StateType {
    var externalValue: AnyState? = nil
}
