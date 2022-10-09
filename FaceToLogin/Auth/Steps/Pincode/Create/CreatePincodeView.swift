import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel
    @State private var isAnimating = false
    @State private var approvePincode = false
    @State private var isFailure = false
    
    @ViewBuilder
    private var rightButtonView: some View {
        if !viewModel.prepasscode.emptyInputPasscode { Image(systemName: "chevron.backward") }
        else { EmptyView() }
    }

    @ViewBuilder
    private var leftButtonView: some View {
        EmptyView()
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()
                PasscodeFieldView().environmentObject(viewModel.prepasscode)
                if approvePincode { PasscodeFieldView().environmentObject(viewModel.passcode) }
                Spacer()
            }
            .scaleEffect(isAnimating ? 1.1 : 1)
            .opacity(isAnimating ? 0.5 : 1)
            .foregroundColor(isFailure ? .red : primaryColor)
            .padding()

            PincodeNumbersView().environmentObject(viewModel.numbers.withButtons(left: AnyView(leftButtonView), right: AnyView(rightButtonView)))
                .opacity(isAnimating ? 0.5 : 1)
        }
        .disabled(isAnimating)
        .onReceive(viewModel.$state) { value in
            withAnimation(approvePincode ? Animation.default : .easeInOut(duration: 0.5)) {
                approvePincode = {
                    switch value {
                    case .approve, .failure: return true
                    default: return false
                    }
                }()
            }
            withAnimation(isFailure ? Animation.default : .easeInOut(duration: 0.5)) {
                isFailure = {
                    if case .failure = value { return true } else { return false }
                }()
            }
            withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                isAnimating = {
                    if case let .request(status) = value { return status } else { return false }
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
