import Combine
import SwiftUI

//protocol PasscodeNumbersViewModelType: ObservableObject {
//    var leftButtonClicked: PassthroughSubject<Void, Never> { get }
//    var rightButtonClicked: PassthroughSubject<Void, Never> { get }
//    var numberClicked: PassthroughSubject<Int, Never> { get }
//}

typealias PasscodeNumbersActionButton = (view: AnyView?, action: () -> Void)
class PasscodeNumbersViewModel: ObservableObject {

    private let leftButtonClick: PassthroughSubject<Void, Never> = .init()
    var leftButtonClicked: AnyPublisher<Void, Never> { leftButtonClick.eraseToAnyPublisher() }
    
    private let rightButtonClick: PassthroughSubject<Void, Never> = .init()
    var rightButtonClicked: AnyPublisher<Void, Never> { rightButtonClick.eraseToAnyPublisher() }

    private let numberClick: PassthroughSubject<Int, Never> = .init()
    var numberButtonClicked: AnyPublisher<Int, Never> { numberClick.eraseToAnyPublisher() }

    private var leftButtonView: AnyView?
    private var rightButtonView: AnyView?
    private var numberButtonViewType: Text.Type?
    
//    init(left leftButtonView: AnyView, right rightButtonView: AnyView, number numberButtonView: Text) {
//        self.leftButtonView = leftButtonView
//        self.rightButtonView = rightButtonView
//        self.numberButtonView = numberButtonView
//    }
    
    func withButtons(left leftButtonView: AnyView, right rightButtonView: AnyView, number numberButtonViewType: Text.Type = Text.self) -> Self {
        self.leftButtonView = leftButtonView
        self.rightButtonView = rightButtonView
        self.numberButtonViewType = numberButtonViewType

        return self
    }
    
    var left: PasscodeNumbersActionButton {
        PasscodeNumbersActionButton(view: leftButtonView, action: { self.leftButtonClick.send() })
    }

    var right: PasscodeNumbersActionButton {
        PasscodeNumbersActionButton(view: rightButtonView, action: { self.rightButtonClick.send() })
    }
    
    func number(_ number: Int) -> PasscodeNumbersActionButton {
        PasscodeNumbersActionButton(view: AnyView((numberButtonViewType ?? Text.self).init(String(number)).font(.system(size: 40))), action: { self.numberClick.send(number) })
    }
}
