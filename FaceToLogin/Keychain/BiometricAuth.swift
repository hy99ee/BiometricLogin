import Combine
import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

protocol BiometricIDAuthType {
    var context: LAContext { get }
    var loginReason: String { get }
    var biometricType: BiometricType { get }

    func authenticateUser() -> AnyPublisher<Bool, Never>
    func checkLogin(username: String, password: String) -> AnyPublisher<Bool, Never>
}

class BiometricIDAuth: BiometricIDAuthType {
  let context = LAContext()
  let loginReason = "Logging in with Touch ID"

    var biometricType: BiometricType {
      guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else { return .none }
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
    
    private func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser() -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.loginReason) { (success, evaluateError) in
                promise(.success(success ? true : false))
            }
        }.eraseToAnyPublisher()
    }
    
    func checkLogin(username: String, password: String) -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            guard username == UserDefaults.standard.value(forKey: username) as? String else {
                return promise(.success(false))
            }
            
            do {
                let passwordItem = KeychainPincodeItem(service: KeychainConfiguration.serviceName,
                                                        account: username,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                let keychainPassword = try passwordItem.readPassword()
                return promise(.success(password == keychainPassword))
            }
            catch {
                return promise(.success(false))
            }
        }.eraseToAnyPublisher()
    }
}
