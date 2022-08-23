import Foundation

protocol State {
    var value: Int { get }
}

extension State {
    static func == (lhs: State, rhs: State) -> Bool {
       lhs.value == rhs.value
    }
}


enum PincodeState: Int, State {
    case start
    case finish
    case logout
    
    var value: Int {
        self.rawValue
    }
}

enum PasswordState: Int, State {
    case start
    case finish
    
    var value: Int {
        self.rawValue
    }
}
