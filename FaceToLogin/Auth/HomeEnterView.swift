import SwiftUI
import Combine

struct HomeEnterView: View {
    @EnvironmentObject var viewModel: HomeEnterViewModel
    private var enterCancellable: AnyCancellable?
    @EnvironmentObject var pincodeViewModel: EnterPincodeViewModel
    @EnvironmentObject var passwordViewModel: EnterPasswordViewModel

    var body: some View {
        loginTypeView()
    }
    
    @ViewBuilder
    private func loginTypeView() -> some View {
        switch viewModel.internalStage {
        case .startPincode:
            EnterPincodeView().environmentObject(pincodeViewModel).onReceive(pincodeViewModel.$stage) { viewModel.externalStage.send($0) }
        case .startPassword:
            EnterPasswordView().environmentObject(passwordViewModel).onReceive(passwordViewModel.$stage) { viewModel.externalStage.send($0) }
        default: ProgressView()
        }
    }
}

