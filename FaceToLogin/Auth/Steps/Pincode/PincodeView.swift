import Foundation
import SwiftUI
import Combine

let primaryColor = Color(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)
let failureColor = Color(red: 245, green: 72/255, blue: 66/255, opacity: 1.0)

protocol CoordinatorViewType: View {
    var viewModel: PincodeViewModel { get }
    
    func view() -> AnyView
}

struct PincodeView: View {
    @EnvironmentObject var viewModel: PincodeViewModel
    var body: some View {
        switch viewModel.state {
        case PincodeState.enter:
            EnterPincodeView().environmentObject(EnterPincodeViewModel(store: viewModel.store).bindState(receiver: viewModel))
        case PincodeState.create:
            CreatePincodeView().environmentObject(CreatePincodeViewModel(store: viewModel.store).bindState(receiver: viewModel))
        default: ProgressView()
        }
    }
}

struct PincodeView_Previews: PreviewProvider {
    static var previews: some View {
        PincodeView().environmentObject(PincodeViewModel(store: AuthenticateStore(), mapper: PincodeMockMapper()))
    }
}
