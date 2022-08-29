import SwiftUI
import Combine

struct EnterPincodeView: View {
    @EnvironmentObject var viewModel: EnterPincodeViewModel
    @SwiftUI.State var pinsSize = 35.0
    @SwiftUI.State var isAnimating = false
    
    private let primaryColor = Color.init(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(systemName: "gear")
                    .font(.system(size: 50))
                Text(viewModel.store.username)
                    .padding(3)
                    .font(.system(size: 20))
                    .foregroundColor(.init(white: 0.35))
                    .textCase(.uppercase)
        
                
                Text(viewModel.pinsVisible)
                    .font(.system(size: 33))
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 100, maxHeight: 100, alignment: .center)
                    .foregroundColor(primaryColor)
                Spacer()
            }
            .padding()
            
            VStack {
                ForEach(viewModel.rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: 0) {
                        Spacer(minLength: 13)
                        ForEach(row, id: \.self) { column in
                            createButton(column)
                                .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                                .opacity(isAnimating ? 0.5 : 1)
                        }
                    }
                }
            }
            
            .onReceive(viewModel.$state) { value in
                withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                    isAnimating = {
                        if case let PincodeState.request(status) = value {
                            return status ? true : false
                        } else {
                            return false
                        }
                    }()
                }
            }
            .padding()
        }
    }
    
    
    func createButton(_ column: String) -> some View {
        Button(action:
            createButtonAction(column)
               , label: {
            numbersLabels(column)
                .foregroundColor(primaryColor)
        })
        .disabled(isAnimating)
    }
    
    @ViewBuilder
    private func numbersLabels(_ str: String) -> some View {
        switch str {
        case PincodeActions.logout.rawValue: Image(systemName: "house").font(.system(size: 25))
        case PincodeActions.login.rawValue: Image(systemName: viewModel.pinsVisible.isEmpty ? { viewModel.canEvaluatePolicy ? "face.smiling" : "" }() : "chevron.backward" ).font(.system(size: 27))
        default: Text(str).font(.system(size: 40))
        }
    }
    
    func createButtonAction(_ str: String) -> () -> Void {
        switch str {
        case PincodeActions.logout.rawValue: return { viewModel.logoutRequest.send() }
        case PincodeActions.login.rawValue: return { viewModel.pinsVisible.isEmpty ? viewModel.authenticateRequest.send() : viewModel.removeClick.send() }
        default: return { if let number = Int(str) { viewModel.numberClick.send(number) } }
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
