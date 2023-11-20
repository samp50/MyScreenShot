//
//  LottieView.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 11/15/23.
//

import Foundation
import Lottie
import SwiftUI
import CoreMotion

struct LottieView: UIViewRepresentable {
    @State var animationName: String
    
    let loopMode: LottieLoopMode

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        var animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = loopMode
        return animationView
    }
}
