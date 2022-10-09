import SwiftUI

struct PasscodeFieldView: View {
    @EnvironmentObject var passcode: Passcode
    @State private var isFull = false

    var body: some View {
        Text(passcode.visiblePasscode)
            .opacity(isFull ? 0.6 : 1)
            .font(.system(size: 50))
            .multilineTextAlignment(.center)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                   maxHeight: 44,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
            .onReceive(passcode.$isFull) { value in
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isFull = value
                }
            }
        
    }
}
