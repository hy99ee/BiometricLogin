import SwiftUI

struct PasscodeFieldView: View {
    @EnvironmentObject var passcode: Passcode

    var body: some View {
        Text(passcode.visiblePasscode)
            .font(.system(size: 50))
            .multilineTextAlignment(.center)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                   maxHeight: 44,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
        
    }
}
