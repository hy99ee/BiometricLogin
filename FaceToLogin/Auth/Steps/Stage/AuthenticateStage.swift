import Foundation

protocol Stage {
    var value: Int { get }
}

extension Stage {
    static func == (lhs: Stage, rhs: Stage) -> Bool {
       lhs.value == rhs.value
    }
}


enum PincodeStage: Int, Stage {
    case start
    case finish
    case logout
    
    var value: Int {
        self.rawValue
    }
}

enum PasswordStage: Int, Stage {
    case start
    case finish
    
    var value: Int {
        self.rawValue
    }
}
