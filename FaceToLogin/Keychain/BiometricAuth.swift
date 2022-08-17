import Combine
import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

class BiometricIDAuth {
  let context = LAContext()
  var loginReason = "Logging in with Touch ID"

  func biometricType() -> BiometricType {
    let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    switch context.biometryType {
    case .none:
      return .none
    case .touchID:
        return .touchID
    case .faceID:
        return .faceID
    default: return .none
    }
  }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
//
//    func authenticateUser() -> AnyPublisher<Bool, Error> {
//        return Future<Bool, Error> { resolve in
//            // start the request when someone subscribes
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
//                // publish result on success
//                resolve(.success(success))
//            }, error: { error in
//                // publish error on failure
//                resolve(.failure(error))
//            })
//            // allow cancellation ???
//        }
//        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
//
//        }
//    }
    
    func authenticateUser() -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.loginReason) { (success, evaluateError) in
                promise(.success(success ? true : false))
            }
        }.eraseToAnyPublisher()
    }
    
    func checkLogin(username: String, password: String) -> Bool {
      guard username == UserDefaults.standard.value(forKey: username) as? String else {
        return false
      }
      
      do {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: username,
                                                accessGroup: KeychainConfiguration.accessGroup)
        let keychainPassword = try passwordItem.readPassword()
        return password == keychainPassword
      }
      catch {
          return false
//        fatalError("Error reading password from keychain - \(error)")
      }
    }
}
