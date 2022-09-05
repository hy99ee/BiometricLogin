import SwiftUI
import Combine

struct EnterPincodeView: View {
    @EnvironmentObject var viewModel: EnterPincodeViewModel
    @State var isAnimating = false

    @ViewBuilder
    private var rightButtonView: some View {
        if viewModel.passcode.emptyInputPasscode, viewModel.biomitricTypeImage == nil { EmptyView() }
        else {
            Image(systemName: viewModel.passcode.emptyInputPasscode ?
                  viewModel.biomitricTypeImage ?? "" :
                    "chevron.backward").font(.system(size: 30))
        }
    }

    @ViewBuilder
    private var leftButtonView: some View {
        Image(systemName: "house").font(.system(size: 25))
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "gear")
                    .font(.system(size: 50))
                Text("Username")
                    .padding(3)
                    .font(.system(size: 20))
                    .foregroundColor(.init(white: 0.35))
                    .textCase(.uppercase)

                PasscodeFieldView().environmentObject(viewModel.passcode)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .foregroundColor(primaryColor)
                
                Spacer()
            }
            .padding()

            PincodeNumbersView().environmentObject(viewModel.numbers.withButtons(left: AnyView(leftButtonView), right: AnyView(rightButtonView)))
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
