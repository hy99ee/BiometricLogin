//
//  FaceToLoginApp.swift
//  FaceToLogin
//
//  Created by hy99ee on 04.08.2022.
//

import SwiftUI

@main
struct FaceToLoginApp: App {
    private let store = AuthenticateStore()
    var body: some Scene {
        WindowGroup {
            HomeEnterView()
                .environmentObject(HomeEnterViewModel(mapper: HomeStateMapper()))
        }
    }
}
