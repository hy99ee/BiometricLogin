import SwiftUI
import Combine

struct EnterPincodeView: View {
    @EnvironmentObject var viewModel: EnterPincodeViewModel
    @SwiftUI.State var animationAmount = 1.0
    @SwiftUI.State var pinsSize = 30.0
    @SwiftUI.State var isAnimating = false

    private let primaryColor = Color.init(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                    Text(viewModel.pinsVisible)
                    .animatableSystemFont(size: pinsSize)
                    .onReceive(viewModel.$state) { value in
                        withAnimation(.easeInOut(duration: 0.5).repeatCount(3)) {
                            pinsSize = { if case let PincodeState.request(status) = value { return status ? 40 : 30 } else { return 30 } }()
                        }
                    }
                Spacer()
            }
            
            .foregroundColor(primaryColor)
            
            VStack {
                ForEach(viewModel.rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: 0) {
                        Spacer(minLength: 13)
                        ForEach(row, id: \.self) { column in
                            createButton(column)
                        }
                    }
                }
            }
            Spacer(minLength: 40)
        }
        
    }
    
    func createButton(_ column: String) -> some View {
        Button(action:
                viewModel.createButtonAction(column)
        , label: {
            numbersLabels(column)
                .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                .foregroundColor(primaryColor)
        })
    }

    @ViewBuilder
    private func numbersLabels(_ str: String) -> some View {
        switch str {
        case PincodeActions.login.rawValue: Image(systemName: "face.smiling").font(.system(size: 30))
        case PincodeActions.logout.rawValue: Image(systemName: "chevron.backward").font(.system(size: 30))
        default: Text(str).font(.system(size: 40))
        }
    }
    

    
}

struct EnterPincodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterPincodeView().environmentObject(EnterPincodeViewModel(store: AuthenticateStore()))
    }
}

enum PincodeActions: String {
    case login
    case logout
}
