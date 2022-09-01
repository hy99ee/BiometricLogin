import Foundation
import SwiftUI
import Combine

let primaryColor = Color(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)

protocol CoordinatorViewType: View {
    var viewModel: PincodeViewModel { get }
    
    func view() -> AnyView
}

struct PincodeView: View {
    @EnvironmentObject var viewModel: PincodeViewModel

    var body: some View {
        view()
    }
    
    @ViewBuilder
    func view() -> some View {
        switch viewModel.state {
        case EnterPincodeState.start:
            EnterPincodeView().environmentObject(EnterPincodeViewModel(store: viewModel.store).bindState(to: viewModel))
        case CreatePincodeState.start:
            CreatePincodeView().environmentObject(CreatePincodeViewModel().bindState(to: viewModel))
        default: ProgressView().background(.blue)
        }
    }
}

