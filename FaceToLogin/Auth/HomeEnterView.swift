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
        switch viewModel.stage {
        case PincodeStage.start:
            EnterPincodeView().environmentObject(viewModel.pincodeViewModel)
        case PasswordStage.start:
            EnterPasswordView().environmentObject(viewModel.passwordViewModel)
        default: ProgressView()
        }
    }
}

