//
//  Cardify.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 15/09/2023.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
   
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{rotation}
        set{rotation=newValue}
    }
    
    var rotation : Double
   
    func body(content: Content) -> some View {
        ZStack(){
            let shape = RoundedRectangle(cornerRadius: drawingConstants.borderRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: drawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)

        }.rotation3DEffect(.degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
}

private struct drawingConstants {
    static let borderRadius : CGFloat = 10
    static let lineWidth : CGFloat = 3
}
