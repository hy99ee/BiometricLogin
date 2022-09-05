import Combine
import SwiftUI

extension CurrentValueSubject {
  var binding: Binding<Output> {
    Binding(get: {
      self.value
    }, set: {
      self.send($0)
    })
  }
}
