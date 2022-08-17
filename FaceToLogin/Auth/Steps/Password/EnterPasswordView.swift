import SwiftUI
import Combine

struct EnterPasswordView: View {
    @EnvironmentObject var viewModel: EnterPasswordViewModel
//    @Environment(\.presentationMode) var presentationMode

    private var anyCancellable: AnyCancellable? = nil

    var body: some View {
        HStack {


            Spacer()
            Button("Close") {
//                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        Spacer()
        

        VStack {
            Button("Save") {
                viewModel.saveUser()
            }
            .padding()

        }
    }
}

