import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
  mutating func cancel() {
    forEach { $0.cancel() }
    removeAll()
  }
}
