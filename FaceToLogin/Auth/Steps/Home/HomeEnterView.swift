import SwiftUI
import Combine

struct HomeEnterView: View {
    @EnvironmentObject var viewModel: HomeEnterViewModel
    private var enterCancellable: AnyCancellable?

    var body: some View {
        loginTypeView()
    }
    
    @ViewBuilder
    private func loginTypeView() -> some View {
        switch viewModel.state {
        case PincodeState.start:
            PincodeView().environmentObject(PincodeViewModel(store: viewModel.store).bindState(receiver: viewModel))
        case PasswordState.start:
            EnterPasswordView().environmentObject(EnterPasswordViewModel(store: viewModel.store).bindState(receiver: viewModel))
        default: ProgressView().background(.red)
        }
    }
}

