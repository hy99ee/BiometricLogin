//
//  EnterPincodeField.swift
//  FaceToLogin
//
//  Created by hy99ee on 25.08.2022.
//

import SwiftUI

//struct BounceAnimationView: View {
//    let characters: Array<String.Element>
//    
//    @SwiftUI.State var offsetYForBounce: CGFloat = -50
//    @SwiftUI.State var opacity: CGFloat = 0
//    @SwiftUI.State var baseTime: Double
//    
//    init(text: String, startTime: Double){
//        self.characters = Array(text)
//        self.baseTime = startTime
//    }
//    
//    var body: some View {
//        HStack(spacing:0){
//            ForEach(0..<characters.count) { num in
//                Text(String(self.characters[num]))
//                    .font(.custom("HiraMinProN-W3", fixedSize: 24))
//                    .offset(x: 0.0, y: offsetYForBounce)
//                    .opacity(opacity)
//                    .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1).delay( Double(num) * 0.1 ), value: offsetYForBounce)
//            }
//
//            .onAppear{
//                DispatchQueue.main.asyncAfter(deadline: .now() + (0.8 + baseTime)) {
//                    opacity = 1
//                    offsetYForBounce = 0
//                }
//            }
//        }
//    }
//}
struct AnimatableSystemFontModifier: ViewModifier, Animatable {
    var size: Double
    var weight: Font.Weight
    var design: Font.Design

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func animatableSystemFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
