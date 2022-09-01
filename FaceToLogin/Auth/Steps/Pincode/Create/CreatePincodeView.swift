import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel

    var body: some View {
        EmptyView()
//        PincodeFieldView(isAnimation: $isAnimating, rows: viewModel.rows, createButton: createButton)
        
    }
}

struct CreatePincodeView_Previews: PreviewProvider {

    static var previews: some View {
        CreatePincodeView().environmentObject(CreatePincodeViewModel())
    }
}
