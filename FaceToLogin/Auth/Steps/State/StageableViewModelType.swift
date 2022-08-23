import Foundation
import Combine

//protocol StateSender {
//    associatedtype StateType: State, Equatable
//    var state: PassthroughSubject<StateType, Never> { get }
//    
//    func bindState<T: StateReciever>(to reciever: T) -> Self where T.StateType == Self.StateType
//    
//}
//
//extension StateSender {
//    func bindingState<T: StateReciever>(to reciever: T) -> Self where T.StateType == Self.StateType {
//        state
////            .mapState(mapper: reciever.stateMapper)
//            .receive(on: DispatchQueue.main)
//            
//            .assign(to: &reciever.state)
//            
//        return self
//    }
//}
//
//protocol StateReciever: ObservableObject, WithStateMapper {
//    associatedtype StateType: State, Equatable
//    var state: PassthroughSubject<StateType, Never> { get set }
//}
//

//    func start(with state: StateType) -> Self {
//        if self.state != state { self.state = state }
//        return self
//    }

