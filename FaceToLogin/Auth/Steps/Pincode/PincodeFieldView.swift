import SwiftUI
import Combine

enum PincodeActionButtonType: String {
    case left
    case right
}

typealias PincodeFieldActionButton = (view: AnyView?, action: () -> Void)
struct PincodeActionButtonsConfiguration {
    let rightButton: PincodeFieldActionButton
    let leftButton: PincodeFieldActionButton
    
    func valueByButtonTitle(_ button: String) -> PincodeFieldActionButton? {
        switch button {
        case PincodeActionButtonType.left.rawValue: return leftButton
        case PincodeActionButtonType.right.rawValue: return rightButton
        default: return nil
        }
    }
}

struct PincodeFieldView: View {
    private static let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [PincodeActionButtonType.left.rawValue, "0", PincodeActionButtonType.right.rawValue]
    ]
    
    private var configuration: PincodeActionButtonsConfiguration
    private var numberClick: PassthroughSubject<Int, Never>
    
    init(with configuration: PincodeActionButtonsConfiguration, receiver numberClick: PassthroughSubject<Int, Never>) {
        self.configuration = configuration
        self.numberClick = numberClick
    }
    
    var body: some View {
        VStack {
            ForEach(Self.rows, id: \.self) { row in
                HStack(alignment: .top, spacing: 0) {
                    Spacer(minLength: 13)
                    ForEach(row, id: \.self) { column in
                        createButton(column)
                            .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(primaryColor)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func createButton(_ button: String) -> some View {
        Button(
            action:
                configuration.valueByButtonTitle(button)?.action ?? {
                    guard let number = Int(button) else { return }
                    self.numberClick.send(number)
            },
            label: {
                configuration.valueByButtonTitle(button)?.view ?? AnyView(Text(button).font(.system(size: 40)))
            }
        )
        
    }
}

//struct PincodeFieldView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let viewModel = EnterPincodeViewModel(store: AuthenticateStore())
//        let view: EnterPincodeView = EnterPincodeView().environmentObject(viewModel) as! EnterPincodeView
//
//        return PincodeFieldView(isAnimation: view.$isAnimating, rows: viewModel.rows, createButton: view.createButton)
//    }
//}
