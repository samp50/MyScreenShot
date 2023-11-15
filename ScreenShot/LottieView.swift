//
//  LottieView.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 11/15/23.
//

import Foundation
import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    @State var animationName: String
    
    let loopMode: LottieLoopMode

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}
