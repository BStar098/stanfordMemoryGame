//
//  ContentView.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 24/06/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game:EmojiMemoryGame;
    var body: some View {
        
        AspectVGrid(items:game.cards, aspectRatio: 2/3) { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture{
                        game.choose(card)
                    }
            }
        }.foregroundColor(.red).padding(.horizontal)
        
        }
  
    }
 



struct CardView : View {
    let card: EmojiMemoryGame.Card
    
    var body : some View{
        GeometryReader { geometry in
            ZStack(){
                let shape = RoundedRectangle(cornerRadius: drawingConstants.borderRadius)
                if(card.isFaceUp){
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: drawingConstants.lineWidth)
                    Text(card.content).font(font(size: geometry.size))
                } else if (card.isMatched){ shape.opacity(0) }
                else {
                    Text(card.content).font(.title)
                    shape.fill()
                }
            }
        }
    }
    
    private func font(size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * drawingConstants.contentScaling)
    }
    
    //We put the constants here so we can reuse them throughout the codebase
    private struct drawingConstants {
        static let borderRadius : CGFloat = 10
        static let lineWidth : CGFloat = 3
        static let contentScaling : CGFloat = 0.75
    }
    
}

    
    

    

    
    struct ContentView_Previews: PreviewProvider {
        static let game=EmojiMemoryGame()
        static var previews: some View {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
        }
    }

