import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel

    var body: some View {
        Text("CreatePincodeView")
        EnterPincodeView().environmentObject(EnterPincodeViewModel(store: AuthenticateStore()).bindState(to: viewModel))
    }
}
