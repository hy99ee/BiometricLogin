import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel
    @State var isAnimating = false
    @State var isDisabled = false
    @State var approvePincode = false
    @State var isFailure = false
    
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
            .foregroundColor(isFailure ? failureColor : primaryColor)
            .padding()

            PincodeNumbersView().environmentObject(viewModel.numbers.withButtons(left: AnyView(leftButtonView), right: AnyView(rightButtonView)))
                .opacity(isAnimating ? 0.5 : 1)
        }
        .disabled(isDisabled)
        .onReceive(viewModel.$state) { value in
            withAnimation(approvePincode ? Animation.default : .easeInOut(duration: 0.5)) {
                isDisabled = true
                approvePincode = {
                    switch value {
                    case .approve, .failure: return true
                    default: return false
                    }
                }()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                    isDisabled = false
                }
            }
            withAnimation(isFailure ? Animation.default : .easeInOut(duration: 0.5)) {
                isFailure = {
                    if case .failure = value { return true } else { return false }
                }()
            }
            withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                isAnimating = {
                    if case .request = value { return true } else { return false }
                }()
//                isDisabled = {
//                    if isAnimating { return true }
//                }()
                if isAnimating { isDisabled = true }
            }
        }
    }
}


struct CreatePincodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePincodeView().environmentObject(CreatePincodeViewModel(store: AuthenticateStore()))
    }
}
