import Foundation
import SwiftUI

struct CreatePincodeView: View {
    @EnvironmentObject var viewModel: CreatePincodeViewModel
    @State var isAnimating = false
    
    @ViewBuilder
    private var rightButtonView: some View {
        EmptyView()
    }

    private var rightButton: PincodeFieldActionButton {(
        view: AnyView(rightButtonView),
        action: { }
    )}

    @ViewBuilder
    private var leftButtonView: some View {
        EmptyView()
    }

    private var leftButton: PincodeFieldActionButton {(
        view: AnyView(leftButtonView),
        action: {  }
    )}

    private var pincodeFieldConfiguration: PincodeActionButtonsConfiguration {
        .init(rightButton: rightButton, leftButton: leftButton)
    }

    var body: some View {
        VStack {
            VStack {
                Spacer()

                Text("Enter new pincode")
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
            PincodeFieldView(with: pincodeFieldConfiguration, receiver: viewModel.numberClick).padding()
        }
        .onReceive(viewModel.$state) { value in
            withAnimation(isAnimating ? Animation.default : .easeInOut(duration: 0.5).repeatForever()) {
                isAnimating = {
                    if case let CreatePincodeState.request(status) = value {
                        return status ? true : false
                    } else {
                        return false
                    }
                }()
            }
        }
    }
}


