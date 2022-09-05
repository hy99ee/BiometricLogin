import SwiftUI
import Combine

enum PincodeActionButtonType: String {
    case left
    case right
}

struct PincodeNumbersView: View {
    private static let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [PincodeActionButtonType.left.rawValue, "0", PincodeActionButtonType.right.rawValue]
    ]

    @EnvironmentObject var passcodeNumbersViewModel: PasscodeNumbersViewModel
    
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
            action: actionByButtonName(button),
            label: { viewByButtonName(button) }
        )

    }

    private func actionByButtonName(_ button: String) -> (() -> Void) {
        switch button {
        case PincodeActionButtonType.left.rawValue: return passcodeNumbersViewModel.left.action
        case PincodeActionButtonType.right.rawValue: return passcodeNumbersViewModel.right.action
        default:
            guard let number = Int(button) else { fatalError("Unvalid numbers") }
            return passcodeNumbersViewModel.number(number).action
        }
    }

    private func viewByButtonName(_ button: String) -> AnyView? {
        switch button {
        case PincodeActionButtonType.left.rawValue: return passcodeNumbersViewModel.left.view
        case PincodeActionButtonType.right.rawValue: return passcodeNumbersViewModel.right.view
        default:
            guard let number = Int(button) else { fatalError("Unvalid numbers") }
            return passcodeNumbersViewModel.number(number).view
            
        }
    }
}
