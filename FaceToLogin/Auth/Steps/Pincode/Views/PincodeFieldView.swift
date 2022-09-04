import SwiftUI

struct InputPincodeView: View {
    @Binding var password: String
    let placeholder: String
    
    
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $password)
                .font(.system(size: 70))
                .multilineTextAlignment(.center)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                       maxHeight: 44,
                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                
        }
    }
}
