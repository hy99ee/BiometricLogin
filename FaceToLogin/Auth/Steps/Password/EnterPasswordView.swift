import SwiftUI
import Combine

struct EnterPasswordView: View {
    @EnvironmentObject var viewModel: EnterPasswordViewModel
//    @Environment(\.presentationMode) var presentationMode

    private var anyCancellable: AnyCancellable? = nil

    var body: some View {
        VStack {
            Button("Save") {
                viewModel.loginRequest.send(())
            }
        }
    }
}

