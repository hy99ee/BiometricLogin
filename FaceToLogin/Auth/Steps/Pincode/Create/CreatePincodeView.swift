import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel
    @State var isAnimating = false
    @State var approvePincode = false
    
    @ViewBuilder
    private var rightButtonView: some View {
        EmptyView()
    }

    private var rightButton: PincodeNumbersActionButton {(
        view: AnyView(rightButtonView),
        action: { }
    )}

    @ViewBuilder
    private var leftButtonView: some View {
        EmptyView()
    }

    private var leftButton: PincodeNumbersActionButton {(
        view: AnyView(leftButtonView),
        action: {  }
    )}

    private var pincodeNumbersConfiguration: PincodeActionButtonsConfiguration {
        .init(rightButton: rightButton, leftButton: leftButton)
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()

                Text("Enter new pincode")
                    .padding(3)
                    .font(.system(size: 20))
                    .foregroundColor(.init(white: 0.35))
                    .textCase(.uppercase)

                InputPincodeView(password: $viewModel.prepincode, placeholder: "")
                    .font(.system(size: 33))
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .foregroundColor(primaryColor)

                if approvePincode {
                    InputPincodeView(password: $viewModel.pincode, placeholder: "")
                        .font(.system(size: 33))
                        .scaleEffect(isAnimating ? 1.1 : 1)
                        .opacity(isAnimating ? 0.5 : 1)
                        .foregroundColor(primaryColor)
                }
                Spacer()
            }
            .padding()
            PincodeNumbersView(with: pincodeNumbersConfiguration, receiver: viewModel.numberClick).padding()
        }
//        .disabled(isAnimating)
        .onReceive(viewModel.$state) { value in
            withAnimation(approvePincode ? Animation.default : .easeInOut(duration: 0.5)) {
                approvePincode = {
                    if case .approve = value { return true } else { return false }
                }()
            }
            withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                isAnimating = {
                    if case .loading = value { return true } else { return false }
                }()
            }
        }
    }
}


struct CreatePincodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePincodeView().environmentObject(CreatePincodeViewModel(store: AuthenticateStore()))
    }
}
