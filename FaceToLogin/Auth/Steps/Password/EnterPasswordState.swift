import Foundation

enum PasswordState: Int, StateType {
    case start
    case finish
    
    var externalValue: Self? {
        self
    }
}
