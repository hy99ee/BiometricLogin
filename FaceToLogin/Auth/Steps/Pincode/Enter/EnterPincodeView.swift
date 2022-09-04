import SwiftUI
import Combine

struct EnterPincodeView: View {
    @EnvironmentObject var viewModel: EnterPincodeViewModel
    @State var isAnimating = false
    
    let placeholder = ""

    @ViewBuilder
    private var rightButtonView: some View {
        if viewModel.pincode.isEmpty, viewModel.biomitricTypeImage == nil { EmptyView() }
        else {
            Image(systemName: viewModel.pincode.isEmpty ? viewModel.biomitricTypeImage! : "chevron.backward")
                .font(.system(size: 30))
        }
    }

    private var rightButton: PincodeNumbersActionButton {(
        view: AnyView(rightButtonView),
        action: { viewModel.pincode.isEmpty ? viewModel.authenticateRequest.send() : viewModel.removeClick.send() }
    )}

    @ViewBuilder
    private var leftButtonView: some View {
        Image(systemName: "house").font(.system(size: 25))
    }
    private var leftButton: PincodeNumbersActionButton {(
        view: AnyView(leftButtonView),
        action: { viewModel.logoutRequest.send() }
    )}

    private var pincodeNumbersConfiguration: PincodeActionButtonsConfiguration {
        PincodeActionButtonsConfiguration.init(rightButton: rightButton, leftButton: leftButton)
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "gear")
                    .font(.system(size: 50))
                Text(viewModel.store.username)
                    .padding(3)
                    .font(.system(size: 20))
                    .foregroundColor(.init(white: 0.35))
                    .textCase(.uppercase)

                InputPincodeView(password: $viewModel.pincode, placeholder: "")
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .foregroundColor(primaryColor)
//                    .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 100, maxHeight: 100, alignment: .center)
                
                Spacer()
            }
            .padding()
            
            PincodeNumbersView(with: pincodeNumbersConfiguration, receiver: viewModel.numberClick)
                .opacity(isAnimating ? 0.5 : 1)
            
            .onReceive(viewModel.$state) { value in
                withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                    isAnimating = {
                        if case let EnterPincodeState.request(status) = value {
                            return status ? true : false
                        } else {
                            return false
                        }
                    }()
                }
            }
            .disabled(isAnimating)
            .padding()
        }
    }
}

//struct EnterPincodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnterPincodeView().environmentObject(EnterPincodeViewModel(store: AuthenticateStore()))
//    }
//}
