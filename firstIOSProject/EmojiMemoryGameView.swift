//
//  ContentView.swift
//  firstIOSProject
//
//  Created by Santiago Lucero on 24/06/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game:EmojiMemoryGame;
    
    @State private var dealt = Set<Int>();
    private func deal (_ card:EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    private func isUndealt (_ card:EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    var body: some View {
        VStack{
            AspectVGrid(items:game.cards, aspectRatio: 2/3) { card in
                if isUndealt(card) || card.isMatched && !card.isFaceUp {
                    Color.clear
                } else {
                    CardView(card: card)
                        .padding(4)
                        .transition(.push(from: .bottom).animation(.linear(duration: 3)))
                        .onTapGesture{
                            withAnimation(.easeInOut(duration: 0.5)) {
                                game.choose(card)
                            }
                        }
                }
            }.onAppear{
                withAnimation {
                    for card in game.cards {
                        deal(card)
                    }
                }
                game.shuffle()
            }.foregroundColor(.red).padding(.horizontal)
            Button("Shuffle"){
                withAnimation{
                    game.shuffle()
                }
                
            }
        }
       
        
        }
  
    }
 



struct CardView : View {
    let card: EmojiMemoryGame.Card
    
    var body : some View{
        GeometryReader { geometry in
                ZStack(){
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 358-90))
                        .padding(drawingConstants.timerPadding)
                        .opacity(drawingConstants.timerOpacity)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(.linear(duration:0.8).repeatForever(autoreverses:false), value: card.isMatched)
                        .font(font(size: geometry.size))
                        .scaleEffect(scale(thatFits: geometry.size))
                }.cardify(isFaceUp: card.isFaceUp)
                    }
                }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (drawingConstants.fontSize/drawingConstants.fontScale)
    }
    
    private func font(size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * drawingConstants.contentScaling)
    }
    }
    
    


//We put the constants here so we can reuse them throughout the codebase
    private struct drawingConstants {
        static let borderRadius : CGFloat = 10
        static let lineWidth : CGFloat = 3
        static let contentScaling : CGFloat = 0.7
        static let fontScale : CGFloat = 0.7
        static let fontSize : CGFloat = 46
        static let timerPadding: CGFloat = 5
        static let timerOpacity: CGFloat = 0.5
    }

    extension View {
        func cardify(isFaceUp:Bool) -> some View{
            self.modifier(Cardify(isFaceUp: isFaceUp))
        }
    }

  
    
    struct ContentView_Previews: PreviewProvider {
        static let game = EmojiMemoryGame()
        static var previews: some View {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
        }
    }

