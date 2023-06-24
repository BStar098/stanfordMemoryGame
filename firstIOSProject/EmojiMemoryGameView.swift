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
        VStack{
            ScrollView
            {
                LazyVGrid(columns:[GridItem(.adaptive(minimum:80))]){
                    ForEach( game.cards) {card in
                        CardView(card: card)
                            .aspectRatio(2/3,contentMode:.fit)
                            .onTapGesture{
                                game.choose(card)
                            }
                    }
                }
            }.foregroundColor(.red)
                .padding(.horizontal)
            Button("Shuffle") {
                game.shuffle()
            }
        }
    }
    
}

    struct CardView : View {
        let card: EmojiMemoryGame.Card
        
        var body : some View{
            ZStack(){
                let shape = RoundedRectangle(cornerRadius:25)
                if(card.isFaceUp){
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth:5)
                    Text(card.content).font(.title)
                } else if (card.isMatched){
                    shape.opacity(0)
                }
                else {
                    Text(card.content).font(.title)
                    shape.fill()

                }
                
            }
            
            
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

